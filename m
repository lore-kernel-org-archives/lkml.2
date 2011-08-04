Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872Ab1HDInT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 04:43:19 -0400
Received: from eu1sys200aog116.obsmtp.com ([207.126.144.141]:37074 "EHLO
	eu1sys200aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751836Ab1HDInN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 04:43:13 -0400
Message-ID: <4E3A5B89.9000703@st.com>
Date: Thu, 4 Aug 2011 14:12:49 +0530
From: viresh kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: "Koul, Vinod" <vinod.koul@intel.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Pratyush ANAND <pratyush.anand@st.com>,
        Rajeev KUMAR <rajeev-dlh.kumar@st.com>,
        Armando VISCONTI <armando.visconti@st.com>,
        Bhupesh SHARMA <bhupesh.sharma@st.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vipin KUMAR <vipin.kumar@st.com>, Shiraz HASHIM <shiraz.hashim@st.com>,
        Amit VIRDI <Amit.VIRDI@st.com>,
        Vipul Kumar SAMAR <vipulkumar.samar@st.com>,
        "viresh.linux@gmail.com" <viresh.linux@gmail.com>,
        Deepak SIKRI <deepak.sikri@st.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH V2 08/20] dmaengine/amba-pl08x: support runtime PM
References: <cover.1312190881.git.viresh.kumar@st.com>	 <bc59bbd3709a7af1723d37ab846bf44c6867c00e.1312190881.git.viresh.kumar@st.com>	 <20110803123953.GB23953@n2100.arm.linux.org.uk>  <4E3A2BFC.3070907@st.com>	 <1312436185.1536.570.camel@vkoul-udesk3>  <4E3A3CB7.8040505@st.com> <1312442926.1539.0.camel@vkoul-udesk3>
In-Reply-To: <1312442926.1539.0.camel@vkoul-udesk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/04/2011 12:58 PM, Koul, Vinod wrote:
>> > 
>> > Until this point we are not touching the registers at all. And they will
>> > accessed after this point only.
> But from maintainability POV it should be at the start.
> 

Sorry for missing this earlier, I looked at the code again and
realized why i put it at the end of the routine.

The routine looks like this

        for (all channels)
                if (!ch->serving)
                        break;

        if (i == pl08x->vd->channels) {
                /* No physical channel available, cope with it */
                return NULL;
        }

        pm_runtime_get_sync(&pl08x->adev->dev);

So, this has to be put at end only. We don't want to call this if no physical
channel is free.

-- 
viresh
