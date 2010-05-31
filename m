Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864Ab0EaVhp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 17:37:45 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35654 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751028Ab0EaVho convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 17:37:44 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Date: Mon, 31 May 2010 23:38:55 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.35-rc1-rjw; KDE/4.3.5; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Florian Mickler <florian@mickler.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Brian Swetland <swetland@google.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       markgross@thegnar.org
References: <AANLkTik_4ezDAQoAQjkpEgwD9SLKeOjDzy2H7T2v6uCP@mail.gmail.com> <Pine.LNX.4.44L0.1005292026080.6300-100000@netrider.rowland.org> <AANLkTikxws5kmFhnBO1MLzE65ETka3Jy0R5ayAKTS1Lc@mail.gmail.com>
In-Reply-To: <AANLkTikxws5kmFhnBO1MLzE65ETka3Jy0R5ayAKTS1Lc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201005312338.55109.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 31 May 2010, Arve Hjønnevåg wrote:
> 2010/5/29 Alan Stern <stern@rowland.harvard.edu>:
> > On Sat, 29 May 2010, Arve Hjønnevåg wrote:
> >
> >> > In place of in-kernel suspend blockers, there will be a new type of QoS
> >> > constraint -- call it QOS_EVENTUALLY.  It's a very weak constraint,
> >> > compatible with all cpuidle modes in which runnable threads are allowed
> >> > to run (which is all of them), but not compatible with suspend.
> >> >
> >> This sound just like another API rename. It will work, but given that
> >> suspend blockers was the name least objectionable last time around,
> >> I'm not sure what this would solve.
> >
> > It's not just a rename.  By changing this into a QoS constraint, we
> > make it more generally useful.  Instead of standing on its own, it
> > becomes part of the PM-QOS framework.
> >
> 
> We cannot use the existing pm-qos framework. It is not safe to call
> from atomic context.

We've just merged a patch that fixed that if I'm not mistaken.  Mark, did your
PM QoS update fix that?

> Also, it does not have any state constraints, so it iterates over every
> registered constraint each time one of them changes.

That's fixable IMO.

> Nor does is currently provide any stats for debugging.

That's why Alan is proposing to add that.

> The original wakelock patchset supported a wakelock type so it could
> be used to block more then suspend, but I had to remove this because
> it "overlapped" with pm-qos. So, yes I do consider this just another
> rename.

It's an extension of an existing framework rather than an addition of a new
one, with entirely new API and so on.  Extending existing APIs is much
preferred to adding new ones, in general.

Rafael
