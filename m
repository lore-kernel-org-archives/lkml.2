Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755636Ab0EQVnX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 17:43:23 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38745 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751894Ab0EQVnW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 17:43:22 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Brian Swetland <swetland@google.com>
Subject: Re: [PATCH 0/8] Suspend block api (version 7)
Date: Mon, 17 May 2010 23:44:46 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rjw; KDE/4.3.5; x86_64; ; )
Cc: Arve =?utf-8?q?Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <1273810273-3039-1-git-send-email-arve@android.com> <201005172240.35742.rjw@sisk.pl> <AANLkTim2b8cKnzPgN7m5zImb0hVDfqVjRidKNVoYi1yO@mail.gmail.com>
In-Reply-To: <AANLkTim2b8cKnzPgN7m5zImb0hVDfqVjRidKNVoYi1yO@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201005172344.46222.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 17 May 2010, Brian Swetland wrote:
> On Mon, May 17, 2010 at 1:40 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Monday 17 May 2010, Arve Hjønnevåg wrote:
> >>
> >> It should get out of that loop as soon as someone blocks suspend. If
> >> someone is constantly aborting suspend without using a suspend blocker
> >> it will be very inefficient, but it should still work.
> >
> > Well, the scenario I have in mind is the following.  Someone wants to check
> > the feature and simply writes "opportunistic" to /sys/power/policy and "mem" to
> > /sys/power/state without any drivers or apps that use suspend blockers.
> >
> > How in that case is the system supposed to break out of the suspend-resume loop
> > resulting from this?  I don't see right now, because the main blocker is
> > inactive, there are no other blockers that can be activated and it is next to
> > impossible to write to /sys/power/state again.
> 
> I guess we could set a flag when a suspend blocker is registered and
> refuse to enter opportunistic mode if no blockers have ever been
> registered.
> 
> It does seem like extra effort to go through to handle a "don't do
> that" type scenario (entering into opportunistic suspend without
> anything that will prevent it).

I agree, but I think it's necessary.  We shouldn't add interfaces that hurt
users if not used with care.

Thanks,
Rafael
