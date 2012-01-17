Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601Ab2AQIx6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 03:53:58 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:52061 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752012Ab2AQIx4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 03:53:56 -0500
Message-ID: <4F1537B8.1030706@cn.fujitsu.com>
Date: Tue, 17 Jan 2012 16:56:24 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: Updated btrfs/crypto snappy interface ready for merging
References: <1326414530-10789-1-git-send-email-andi@firstfloor.org> <20120116135442.GA28487@shiny> <4F1534FD.30707@cn.fujitsu.com> <20120117084650.GP11715@one.firstfloor.org>
In-Reply-To: <20120117084650.GP11715@one.firstfloor.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-01-17 16:52:43,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-01-17 16:52:45,
	Serialize complete at 2012-01-17 16:52:45
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> It's because decompressing inline extents always fails. I've fixed it
>> and will send the patch out in a new mail thread.
> 
> Thanks for fixing.
> 
>>
>> But seems there's bug in lib snappy code, which makes the decompressed
>> data doesn't quite match the original data.
>>
>> Simply copy a file to a btrfs filesystem with snappy enabled, and clear
>> page cache, and check the file:
> 
> Hmm weird, I have never seen this. Do you have a reproducer?
> 

Just use some randomly chosen text files. For example:

	# mount -t btrfs -o compress=snappy /dev/xxx /mnt
	# cp -r btrfs-progs-unstable/ /mnt
	# sync
	# echo 3 > /proc/sys/vm/drop_caches
	# diff -Nurp btrfs-progs-unstable /mnt/btrfs-progs-unstable

I've tested on both x86_32 and x86_64.

> The basic compression code is quite well tested, I have a reasonable
> unit test.
> 
