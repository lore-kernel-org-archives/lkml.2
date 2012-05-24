Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932896Ab2EXMme (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 08:42:34 -0400
Received: from mga01.intel.com ([192.55.52.88]:9454 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756874Ab2EXMmd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 08:42:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="156705843"
Date: Thu, 24 May 2012 20:42:28 +0800
From: Fengguang Wu <wfg@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Inki Dae <inki.dae@samsung.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Compile error: =?utf-8?Q?drivers=2Fvid?=
 =?utf-8?B?ZW8vYmFja2xpZ2h0L2xjZC5jOjM1Ojc6IGVycm9yOiDigJhGQl9FQVJMWV9F?=
 =?utf-8?B?VkVOVF9CTEFOS+KAmQ==?= undeclared (first use in this function)
Message-ID: <20120524124228.GA20635@localhost>
References: <20120523111329.GA19959@localhost>
 <20120523132941.befd211c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120523132941.befd211c.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 01:29:41PM -0700, Andrew Morton wrote:
> On Wed, 23 May 2012 19:13:29 +0800
> wfg@linux.intel.com wrote:
> 
> > tree:   git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git akpm
> > head:   900cd0fca590e51f720f44f63082b7934d0ff42d
> > commit: 07e86d6ba94cc94da2463521ef3def43ed55607d (180/308)
> > config: i386-randconfig-mm1
> > 
> > drivers/video/backlight/lcd.c:35:7: error: ‘FB_EARLY_EVENT_BLANK’ undeclared (first use in this function)
> > drivers/video/backlight/lcd.c:35:7: note: each undeclared identifier is reported only once for each function it appears in
> > drivers/video/backlight/lcd.c:36:7: error: ‘FB_R_EARLY_EVENT_BLANK’ undeclared (first use in this function)
> > 
> > Andrew, this should be fixable by moving the immediately following
> > patch "fbdev: add events for early fb event support" before this one.
> 
> Whoa.  What are you actually doing over there?  A build test for each and every
> patch in linux-next?  Impressed!

Yup.  I've been running 32 CPU cores all day&night, which build tests
~1300 commits and creates ~25000 kernel images each day.

To be exact, I'm build testing the akpm-base..akpm part of linux-next.
For the other parts of linux-next, I'm directly build testing the
trees/branches that linux-next pulls from, so as to find problems and
give feedback to the developers *ASAP*. The ultimate goal is to build
test each and every commit once they hit any topic/test branch,
hopefully before they are merged into some for-next branches.

The build test system is still catching up to test lots of old commits
and build up database of "known" build errors and warnings. Once
ready, I'll switch it into auto email notification mode. So in future,
when someone "git push" new patches, he will likely receive emails about
new build errors/warnings (if there are any) in one hour.

Thanks,
Fengguang
