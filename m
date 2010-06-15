Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757251Ab0FON27 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 09:28:59 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39332 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753138Ab0FON25 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 09:28:57 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: =?utf-8?q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: Re: [Regression, post-2.6.34] Hibernation broken on machines with radeon/KMS and r300
Date: Tue, 15 Jun 2010 15:27:01 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.35-rc3-rjw+; KDE/4.4.3; x86_64; ; )
Cc: Alex Deucher <alexdeucher@gmail.com>, linux-kernel@vger.kernel.org,
       "dri-devel" <dri-devel@lists.freedesktop.org>,
       Dave Airlie <airlied@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-pm@lists.linux-foundation.org
References: <201006141653.03879.rjw@sisk.pl> <201006142103.54616.rjw@sisk.pl> <AANLkTil-o-dB8f4hwM6qHTQzJ0_o5vx9TAX73gNdi9iH@mail.gmail.com>
In-Reply-To: <AANLkTil-o-dB8f4hwM6qHTQzJ0_o5vx9TAX73gNdi9iH@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201006151527.01794.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, June 14, 2010, Rafał Miłecki wrote:
> 2010/6/14 Rafael J. Wysocki <rjw@sisk.pl>:
> > On Monday, June 14, 2010, Alex Deucher wrote:
> >> On Mon, Jun 14, 2010 at 10:53 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >> > Alex, Dave,
> >> >
> >> > I'm afraid hibernation is broken on all machines using radeon/KMS with r300
> >> > after commit ce8f53709bf440100cb9d31b1303291551cf517f
> >> > (drm/radeon/kms/pm: rework power management).  At least, I'm able to reproduce
> >> > the symptom, which is that the machine hangs hard around the point where an
> >> > image is created (probably during the device thaw phase), on two different
> >> > boxes with r300 (the output of lspci from one of them is attached for
> >> > reference, the other one is HP nx6325).
> >> >
> >> > Suspend to RAM appears to work fine at least on one of the affected boxes.
> >> >
> >> > Unfortunately, the commit above changes a lot of code and it's not too easy to
> >> > figure out what's wrong with it and I didn't have the time to look more into
> >> > details of this failure.  However, it looks like you use .suspend() and
> >> > .resume() callbacks as .freeze() and .thaw() which may not be 100% correct
> >> > (in fact it looks like the "legacy" PCI suspend/resume is used, which is not
> >> > recommended any more).
> >> >
> >>
> >> Does it work any better after Dave's last drm pull request?
> >
> > Nope.  The symptom is slightly different, though, because now it hangs after
> > turning off the screen.
> 
> "Just" turning the screen off (like dpms force off) or turning it off
> while suspending?

Turning it off while suspending.

> Maybe it could be worth enabling drm.debug option and logging using
> netconsole or similar...

That doesn't work during suspend, unfortunately.

Perhaps I'll try to use a serial console if I don't fugure out what's wrong.

Rafael
