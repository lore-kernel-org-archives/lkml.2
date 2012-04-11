Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933483Ab2DKWMg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 18:12:36 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:44097 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933454Ab2DKWMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 18:12:35 -0400
Date: Wed, 11 Apr 2012 18:12:29 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@oneiric
To: Jesper Juhl <jj@chaosbits.net>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: almost time to run my kernel source cleaning scripts again?
In-Reply-To: <alpine.LNX.2.00.1204112350590.2137@swampdragon.chaosbits.net>
Message-ID: <alpine.DEB.2.02.1204111805020.10690@oneiric>
References: <alpine.DEB.2.02.1204111700170.4733@oneiric> <alpine.LNX.2.00.1204112350590.2137@swampdragon.chaosbits.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Apr 2012, Jesper Juhl wrote:

> On Wed, 11 Apr 2012, Robert P. J. Day wrote:
>
> >
> >   it's been a while so i was thinking of firing up my scripts to
> > peruse the source tree looking for oddities/inconsistencies/whatever
> > (unless someone else is already doing that).
> >
> >   one example is looking for preprocessor tests of symbols that aren't
> > defined in any Kconfig file, and i can focus on any part of the source
> > tree.  for example, if i run that script against drivers/mmc, i get:
> >
> > >>>>> MMC_MSM7X00A_RESUME_IN_WQ
> > drivers/mmc/host/msm_sdcc.c:1408:#ifdef CONFIG_MMC_MSM7X00A_RESUME_IN_WQ
> >
> > telling me that a source file is testing a CONFIG variable that
> > doesn't exist.
> >
> >   the scripts are available online
>
> I'd be interrested in taking a look at those. Got a URL where I can grab
> them?

  as long as you promise not to snicker at them, here are my most
"popular" ones:

http://www.crashcourse.ca/wiki/index.php/Kernel_cleanup_scripts

  i typically used the word "unused" to refer to variables defined in
Kconfig files that simply aren't referenced anymore -- not fatal in
any sense, just leftover detritus when people removed code but forgot
to take out the corresponding Kconfig entry.

  i use the word "badref" for instances where a CONFIG_ variable *is*
tested in a source file, but doesn't exist in a Kconfig file -- that's
typically more serious.  or sometimes, it's just a typo.

  just now, i ran the "find_badref_configs" script against the entire
drivers/ directory -- first few lines of output were:

>>>>> ACORNSCSI_CONSTANTS
drivers/scsi/arm/acornscsi.c:106:#undef CONFIG_ACORNSCSI_CONSTANTS
drivers/scsi/arm/acornscsi.c:413:#ifdef CONFIG_ACORNSCSI_CONSTANTS
drivers/scsi/arm/acornscsi.c:491:#ifdef CONFIG_ACORNSCSI_CONSTANTS
... snip ...

which i recognize by now since that's been there, like, *forever*.

  anyway, feel free to play; i might do some tweaking on those over
the next few days.

rday

-- 

========================================================================
Robert P. J. Day                                 Ottawa, Ontario, CANADA
                        http://crashcourse.ca

Twitter:                                       http://twitter.com/rpjday
LinkedIn:                               http://ca.linkedin.com/in/rpjday
========================================================================
