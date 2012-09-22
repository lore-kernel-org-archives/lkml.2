Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179Ab2IVT7Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2012 15:59:25 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54315 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954Ab2IVT7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2012 15:59:23 -0400
Date: Sat, 22 Sep 2012 21:59:13 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Theodore Ts'o" <tytso@mit.edu>, Matt Sealey <matt@genesi-usa.com>,
        Mike Thompson <mpthompson@gmail.com>, Shawn Guo <shawn.guo@linaro.org>,
        Linux-Arm-Kernel <linux-arm-kernel@lists.infradead.org>,
        linux-ext4@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Tracking down suspend/resume ext3/mmc issues on imx233
Message-ID: <20120922195912.GA25644@elf.ucw.cz>
References: <CAEOSq-O3SfuAEhMsjX1y1ZgQuWBKef+XZzMR1b4yJhKhaRdymA@mail.gmail.com>
 <20120907060552.GL26709@S2101-09.ap.freescale.net>
 <CAEOSq-PV+7c2nvu3uauOLJcV7WKa1jmd-df0a1H0qY5K4CM5MA@mail.gmail.com>
 <CAKGA1bnug8nqcideOBZyLQZmiVo=G5L3aRHq4k4SNZyH132Y=g@mail.gmail.com>
 <20120910163345.GB3942@thunk.org>
 <20120919232349.GA24132@elf.ucw.cz>
 <20120920000110.GA16672@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120920000110.GA16672@thunk.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On Wed 2012-09-19 20:01:10, Theodore Ts'o wrote:
> On Thu, Sep 20, 2012 at 01:23:49AM +0200, Pavel Machek wrote:
> > 
> > I'm not sure I agree.
> > 
> > If you treat root fs as removable, you'll get "crash". You'll need to
> > replay the journal, but data is safe.
> > 
> > If you treat it as non-removable, and someone manages to remove it,
> > mount, and reinsert, you'll get silent data corruption.
> 
> We could detect this case; if the file system gets mounted, the last
> mount time will change.  So one of the things we could do is have the
> file system code freeze the file system at suspend time, so the file
> system is consistent (which will reduce the probability of data loss
> if the system never comes back up after the suspend), and save the
> last mount time and last write time in memory.  When the system comes
> back from resume, have the file system code check the last mount and
> last write time, and if they have changed, it can refuse the resume
> and abort the system to avoid data corruption.  It would require
> making ext3/ext4 suspend-aware, but it would be doable, if we really
> wanted to support this.

Yes please; I'd love to see this done.

We used to do sync() to get filesystem in consistent state, and I
believe that these days we are doing filesystem freeze; but code
validating the last mount time is certainly missing.

Looking forward,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
