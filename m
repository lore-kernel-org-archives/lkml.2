Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753560Ab0FNTFm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 15:05:42 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34988 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752469Ab0FNTFl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 15:05:41 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alex Deucher <alexdeucher@gmail.com>
Subject: Re: [Regression, post-2.6.34] Hibernation broken on machines with radeon/KMS and r300
Date: Mon, 14 Jun 2010 21:03:54 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.35-rc3-rjw+; KDE/4.4.3; x86_64; ; )
Cc: Dave Airlie <airlied@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       "dri-devel" <dri-devel@lists.freedesktop.org>
References: <201006141653.03879.rjw@sisk.pl> <AANLkTimQ_yCV5Xdwd_D1zFM1oom2D3ZIBeSczJh4LN1T@mail.gmail.com>
In-Reply-To: <AANLkTimQ_yCV5Xdwd_D1zFM1oom2D3ZIBeSczJh4LN1T@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006142103.54616.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, June 14, 2010, Alex Deucher wrote:
> On Mon, Jun 14, 2010 at 10:53 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > Alex, Dave,
> >
> > I'm afraid hibernation is broken on all machines using radeon/KMS with r300
> > after commit ce8f53709bf440100cb9d31b1303291551cf517f
> > (drm/radeon/kms/pm: rework power management).  At least, I'm able to reproduce
> > the symptom, which is that the machine hangs hard around the point where an
> > image is created (probably during the device thaw phase), on two different
> > boxes with r300 (the output of lspci from one of them is attached for
> > reference, the other one is HP nx6325).
> >
> > Suspend to RAM appears to work fine at least on one of the affected boxes.
> >
> > Unfortunately, the commit above changes a lot of code and it's not too easy to
> > figure out what's wrong with it and I didn't have the time to look more into
> > details of this failure.  However, it looks like you use .suspend() and
> > .resume() callbacks as .freeze() and .thaw() which may not be 100% correct
> > (in fact it looks like the "legacy" PCI suspend/resume is used, which is not
> > recommended any more).
> >
> 
> Does it work any better after Dave's last drm pull request?

Nope.  The symptom is slightly different, though, because now it hangs after
turning off the screen.

> With the latest changes, pm should not be a factor unless it's explicitly
> enabled via sysfs.

Well, I guess the first pm patch changed more than just pm, then.

Rafael
