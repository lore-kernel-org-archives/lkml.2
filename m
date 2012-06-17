Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757346Ab2FQM7C (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 08:59:02 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:35369 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757220Ab2FQM67 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 08:58:59 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: jdow <jdow@earthlink.net>
Subject: Re: Partitions: Amiga RDB partition on 2 TB disk way too big, while OK in AmigaOS 4.1
Date: Sun, 17 Jun 2012 14:58:58 +0200
User-Agent: KMail/1.13.7 (Linux/3.4-trunk-amd64; KDE/4.8.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-m68k@vger.kernel.org
References: <201206170841.20222.Martin@lichtvoll.de> <4FDDB667.4020609@earthlink.net> (sfid-20120617_144808_729301_F71ACE9D)
In-Reply-To: <4FDDB667.4020609@earthlink.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1252"
Content-Transfer-Encoding: 8BIT
Message-Id: <201206171458.58462.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, 17. Juni 2012 schrieb jdow:
> I'll have to make time to look it over, considering I am more or less
> the mommy of the RDBs. Now, 2TB may be a tad beyond the abilities of
> the RDBs to express. Memory insists that the RDBs worked on either
> BYTE or block counts. Your seeing a problem at 2TB suggests it really
> stored bit counts. The numbers are supposed to be unsigned. And whether
> the RDBs store values in blocks or BYTEs is immaterial when you get
> down to it. (The RDBs do store the disk's actual and virtual block
> sizes. The latter is what the filesystem uses.)

Hmmm, I thought any 2 TB limit was gone meanwhile, but then your 
argumentation has some merit.

Some hints that it might be gone nonetheless:

| JXFS 64 bit file system
|
| With AmigaOS 4.x a new file system has been introduced called JXFS. It is 
| a totally new 64 bit file system that supports partitions up to 16 TB in 
| size. It is a modern journalling file system, which means that it reduces 
| data loss if data writes to the disk are interrupted. It is the fastest 
| and most reliable file system ever created for AmigaOS.

http://www.amigaos.net/content/1/features

Well I asked AmigaOS 4 developers about this issue as well. Lets see what 
they say about 2 TB limits.

But nonetheless, I think, Linux should refuse to use a partition that is 
clearly out of bound.

Scrubbing the one backup BTRFS that has 360 GiB of data was okay. Also the 
fsck´s went well. Well the volume group is not completely full so some 
space on the end of the disk is not yet used by it.

I am recreating all my backups on BTRFS volumes now - except maybe the one 
thats on the BTRFS volume already and scrubs okay.

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
