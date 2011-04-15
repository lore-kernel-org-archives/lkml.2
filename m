Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765Ab1DOXay (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 19:30:54 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54589 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750923Ab1DOXax (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 19:30:53 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mike Frysinger <vapier@gentoo.org>
Subject: Re: [uclinux-dist-devel] [linux-pm] freezer: should barriers be smp ?
Date: Sat, 16 Apr 2011 01:30:55 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc3+; KDE/4.6.0; x86_64; ; )
Cc: Pavel Machek <pavel@ucw.cz>, Alan Stern <stern@rowland.harvard.edu>,
        uclinux-dist-devel@blackfin.uclinux.org,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <BANLkTinj3y+-VhzFAPz8Gzb5vAbtUFU6Aw@mail.gmail.com> <201104160111.49409.rjw@sisk.pl> <BANLkTik9aGTqb0JNr3RsnDjPiSpbSdEUpA@mail.gmail.com>
In-Reply-To: <BANLkTik9aGTqb0JNr3RsnDjPiSpbSdEUpA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201104160130.55836.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, April 16, 2011, Mike Frysinger wrote:
> On Fri, Apr 15, 2011 at 19:11, Rafael J. Wysocki wrote:
> > On Friday, April 15, 2011, Mike Frysinger wrote:
> >> On Fri, Apr 15, 2011 at 12:29, Pavel Machek wrote:
> >> >> > > I believe the code is correct as is.
> >> >> >
> >> >> > that isnt what the code / documentation says.  unless i'm reading them
> >> >> > wrong, both seem to indicate that the proposed patch is what we
> >> >> > actually want.
> >> >>
> >> >> The existing code is correct but it isn't optimal.
> >> >>
> >> >> wmb() and rmb() are heavy-duty operations, and you don't want to call
> >> >> them when they aren't needed.  That's exactly what smp_wmb() and
> >> >> smp_rmb() are for -- they call wmb() and rmb(), but only in SMP
> >> >> kernels.
> >> >>
> >> >> Unless you need to synchronize with another processor (not necessarily
> >> >> a CPU, it could be something embedded within a device), you should
> >> >> always use smp_wmb() and smp_rmb() rather than wmb() and rmb().
> >> >
> >> > Maybe; but this code is not performance critical and I believe being
> >> > obvious here is better...
> >>
> >> isnt it though ?  especially when we talk about suspending/resuming on
> >> embedded systems to get more savings over just cpu idle ?  we want
> >> that latency to be as low as possible.
> >
> > I agree, we can switch the freezer to smp_ barriers, but not for the reason
> > you gave before. :-)
> >
> > Care to repost the patch with a suitable changelog?
> 
> np
> 
> to be clear, what you said wrt the Blackfin smp barriers still holds
> true right ?

I think so.

> so this changset i merged doesnt need any tweaking ...
> http://git.kernel.org/?p=linux/kernel/git/vapier/blackfin.git;a=commitdiff;h=943aee0c685d0563228d5a2ad9c8394ad0300fb5

Rafael
