Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754581Ab2FYGJv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 02:09:51 -0400
Received: from eu1sys200aog104.obsmtp.com ([207.126.144.117]:43452 "EHLO
	eu1sys200aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753172Ab2FYGJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 02:09:50 -0400
Message-ID: <4FE8009A.4020503@st.com>
Date: Mon, 25 Jun 2012 11:39:30 +0530
From: Rajeev kumar <rajeev-dlh.kumar@st.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the sound-asoc tree
References: <20120625141140.c6d71065dab293005514ee1a@canb.auug.org.au>
In-Reply-To: <20120625141140.c6d71065dab293005514ee1a@canb.auug.org.au>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On 6/25/2012 9:41 AM, Stephen Rothwell wrote:
> Hi all,
>
> After merging the sound-asoc tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
>
> ERROR: "clk_disable" [sound/soc/dwc/designware_i2s.ko] undefined!
> ERROR: "clk_get" [sound/soc/dwc/designware_i2s.ko] undefined!
> ERROR: "clk_enable" [sound/soc/dwc/designware_i2s.ko] undefined!
> ERROR: "clk_put" [sound/soc/dwc/designware_i2s.ko] undefined!

I have checked this on ARM platform where these definitions are 
available (clk_get/clk_put* variants are usually used by ARM platforms).

To ensure compilation does not fail on x86_64 we can do either of three 
things:

1. Protecting clk_get/clk_put* calls under macro 'CONFIG_HAVE_CLK' in 
the driver.

2. Adding a check in Kconfig for HAVE_CLK.
(But that will limit the compilation of this driver for only platforms 
which are ARM based/or similar).

3. We can pick the patches circulated by Viresh Kumar where we don't 
have HAVE_CLK defined for x86_64, then the inline routines like 
following should come into play:

static inline unsigned long clk_get_rate(struct clk *clk)
{
         return 0;
}

See the patches for the same here:
http://lkml.org/lkml/2012/4/24/154

Please let me know your opinion.

Best Regards
Rajeev





