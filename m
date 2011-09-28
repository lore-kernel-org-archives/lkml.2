Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751701Ab1I1JzL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 05:55:11 -0400
Received: from eu1sys200aog115.obsmtp.com ([207.126.144.139]:49581 "EHLO
	eu1sys200aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750931Ab1I1JzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 05:55:09 -0400
Message-ID: <4E82EEE1.3020706@st.com>
Date: Wed, 28 Sep 2011 15:24:41 +0530
From: Viresh Kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Alim Akhtar <alim.akhtar@gmail.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "kgene.kim@samsung.com" <kgene.kim@samsung.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 1/1] dmaengine/amba-pl08x: Add support for s3c64xx
 DMAC
References: <1317189007-23033-1-git-send-email-alim.akhtar@samsung.com> <1317189007-23033-2-git-send-email-alim.akhtar@samsung.com> <4E82D0A1.8050203@st.com> <CAGOxZ53qZy+VUM65oK68W088QR=RgQ=cNxOCbO7_WESJesJaVQ@mail.gmail.com>
In-Reply-To: <CAGOxZ53qZy+VUM65oK68W088QR=RgQ=cNxOCbO7_WESJesJaVQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/28/2011 2:20 PM, Alim Akhtar wrote:
> The main difference between Primecell PL080 and samsung variant is in
> LLI control register bit [0:11] is reserved in case of samsung pl080
> and one extra register is add to hold the transfer size at offset
> 0x10. The purpose of cctl1 is store the transfer_size.

So, actually you need to modify pl08x_fill_lli_for_desc() and
pl08x_cctl_bits() routines.

Updating cctl1 on the last lli will not solve your purpose,
and transfers needing more than one lli will fail.
BTW, did you try testing your patch for more than one LLI.

-- 
viresh
