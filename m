Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786Ab0DTOMN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 10:12:13 -0400
Received: from mail-ew0-f220.google.com ([209.85.219.220]:62657 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754758Ab0DTOMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 10:12:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=BntzF4sD33RMvmgSZufZjv4puulQ6sz8/mCUqdpPVMUhYY1/c9h+2wfJ/pq6td3JOK
         igsbs+BQbwmnbGqfx1ZO2vZAkQUofy7l+cjPwHjRmSGS5l/bajlkeXoR/1oNBkZJ6pAh
         89WkceTNQvUjDmNoigN5IfEzAy/+bV6dfMY1A=
Message-ID: <4BCDB633.9040901@gmail.com>
Date: Tue, 20 Apr 2010 16:12:03 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.2pre) Gecko/20100308 SUSE/3.1b1-6.5 Thunderbird/3.1b1
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: Andrew Morton <akpm@linux-foundation.org>, adilger@sun.com,
       linux-ext4@vger.kernel.org,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       mszeredi@suse.cz
Subject: Re: busy inodes -> ext3 umount crash
References: <4BC8A7C1.20102@gmail.com> <20100419141158.GB5439@quack.suse.cz> <4BCC69B4.2050308@gmail.com>
In-Reply-To: <4BCC69B4.2050308@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/2010 04:33 PM, Jiri Slaby wrote:
> The trigger for busy inodes is as simple as (I=initialization done only
> once):
> I> # dd if=/dev/zero of=/dev/shm/ext3 bs=1024 count=1 seek=$((100*1024))
> I> # mkfs.ext3 -m 0 /dev/shm/ext3
> # mount -oloop /dev/shm/ext3 /mnt/c
> # umount /mnt/c
> # dmesg|tail
> VFS: Busy inodes after unmount of loop0. Self-destruct in 5 seconds.
> Have a nice day...
> 
> (The printk time varies -- this sequence really suffices.)

Well, this happens only after gnome-session is started and it's fuzzy --
sometimes it happens, sometimes not. I didn't find 100% trigger yet.

>> So if you can easily reproduce
>> the "busy inodes" message then I'd start with debugging that one. Do you
>> see it also with vanilla kernels?

Vanilla seems not to be affected. It's in next/master already though
(2603ecd9). I'll investigate it further later.
