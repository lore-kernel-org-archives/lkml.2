Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750Ab1HNASg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Aug 2011 20:18:36 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:42924 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589Ab1HNASe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Aug 2011 20:18:34 -0400
Date: Sun, 14 Aug 2011 09:18:27 +0900
From: Mattia Dongili <malattia@gmail.com>
To: Dave Jones <davej@redhat.com>, Jonathan Nieder <jrnieder@gmail.com>,
        cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Tony Lindgren <tony@atomide.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [BUG?] Moving drivers to drivers/cpufreq/ causes all to be loaded
Message-ID: <20110814001826.GB6432@kamineko.org>
References: <20110414094447.GA1611@n2100.arm.linux.org.uk>
 <alpine.LFD.2.00.1104211629300.24613@xanadu.home>
 <201104261605.26791.arnd@arndb.de>
 <201104261904.45923.rjw@sisk.pl>
 <20110426181508.GB1908@redhat.com>
 <20110813154638.GA1494@elie.gateway.2wire.net>
 <20110813190246.GA10412@elie.gateway.2wire.net>
 <20110813211142.GA1536@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110813211142.GA1536@redhat.com>
X-Message-Flag: Cranky? Try Free Software instead!
X-Operating-System: Linux 3.0.0-rc7+ x86_64
X-Editor: Vim http://www.vim.org/
X-Disclaimer: Buh!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 13, 2011 at 05:11:42PM -0400, Dave Jones wrote:
> On Sat, Aug 13, 2011 at 02:02:46PM -0500, Jonathan Nieder wrote:
>  > Jonathan Nieder wrote:
>  > 
>  > >  (1) This is still incredibly fragile.  What *should* cpufrequtils
>  > >      be doing to get the modules it needs?
>  > >
>  > >  (2) Using the 3.0 or later kernel with old userspace gives bad
>  > >      results (e.g., 30% increase in power consumption for one
>  > >      reporter).  That's a regression.
>  > 
>  > The "30% increase" part was an unrelated bug (i915.i915_enable_rc6=1
>  > brings power consumption back to normal), for those who were
>  > wondering. :)
>  > 
>  > Old userspace automatically loading the wrong cpufreq drivers still
>  > does not seem great to me, though I don't have any great ideas about
>  > how to prevent that (a separate drivers/cpufreq-drivers/ directory
>  > does not sound too appealing).  I guess I'd be most interested in how
>  > to fix (1) first.
> 
> If we have to move stuff again, we could do drivers/cpufreq/x86/ etc..
> Even if we do that though, you really want to fix that userspace, because
> you're right that "load everything and see what sticks" is fragile,
> and pure luck that it ever did the right thing.

not sure why this bug landed here finally, it was clearly an
overlook in the Debian startup script and it's only specific to Debian.

The "load everything" part was not for cpu drivers but for governors
and helpers that used to sit into drivers/cpufreq alone.
The cpu driver loading part is fairly complex (or yes, messy as you say)
and not too dissimilar than the one from fedora.

-- 
mattia
:wq!
