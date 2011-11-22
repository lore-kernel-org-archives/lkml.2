Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355Ab1KVTZd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 14:25:33 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:42889 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754656Ab1KVTXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 14:23:10 -0500
X-Sasl-enc: 43Qvej975cp2Gvv3q/iFYo1aLDG1tCpLzklyKZP7IgSa 1321989789
Date: Tue, 22 Nov 2011 11:13:47 -0800
From: Greg KH <greg@kroah.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Mike Turquette <mturquette@ti.com>, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, jeremy.kerr@canonical.com,
        broonie@opensource.wolfsonmicro.com, tglx@linutronix.de,
        linus.walleij@stericsson.com, amit.kucheria@linaro.org,
        dsaxena@linaro.org, patches@linaro.org, linaro-dev@lists.linaro.org,
        paul@pwsan.com, grant.likely@secretlab.ca, sboyd@quicinc.com,
        shawn.guo@freescale.com, skannan@quicinc.com, magnus.damm@gmail.com,
        arnd.bergmann@linaro.org, eric.miao@linaro.org,
        richard.zhao@linaro.org
Subject: Re: [PATCH v3 5/5] clk: export tree topology and clk data via sysfs
Message-ID: <20111122191347.GB4844@kroah.com>
References: <1321926047-14211-1-git-send-email-mturquette@linaro.org>
 <1321926047-14211-6-git-send-email-mturquette@linaro.org>
 <20111122154900.GB18954@kroah.com>
 <CAPtuhThPQtWwihE8aGru55k87oV7QOr=O836TTJ+=30d6dtVhA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPtuhThPQtWwihE8aGru55k87oV7QOr=O836TTJ+=30d6dtVhA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 09:57:41AM -0800, Mike Turquette wrote:
> > Ah, comments like this warm my heart.
> >
> > Come on, no abusing the kobject code please, if have problems with how
> > the kernel core works, and it doesn't do things you want it to, then why
> > not change it to work properly for you, or at the least, ASK ME!!!
> 
> Ok, I'm asking you now.  There are two ways to solve this problem:
> 
> 1) have kobject core create the lists linking the objects but defer
> allocations and any interactions with sysfs until later in the boot
> sequence, OR
> 
> 2) my code can create a list of clks (the same way that clkdev does)
> and defer kobject/sysfs stuff until later, which walks the list made
> during early-boot
> 
> #1 is most closely aligned with the code I have here, #2 presents
> challenges that I haven't really though through.  I know that OMAP
> uses the clk framework VERY early in it's boot sequence, but as long
> as the per-clk data is properly initialized then it should be OK.
> 
> What do you think?

#3 - use debugfs and don't try to create a sysfs interface for the clock
structures :)

thanks,

greg k-h
