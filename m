Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753767Ab0GIVwK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 17:52:10 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34103 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751592Ab0GIVwI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 17:52:08 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: tim.gardner@canonical.com
Subject: Re: [Bug #16294] [Q35 bisected] hang at init of i915 driver
Date: Fri, 9 Jul 2010 23:50:05 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc4; KDE/4.4.4; x86_64; ; )
Cc: Kees Cook <kees@outflux.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
References: <-IGZ64uxA6G.A.P0H.bLmNMB@chimera> <201007092256.48672.rjw@sisk.pl> <4C3790CA.5070009@canonical.com>
In-Reply-To: <4C3790CA.5070009@canonical.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007092350.05954.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, July 09, 2010, Tim Gardner wrote:
> On 07/09/2010 02:56 PM, Rafael J. Wysocki wrote:
> > On Friday, July 09, 2010, Kees Cook wrote:
> >> Hi Rafael,
> >>
> >> On Fri, Jul 09, 2010 at 01:41:39AM +0200, Rafael J. Wysocki wrote:
> >>> The following bug entry is on the current list of known regressions
> >>> from 2.6.34.  Please verify if it still should be listed and let the tracking team
> >>> know (either way).
> >>
> >> Yup, this is still a regression.  The fix is trivial (see below).
> >
> > Thanks for the update.
> >
> >>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16294
> >>> Subject		: [Q35 bisected] hang at init of i915 driver
> >>> Submitter	: Kees Cook<kees@outflux.net>
> >>> Date		: 2010-06-25 18:20 (14 days old)
> >>> First-Bad-Commit: http://git.kernel.org/linus/f1befe71fa7a79ab733011b045639d8d809924ad
> >>
> >> diff --git a/drivers/char/agp/intel-gtt.c b/drivers/char/agp/intel-gtt.c
> >> index 9344216..0d9007d 100644
> >> --- a/drivers/char/agp/intel-gtt.c
> >> +++ b/drivers/char/agp/intel-gtt.c
> >> @@ -1229,6 +1229,7 @@ static int intel_i915_get_gtt_size(void)
> >>   				(gmch_ctrl&  G33_PGETBL_SIZE_MASK));
> >>   			size = 512;
> >>   		}
> >> +		size = 1024;
> >>   	} else {
> >>   		/* On previous hardware, the GTT size was just what was
> >>   		 * required to map the aperture.
> >
> > Rafael
> > --
> 
> Rafael - I forgot to Cc you on the patch I just sent to Dave Arlie. Kees 
> has confirmed that it fixes his problem.
> 
> http://marc.info/?l=linux-kernel&m=127870855118533&w=2

OK, I've added the patch information to the bug entry.

Rafael
