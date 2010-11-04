Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502Ab0KDFF3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 01:05:29 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49453 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828Ab0KDFFZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 01:05:25 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Dominik Brodowski <linux@dominikbrodowski.net>
Subject: Re: [linux-pm] [GIT PULL] One more power management fix for 2.6.37
Date: Thu, 4 Nov 2010 06:04:05 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.35-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <201010292358.27975.rjw@sisk.pl> <AANLkTikrDoKDWPMtSjJ0EjKXO7ddQZPkZ5ZvwoivkbnZ@mail.gmail.com> <20101103211855.GA29721@isilmar-3.linta.de>
In-Reply-To: <20101103211855.GA29721@isilmar-3.linta.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011040604.05183.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, November 03, 2010, Dominik Brodowski wrote:
> > There's apparently an ordering problem with dpm_list_mtx and
> > socket->skt_mutex. Lockdep details appended.
> > 
> > Dominik, Rafael? What's the proper locking order here, and
> > how do we fix this?
> 
> Thanks for noting this; let's see:
> 
> - We add a PCMCIA device holding skt_mutex, therefore we have the ordering
>   (1) skt_mutex -> (2) dpm_list_mtx
> 
> - If we're suspending, dpm_list_mtx is held, but we need to acquire
>   skt_mutex as we modify some data being protected by skt_mutex
>   (1) dpm_list_mtx -> (2) skt_mutex
> 
> Rafael, any idea on how to solve this? How do other subsystems handle such
> an issue? Do they call device_add() with no locks held at all?

They usually do from what I can tell.

Also only a few of them implement the ->suspend_noirq() callback, which is the
one executed under dpm_list_mtx.

What exactly is protected by skt_mutex ?

Rafael

