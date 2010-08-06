Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965593Ab0HFV3i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 17:29:38 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:29920 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542Ab0HFV3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 17:29:36 -0400
Date: Fri, 6 Aug 2010 15:29:34 -0600
From: dann frazier <dannf@hp.com>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: linux-kernel@vger.kernel.org,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Thomas Mingarelli <thomas.mingarelli@hp.com>
Subject: Re: [PATCH 00/15] hpwdt: make NMI code a config option (+ other
 cleanup)
Message-ID: <20100806212933.GA10779@ldl.fc.hp.com>
References: <1280274663-9160-1-git-send-email-dannf@hp.com>
 <20100805214102.GA4288@infomag.iguana.be>
 <20100806212648.GA30843@infomag.iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100806212648.GA30843@infomag.iguana.be>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 06, 2010 at 11:26:48PM +0200, Wim Van Sebroeck wrote:
> Hi Dan,
> 
> > So overall: patches look good, but let's re-order the patches a bit (so that we first clean-up the driver and then add the NMI related changes (If we ever need to revert some things then we at least have a clean-driver before we start bisecting the NMI changes)).
> > And secondly: let's try to have the ifdef's out of the init and exit procedures.
> > 
> > If you can look at how we can get rid of the ifdef's in init and exit, then I will reorder the patches and change the 3 timer patches and put that allready in a git tree.
> 
> I reorganised the sequence of patches. I'll sent them to you for verification (and will put a copy in linux-watchdog mailing list).
> 
> the patches now look like:
> watchdog: hpwdt (1/12): clean-up include-files.
> watchdog: hpwdt (2/12): Group options that affect watchdog behavior together
> watchdog: hpwdt (3/12): Group NMI sourcing specific items together
> watchdog: hpwdt (4/12): Despecificate driver from iLO2
> watchdog: hpwdt (5/12): Make x86 assembly ifdef guard more strict
> watchdog: hpwdt (6/12): Introduce SECS_TO_TICKS() macro
> watchdog: hpwdt (7/12): allow full range of timer values supported by hardware
> watchdog: hpwdt (8/12): implement WDIOC_GETTIMELEFT
> watchdog: hpwdt (9/12): hpwdt_pretimeout reorganization
> watchdog: hpwdt (10/12): Construct status message w/ kasprintf and emit it with dev_info
> watchdog: hpwdt (11/12): Use "decoding" instead of "sourcing"
> watchdog: hpwdt (12/12): Make NMI decoding a compile-time option
> 
> (patch 12 can still be improved).

Thanks! I'll work on the #ifdef'ing & get you a new #12

-- 
dann frazier | ProLiant Linux
