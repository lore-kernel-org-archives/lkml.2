Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143Ab1CPPEh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 11:04:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42985 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752446Ab1CPPEd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 11:04:33 -0400
MIME-Version: 1.0
In-Reply-To: <4D80695D.8080903@orcon.net.nz>
References: <4D7F2C11.907@orcon.net.nz> <AANLkTimRDH4S1QMN6f4AfKOe6ipPK6jm+g91nuBJYQJa@mail.gmail.com>
 <AANLkTi=yev46gYosVdSfVvmf7MnB2oVriyvDT+pu1FnC@mail.gmail.com> <4D80695D.8080903@orcon.net.nz>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 16 Mar 2011 08:03:42 -0700
Message-ID: <AANLkTinvRJNZGrKT0pbFBcHoe2LOeSVMd2CEBaKdbU2u@mail.gmail.com>
Subject: Re: Alpha no longer recognises certain partition tables (v2.6.38)
To: Michael Cree <mcree@orcon.net.nz>
Cc: linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org,
        warns@pre-sense.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 16, 2011 at 12:40 AM, Michael Cree <mcree@orcon.net.nz> wrote:
>
> OK, I've fallen for that and created too many partitions on my system disk.
>  When using your patch dmesg reports:
>
> [    7.511714] sd 1:0:0:0: [sdb] 2930277168 512-byte logical blocks: (1.50
> TB/1.36 TiB)
> [    7.551753] sd 1:0:0:0: [sdb] Write Protect is off
> [    7.572261] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
> [    7.591792] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled,
> doesn't support DPO or FUA
> [    7.633785] OSF: 10 partitions
> [    7.654292]  sdb: sdb1 sdb2 sdb3 sdb4 sdb5 sdb6 sdb7 sdb8
> [    7.675777] sd 1:0:0:0: [sdb] Attached SCSI disk

Ok, no problem.

I'll increase the value of OSF_MAX_PARTITIONS to 18 (which is what
fits in a 512 byte sector), and mark it for back-porting into stable
too.

Thanks for testing.

> I could get it back to eight partitions but it will require copying the
> largest partition to another disk and back again as that partition does not
> meet the conditions for resizing.

Oh, no need for that. There really isn't any real technical limit for
the "limit to 8 partitions", and we don't cause regressions.

                              Linus
