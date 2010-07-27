Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751951Ab0G0WjS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 18:39:18 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36619 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751015Ab0G0WjR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 18:39:17 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Roberto Oppedisano <roberto.oppedisano@gmail.com>
Subject: Re: 2.6.35 suspend regression (bisected)
Date: Wed, 28 Jul 2010 00:37:30 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc6-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>
References: <4C4C9E40.7070209@infracom.it> <201007272103.38448.rjw@sisk.pl> <4C4F38F1.105@gmail.com>
In-Reply-To: <4C4F38F1.105@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201007280037.30965.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, July 27, 2010, Roberto Oppedisano wrote:
>   On 27/07/2010 21:03, Rafael J. Wysocki wrote:
> >> I did bisect again and I did get a different result:
> >>
> >> c1518f12bab97a6d409a25aaccb02dc8895800f3 is the first bad commit
> >>
> >> Trying to revert that commit gives:
> >>
> >> $ git bisect reset
> >> $ git revert c1518f12bab97a6d409a25aaccb02dc8895800f3
> >> fatal: Commit c1518f12bab97a6d409a25aaccb02dc8895800f3 is a merge but no
> >> -m option was given.
> >>
> >> How am I supposed to proceed now ? (sorry I'm a git newbie)
> > The bisect turned up a merge, which means it probably didn't really converge
> > for you.
> >
> > Do you use a camera driver?
> Yes, this laptop has an integrated webcam.
> 
> Bus 001 Device 004: ID 04f2:b059 Chicony Electronics Co., Ltd
> 
> 
> which i think is driven by uvcvideo.ko. I've tryed to rmmod uvcvideo, 
> videodev and
> 
> v4l1_compat but on current git suspend still hangs in the same way 
> (screen black,
> backlight on, fans at full speed, no response to ping and... nothing in 
> the logs).

Please try the current mainline with acpi_sleep=nonvs in the command line.

Rafael
