Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932503Ab1AKRjs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 12:39:48 -0500
Received: from mga11.intel.com ([192.55.52.93]:29064 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753368Ab1AKRjq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 12:39:46 -0500
Message-Id: <1bdc18$j7rfh5@fmsmga002.fm.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,307,1291622400"; 
   d="scan'208";a="645774885"
Date: Tue, 11 Jan 2011 17:39:42 +0000
To: Michal Hocko <mhocko@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.37
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, indan@nul.nu
In-Reply-To: <20110111171744.GA3854@tiehlicka.suse.cz>
References: <AANLkTikKA-nStyNjkdsVa8hd=PFQR3tYTJh3MnfpNkD8@mail.gmail.com> <20110106104816.GA4026@tiehlicka.suse.cz> <20110111171744.GA3854@tiehlicka.suse.cz>
From: Chris Wilson <chris@chris-wilson.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Jan 2011 18:19:17 +0100, Michal Hocko <mhocko@suse.cz> wrote:
> [Let's CC Indan - author of the bugzilla patches]
> 
> On Thu 06-01-11 11:48:16, Michal Hocko wrote:
> > Hi,
> > 
> > On Tue 04-01-11 17:15:45, Linus Torvalds wrote:
> > [...]
> > > We did have another revert to fix hopefullythe last "blank screen"
> > > regression on intel graphics.
> > 
> > It seems that there is still a regression for intel graphic cards
> > backlight. One report is https://bugzilla.kernel.org/show_bug.cgi?id=22672.
> > I can reproduce the problem easily by:
> > xset dpms force standby; sleep 3s; xset dpms force on
> > 
> > backlight doesn't get up (there is really dark picture though which
> > doesn't get brighter by function keys which work normally) after dpms on
> > until I close and open lid. 
> > 
> > The problem wasn't present in 2.6.36
> 
> I can confirm that this problem is not present if both patches from
> bko#22672 are applied on top of 2.6.37 kernel.
> I haven't tried both patches separately, but I can surely try it if it
> makes any sense.

The second patch is wrong in that it will prevent changing resolutions
using the panel fitter. The first patch looks along the right lines, just
misses the possibility that the backlight can be modified by other means.

So hopefully, you just need the first patch.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
