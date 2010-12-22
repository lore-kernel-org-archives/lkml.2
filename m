Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103Ab0LVQcf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 11:32:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28123 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753478Ab0LVQcd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 11:32:33 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Cc: Greg Freemyer <greg.freemyer@gmail.com>,
        Bruno =?utf-8?Q?Pr=C3=A9mont?= <bonbons@linux-vserver.org>,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: Slow disks.
References: <20101220141553.GA6088@bitwizard.nl>
	<20101220190630.66084e1d@neptune.home>
	<AANLkTi=VAJbVSzX_DH9_==a3RonLJmawYu3MzF-uqGXC@mail.gmail.com>
	<20101222104306.GB30941@bitwizard.nl>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 22 Dec 2010 11:27:20 -0500
In-Reply-To: <20101222104306.GB30941@bitwizard.nl> (Rogier Wolff's message of
	"Wed, 22 Dec 2010 11:43:06 +0100")
Message-ID: <x49aajxsrh3.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rogier Wolff <R.E.Wolff@BitWizard.nl> writes:

> Unquoted text below is from either me or from my friend. 
>
>
> Someone suggested we try an older kernel as if kernel 2.6.32 would not
> have this problem. We do NOT think it suddenly started with a certain
> kernel version. I was just hoping to have you kernel-guys help with
> prodding the kernel into revealing which component was screwing things
> up....
[...]
> ata3.00: ATA-8: WDC WD10EARS-00Y5B1, 80.00A80, max UDMA/133

This is an "Advanced format" drive, which, in this case, means it
internally has a 4KB sector size and exports a 512byte logical sector
size.  If your partitions are misaligned, this can cause performance
problems.

> MDstat:
>
> Personalities : [raid1] [raid6] [raid5] [raid4]
> md125 : active raid5 sdd3[5](S) sdb3[4] sda3[0] sdc3[3]
>       3903488 blocks super 1.1 level 5, 512k chunk, algorithm 2 [3/3] [UUU]
>
> md126 : active raid5 sda4[0] sdd4[3] sdc4[5](S) sdb4[4]
>       1910063104 blocks super 1.1 level 5, 512k chunk, algorithm 2
> [3/3] [UUU]
>
> md1 : active raid5 sda2[0] sdd2[3](S) sdb2[1] sdc2[4]
>       39067648 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/3]
> [3/3] [UUU]
>
> md1 : active raid5 sda2[0] sdd2[3](S) sdb2[1] sdc2[4]
>       39067648 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/3]
> [UUU]

A 512KB raid5 chunk with 4KB I/Os?  That is a recipe for inefficiency.
Again, blktrace data would be helpful.

Cheers,
Jeff
