Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753782Ab1HDK1y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 06:27:54 -0400
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:57451 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753535Ab1HDK1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 06:27:47 -0400
Message-ID: <4E3A7410.6090108@st.com>
Date: Thu, 4 Aug 2011 15:57:28 +0530
From: viresh kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: "linus.walleij@linaro.org" <linus.walleij@linaro.org>
Cc: "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        Armando VISCONTI <armando.visconti@st.com>,
        Shiraz HASHIM <shiraz.hashim@st.com>, Vipin KUMAR <vipin.kumar@st.com>,
        Rajeev KUMAR <rajeev-dlh.kumar@st.com>,
        Deepak SIKRI <deepak.sikri@st.com>,
        Vipul Kumar SAMAR <vipulkumar.samar@st.com>,
        Amit VIRDI <Amit.VIRDI@st.com>, Pratyush ANAND <pratyush.anand@st.com>,
        Bhupesh SHARMA <bhupesh.sharma@st.com>,
        "viresh.linux@gmail.com" <viresh.linux@gmail.com>
Subject: Re: [PATCH V2 18/20] dmaengine/amba-pl08x: Add support for sg len
 greater than one for slave transfers
References: <cover.1312190881.git.viresh.kumar@st.com> <e404b8f659f6f06709d1adb0bdbe3624bd9a885a.1312190882.git.viresh.kumar@st.com>
In-Reply-To: <e404b8f659f6f06709d1adb0bdbe3624bd9a885a.1312190882.git.viresh.kumar@st.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2011 03:07 PM, Viresh KUMAR wrote:
> @@ -563,6 +565,7 @@ static int pl08x_fill_llis_for_desc(struct pl08x_driver_data *pl08x,
>         u32 cctl, early_bytes = 0;
>         size_t max_bytes_per_lli, total_bytes = 0;

> +       list_for_each_entry(dsg, &txd->dsg_list, node) {
> +               cctl = txd->cctl;
> 
> -       /* We need to count this down to zero */
> -       bd.remainder = txd->len;
> +               bd.srcbus.addr = dsg->src_addr;
> +               bd.dstbus.addr = dsg->dst_addr;
> +               bd.remainder = dsg->len;
> +               bd.srcbus.buswidth = bd.srcbus.maxwidth;
> +               bd.dstbus.buswidth = bd.dstbus.maxwidth;
> 

> +               if (total_bytes != dsg->len) {
> +                       dev_err(&pl08x->adev->dev,
> +                               "%s size of encoded lli:s don't match total txd, transferred 0x%08zx from size 0x%08zx\n",
> +                               __func__, total_bytes, dsg->len);
> +                       return 0;
> +               }
>         }

Correction:

total_bytes must be reinitialized to zero inside list_for_each_entry loop.
As we are comparing it to dsg->len for every dsg.

Will fix this and send with V3.

-- 
viresh
