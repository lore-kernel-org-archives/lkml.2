Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756385Ab2KVTFb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:05:31 -0500
Received: from smtpfb1-g21.free.fr ([212.27.42.9]:47090 "EHLO
	smtpfb1-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752734Ab2KVTF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:05:26 -0500
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Dave Chinner <david@fromorbit.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] mm: trace filemap add and del
References: <1352404450-30100-1-git-send-email-robert.jarzmik@free.fr>
	<20121120155735.905bbf9e.akpm@linux-foundation.org>
	<20121121035924.GO2591@dastard>
X-URL: http://belgarath.falguerolles.org/
Date: Thu, 22 Nov 2012 12:51:00 +0100
In-Reply-To: <20121121035924.GO2591@dastard> (Dave Chinner's message of "Wed,
	21 Nov 2012 14:59:24 +1100")
Message-ID: <87vccx500r.fsf@free.fr>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Chinner <david@fromorbit.com> writes:

> We actually have an informal convention for formating filesystem
> trace events, and that is to use the device number....
>
>> 
>> > +	),
>> > +
>> > +	TP_printk("page=%p pfn=%lu blk=%d:%d inode+ofs=%lu+%lu",
>
> ... and to prefix messages like:
>
> 	TP_printk("dev %d:%d ino 0x%llx ....
> 		  MAJOR(__entry->dev), MINOR(__entry->dev),
>
> i.e. the start of the event message has all the identifying
> information where it is easy to grep for and get all the events for
> a specific dev/inode combination without even having to think about
> it.

I cross-checked your proposition.
The "ino 0x%llx" looks wrong to me, because :
 - i_ino is "unsigned long", not "(unsigned) long long"

 - triggers a printk where "ino" looks really awfull (on a 32bits LE arm)
>  mm_filemap_add_to_page_cache: dev 0:2 ino 0xc05186e000000000 page=000a0737
>  pfn=0 ofs=3283861504

 - why print the inode number in hexadecimal format ???
   Doing a "ls -i" returns decimal format, "debugfs" returns decimal. What is
   the rational behind hexadecimal ?

I'd rather have : "dev %d:%d ino %lu page=0x%p pfn=%lu ofs=%lu".

-- 
Robert
