Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154Ab1ACJ62 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 04:58:28 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:38738 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752777Ab1ACJ60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 04:58:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=r//3WEUu5khE2Bs+266yXybaLelZ68ONOgYqAIcoEdHWb/AAKizPCkEx4EuXSYoZ0v
         QaqAmMWwzbEw+E3Yy76TyZzUCPDTv1/XCiUg5G5+sIYlO/pEjh8WZGwwUTPciaH4SEs7
         5x3p6n9nlxRQHO6WXF8kU7vbumpx/P79wtEYc=
Message-ID: <4D219CD4.1070307@gmail.com>
Date: Mon, 03 Jan 2011 10:54:28 +0100
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; it; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Tim Bird <tim.bird@am.sony.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 01/16 v5] pramfs: documentation
References: <4D0A5377.1020007@gmail.com> <20110103074526.GA2687@ucw.cz>
In-Reply-To: <20110103074526.GA2687@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 03/01/2011 08:45, Pavel Machek ha scritto:
> Hi!
> 
>> +But the disk-based fs over non-volatile RAM block driver approach has
>> +some drawbacks:
>> +
>> +1. Complexity of disk-based fs: disk-based filesystems such as ext2/ext3/ext4
>> +   were designed for optimum performance on spinning disk media, so they
>> +   implement features such as block groups, which attempts to group inode data
>> +   into a contiguous set of data blocks to minimize disk seeking when accessing
>> +   files. For RAM there is no such concern; a file's data blocks can be
> 
> Yes, and they are also used on 99% of machines out there -> well
> debugged.

I know that you aren't a supporter for this kind of project...do you
mean that the world finishes with ext4? Why do you ask for removing from
mainline logfs, nilfs, btrs and so on? At the end all can use ext4
everywhere and in all situations, other fs are crap. In addition, I
really don't want to replace extN fs or say "my fs is absolute better of
extN", I'm pointing out that a simpler and ad-hoc solution for *this use
case* maybe it's better.

> 
> Is there fsck for pramfs available, for example?
> 

Currently not. First of all there isn't a device sdX to use, I could use
mem but it's not always available when you use strict_devmem option
because the memory region is marked "exclusive" (it's used to avoid to
"play" with that memory region). In addition, since the simplicity and
the scope of this fs I didn't find an use case that justifies writing an
fsck.

>> +   This increases the efficient use of space on the media, i.e. more
>> +   space is dedicated to actual file data storage and less to meta-data
>> +   needed to maintain that file data.
> 
> So... how big is overhead of pramfs compared to ext2?

You can find a lot of information on the tech web site page.

> 
> Can pramfs handle powerdown at arbitrary time?
> 

If you are asking for journaling, the answer is currently not. Adding
journaling means a deeply rework and redesing. This effort can be
justified only with high benefits. At the moment for the scope of this
fs I didn't find them. I recall that we are not talking about replace an
fs like ext4 for a desktop rootfs, but only to have a place to write not
sensible and temporary information in an embedded system. There are
other example of this kind as the pmem driver written by Google guys (it
was in the staging tree) or the "persistent store" written by Tony Luck.
The idea here is to provide a classic fs interface to that memory area.

Marco
