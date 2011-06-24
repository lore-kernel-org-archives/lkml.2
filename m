Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131Ab1FXSsG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 14:48:06 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:34493 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753729Ab1FXSsD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 14:48:03 -0400
MIME-Version: 1.0
In-Reply-To: <20110624203404.7a3f6f6a@stein>
References: <alpine.LNX.2.00.1106232344480.17688@swampdragon.chaosbits.net>
	<4E04912A.4090305@infradead.org>
	<BANLkTim9cBiiK_GsZaspxpPJQDBvAcKCWg@mail.gmail.com>
	<201106241554.10751.hverkuil@xs4all.nl>
	<4E04A122.2080002@infradead.org>
	<20110624203404.7a3f6f6a@stein>
Date: Fri, 24 Jun 2011 14:48:00 -0400
Message-ID: <BANLkTimj-oEDvWxMao6zJ_sudUntEVjO1w@mail.gmail.com>
Subject: Re: [RFC] Don't use linux/version.h anymore to indicate a per-driver
 version - Was: Re: [PATCH 03/37] Remove unneeded version.h includes from include/
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hverkuil@xs4all.nl>, Jesper Juhl <jj@chaosbits.net>,
        LKML <linux-kernel@vger.kernel.org>, trivial@kernel.org,
        linux-media@vger.kernel.org, ceph-devel@vger.kernel.org,
        Sage Weil <sage@newdream.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 24, 2011 at 2:34 PM, Stefan Richter
<stefanr@s5r6.in-berlin.de> wrote:
> If the "driver version" is in fact an ABI version, then the driver author
> should really increase it only when ABI behavior is changed (and only if
> the behavior change can only be communicated by version number --- e.g.
> addition of an ioctl is not among such reasons).  And the author should
> commit behavior changing implementation and version number change in a
> single changeset.
>
> And anybody who backmerges such an ABI behavior change into another kernel
> branch (stable, longterm, distro...) must backmerge the associated version
> number change too.
>
> Of course sometimes people realize this only after the fact.  Or driver
> authors don't have a clear understanding of ABI versioning to begin with.
> I am saying so because I had to learn it too; I certainly wasn't born
> with an instinct knowledge how to do it properly.
>
> (Disclaimer:  I have no stake in drivers/media/ ABIs.  But I am involved
> in maintaining a userspace ABI elsewhere in drivers/firewire/, and one of
> the userspace libraries that use this ABI.)

Hi Stefan,

To be clear, I don't think anyone is actually proposing that the
driver version number really be used as any form of formal "ABI
versioning" scheme.  In almost all cases, it's so the application can
know to *not* do something is the driver is older than X.

Given all the cases I've seen, it doesn't really hurt anything if the
driver contains a fix from newer than X, aside from the fact that the
application won't take advantage of whatever feature/functionality the
fix made work.  In other words, I think from a backport standpoint, it
usually doesn't *hurt* anything if a fix is backported without the
version being incremented, aside from applications not knowing that
the feature/fix is present.

Really, this is all about applications being able to jam a hack into
their code that translates to "don't call this ioctl() with some
particular argument if it's driver W less than version X, because the
driver had a bug that is likely to panic the guy's PC".  Sure, it's a
crummy solution, but at this point it's the best that we have got.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
