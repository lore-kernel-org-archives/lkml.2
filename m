Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989Ab1H2Hix (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 03:38:53 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44463 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752965Ab1H2His (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 03:38:48 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 12/16] freezer: clean up freeze_processes() failure path
Date: Mon, 29 Aug 2011 09:40:37 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc2+; KDE/4.6.0; x86_64; ; )
Cc: Oleg Nesterov <oleg@redhat.com>, paul@paulmenage.org,
        linux-kernel@vger.kernel.org, arnd@arndb.de
References: <1313763382-12341-1-git-send-email-tj@kernel.org> <20110828180901.GD27032@redhat.com> <20110829072800.GC16431@mtj.dyndns.org>
In-Reply-To: <20110829072800.GC16431@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108290940.37275.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, August 29, 2011, Tejun Heo wrote:
> Hello,
> 
> On Sun, Aug 28, 2011 at 08:09:01PM +0200, Oleg Nesterov wrote:
> > This was copied from cancel_, yes. but what this
> > recalc_sigpending_and_wake() can or should do?
> >
> > It looks simply pointless. It can't clear TIF_SIGPENDING,
> > it can only do the unneeded/spurious wake_up(INTERRUPTIBLE).
> 
> Yeah, I just copied it over.  It seems it got confused between
> recalc_sigpending() and recalc_sigpending_and_wake() where the latter
> can't clear TIF_SIGPENDING.  The signallable freezable kthread seems
> quite fragile.  Once TIF_SIGPENDING is set, the only way for it to be
> cleared for a kthread is going through refrigerator and if freezing
> gets canceled before that happens, the kthread will have stuck
> TIF_SIGPENDING failing interruptible sleeps.  We'll probably should
> move recalc_sigpending() to the top of refrigerator.
> 
> But that said, I don't see any in-kernel user of
> set_freezable_with_signal().  Rafael, is there scheduled to be some
> new user of this API?

I'm not aware of any.

> It would be awesome if we can drop it.

Indeed.

Thanks,
Rafael
