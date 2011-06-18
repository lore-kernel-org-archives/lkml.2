Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756632Ab1FRBCm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 21:02:42 -0400
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:34055 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754455Ab1FRBCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 21:02:41 -0400
Subject: Re: [Bugme-new] [Bug 37682] New: Kernel mis-detects size/position
 of partition created with Seagate DiscWizard (OnTrack Disk Manager)
From: Paul Bolle <pebolle@tiscali.nl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: markk@clara.co.uk, bugme-daemon@bugzilla.kernel.org,
        linux-kernel@vger.kernel.org
Date: Sat, 18 Jun 2011 03:01:48 +0200
In-Reply-To: <20110617143104.3b883bda.akpm@linux-foundation.org>
References: <bug-37682-10286@https.bugzilla.kernel.org/>
	 <20110617143104.3b883bda.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.1.1 (3.1.1-3.fc16) 
Content-Transfer-Encoding: 7bit
Message-ID: <1308358960.2166.20.camel@t41.thuisdomein>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-06-17 at 14:31 -0700, Andrew Morton wrote:
> > In case it helps to diagnose the problem, I have attached the first 0x11000
> > bytes of this disk.

0) $ /sbin/sfdisk -l First_0x11000_bytes.bin 
Disk First_0x11000_bytes.bin: cannot get geometry

Disk First_0x11000_bytes.bin: 0 cylinders, 255 heads, 63 sectors/track
detected Disk Manager - unable to handle that
 First_0x11000_bytes.bin: unrecognized partition table type
No partitions found

1) $ dd if=First_0x11000_bytes.bin of=First_0x9200_bytes.bin bs=512 skip=63
73+0 records in
73+0 records out
37376 bytes (37 kB) copied, 0.0224746 s, 1.7 MB/s

2) $ /sbin/sfdisk -l -uS First_0x9200_bytes.bin 
Disk First_0x9200_bytes.bin: cannot get geometry

Disk First_0x9200_bytes.bin: 0 cylinders, 255 heads, 63 sectors/track
Units = sectors of 512 bytes, counting from 0

   Device Boot    Start       End   #sectors  Id  System
First_0x9200_bytes.bin1   *        63  39102209   39102147   c  W95 FAT32 (LBA)
		end: (c,h,s) expected (1023,254,63) found (385,254,63)
First_0x9200_bytes.bin2             0         -          0   0  Empty
First_0x9200_bytes.bin3             0         -          0   0  Empty
First_0x9200_bytes.bin4             0         -          0   0  Empty

39102147 seems to be close to what the reporter expects to see.

3) Some searches suggest there used to be a "hda=remap63" boot option
for this, ie OnTrack Disk Manager, but I can't find it grepping the
source nor could I find the commit(s) that removed it.


Paul Bolle

