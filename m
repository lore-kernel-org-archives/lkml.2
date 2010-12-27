Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331Ab0L0DMs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Dec 2010 22:12:48 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39851 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752969Ab0L0DMj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Dec 2010 22:12:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=edbpAjRjcWHh/f2CsStfFv5eXzdTOP3W3j5ZLRttnFDeCLuPXFMbctxl+DzYf5b+b6
         AOgUDJZZjezldOvAy9ak0lSjFFnqEkqdn72YepsIJFUcQzWr2kSh3Ovj7VB3dbywXw/l
         9n/NaqROc2iVYleElAHwsM6/P7VMG68tiURuQ=
MIME-Version: 1.0
In-Reply-To: <20101227003456.GG18227@bitwizard.nl>
References: <20101220141553.GA6088@bitwizard.nl>
	<20101220190630.66084e1d@neptune.home>
	<AANLkTi=VAJbVSzX_DH9_==a3RonLJmawYu3MzF-uqGXC@mail.gmail.com>
	<20101222104306.GB30941@bitwizard.nl>
	<x49aajxsrh3.fsf@segfault.boston.devel.redhat.com>
	<AANLkTi=qAGCFU0u8joKVR4o4QQaRZt1XWfOPSt8eiD3r@mail.gmail.com>
	<20101227003456.GG18227@bitwizard.nl>
Date: Sun, 26 Dec 2010 19:12:37 -0800
Message-ID: <AANLkTi=O+jZoo9K3idxMTHfd-dCBr-8Gd-+sDjHg6hor@mail.gmail.com>
Subject: Re: Slow disks.
From: Mark Knecht <markknecht@gmail.com>
To: Rogier Wolff <R.E.Wolff@bitwizard.nl>
Cc: Jeff Moyer <jmoyer@redhat.com>, Greg Freemyer <greg.freemyer@gmail.com>,
        =?UTF-8?Q?Bruno_Pr=C3=A9mont?= <bonbons@linux-vserver.org>,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 26, 2010 at 4:34 PM, Rogier Wolff <R.E.Wolff@bitwizard.nl> wrote:
> On Sun, Dec 26, 2010 at 03:38:51PM -0800, Mark Knecht wrote:
>> First, the drives are 4K sector so it's really important to get them
>> on the right partition boundary. Installing Gentoo requires that we
>> un-tar some large-ish files. IIRC on a 512 byte boundary these drives
>> took 20-30 minutes to do this. On a 4K boundary they took about 1
>> minute. I know that doesn't make sense but those were my numbers, and
>> it's a very high end Intel i7-980x MB so there wasn't any other
>> problem I could find.
>
> Mark,
>
> Thanks for your contribution. You're seeing a 20-30 fold performance
> issue, where only about 2x would be expected. So to test this theory
> I'll see if we can evacuate a partition, untar a large-ish file as a
> benchmark, and then see if we can improve that by changing the
> alignment of the partition. (hmm. Maybe we should do things the other
> way around. First find a tar-workload that takes about 1 minute on a
> properly working drive, and then we can wait up to 30 minutes for it
> to finish on the improper setup.).
>
> Being able to reproduce a problem at will is a great progress to being
> able to solve it!
>
>        Roger.

I hope my memory isn't way off on those numbers. I can certainly
recall that the difference was remarkable and was very easy to
demonstrate.

1) Partition the disk with fdisk placing a partition at sector 63, the
typical first address we're given. Untar a Gentoo Stage 3 release
snapshot such as

http://gentoo.osuosl.org/releases/amd64/current-stage3/stage3-amd64-20101223.tar.bz2

2) Create a second partition starting at sector 1000 and do it again.

It was day and night.

If it was only the performance difference that would be one thing but
the problem i had with these WD10EARS drives was sometimes they would
just hang for long periods. In a RAID they just got kicked.

The kernel was modern for the time I was building the machines, maybe
7-9 months ago.

Hope this helps,
Mark
