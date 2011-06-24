Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004Ab1FXVKt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 17:10:49 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:38543 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752761Ab1FXVKq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 17:10:46 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Fri, 24 Jun 2011 23:10:28 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hverkuil@xs4all.nl>, Jesper Juhl <jj@chaosbits.net>,
        LKML <linux-kernel@vger.kernel.org>, trivial@kernel.org,
        linux-media@vger.kernel.org, ceph-devel@vger.kernel.org,
        Sage Weil <sage@newdream.net>
Subject: Re: [RFC] Don't use linux/version.h anymore to indicate a
 per-driver version - Was: Re: [PATCH 03/37] Remove unneeded version.h
 includes from include/
Message-ID: <20110624231028.7f03dcae@stein>
In-Reply-To: <BANLkTimj-oEDvWxMao6zJ_sudUntEVjO1w@mail.gmail.com>
References: <alpine.LNX.2.00.1106232344480.17688@swampdragon.chaosbits.net>
	<4E04912A.4090305@infradead.org>
	<BANLkTim9cBiiK_GsZaspxpPJQDBvAcKCWg@mail.gmail.com>
	<201106241554.10751.hverkuil@xs4all.nl>
	<4E04A122.2080002@infradead.org>
	<20110624203404.7a3f6f6a@stein>
	<BANLkTimj-oEDvWxMao6zJ_sudUntEVjO1w@mail.gmail.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 24 Devin Heitmueller wrote:
> Really, this is all about applications being able to jam a hack into
> their code that translates to "don't call this ioctl() with some
> particular argument if it's driver W less than version X, because the
> driver had a bug that is likely to panic the guy's PC".  Sure, it's a
> crummy solution, but at this point it's the best that we have got.

The second best.  The best that we have got is that the user runs a fixed
kernel.

Anyway; if this is the only purpose that this interface version¹ serves,
then Mauro's subsystem-centralized solution has the benefit that it
eliminates mistakes due to oversight by individual driver authors.
Especially because the kind of implementation behavior changes that are
tracked by this type of version datum are sometimes just discovered or
documented in hindsight.  On the other hand, Mauro's solution is redundant
to the uname(2) syscall.

¹) Yes, it is still an ABI version, nothing less.  With all its backwards
and forwards compatibility ramifications.
-- 
Stefan Richter
-=====-==-== -==- ==---
http://arcgraph.de/sr/
