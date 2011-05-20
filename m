Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934329Ab1ETDod (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 23:44:33 -0400
Received: from eu1sys200aog103.obsmtp.com ([207.126.144.115]:53254 "EHLO
	eu1sys200aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932101Ab1ETDoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 23:44:32 -0400
Message-ID: <4DD5E38D.8010709@st.com>
Date: Fri, 20 May 2011 09:14:13 +0530
From: viresh kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: "Koul, Vinod" <vinod.koul@intel.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        Armando VISCONTI <armando.visconti@st.com>,
        Shiraz HASHIM <shiraz.hashim@st.com>,
        "viresh.linux@gmail.com" <viresh.linux@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] dw_dmac: Replace subsys_init() with arch_initcall()
References: <f06f05e982c6182565a7fee1f7d6396cae895133.1305521318.git.viresh.kumar@st.com>	 <1305561993.28926.73.camel@vkoul-udesk3>	<4DD1F443.1040205@st.com>	 <1305603818.28926.82.camel@vkoul-udesk3>	<4DD20D89.9020402@st.com>	 <BANLkTi=zrr4==Uatq3zbdE1K+1_9ELOBZQ@mail.gmail.com>	 <4DD4A8D8.2040109@st.com> <1305804238.28926.302.camel@vkoul-udesk3>
In-Reply-To: <1305804238.28926.302.camel@vkoul-udesk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/19/2011 04:53 PM, Koul, Vinod wrote:
> On Thu, 2011-05-19 at 10:51 +0530, viresh kumar wrote:
>> On 05/18/2011 05:51 PM, Linus Walleij wrote:
>>>>> @Linus: What do you say? Can we get back to module_init() for amba-pl022?
>>>>> And subsys_initcall() for DMA.
>>> No, but I sent a patch that will make it possible to have both
>>> as subsys_init(), check it out, it seems to work for me.
> I am okay with this approach...
> 
> Linus, though I am still not convinced why st-dma would need to be
> arch_init?
> 

I think you missed this. In Linus's patch following is also done.

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index fab68a5..7d3e93d 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -2951,4 +2951,4 @@ int __init stedma40_init(void)
 {
        return platform_driver_probe(&d40_driver, d40_probe);
 }
-arch_initcall(stedma40_init);
+subsys_initcall(stedma40_init);

-- 
viresh
