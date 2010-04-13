Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995Ab0DMV3X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 17:29:23 -0400
Received: from smtp-out.google.com ([74.125.121.35]:14592 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753825Ab0DMV3W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 17:29:22 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:from:date:message-id:
	subject:to:cc:content-type:content-transfer-encoding:x-system-of-record;
	b=VLK1TLC1zsm7bYjO6t2yVs1PaiEpqWi4QeUkaQXnhUKdTBL+CBJVYNehVTVqBi2/R
	8tO9auobU+4u1LsUqtAXA==
MIME-Version: 1.0
In-Reply-To: <20100413181528.GC27497@kernel.dk>
References: <20100412184046.23784.27365.stgit@austin.mtv.corp.google.com> 
	<20100412221158.GB3224@redhat.com> <w2naf41c7c41004131026s3b81d78cl6003df56c32da992@mail.gmail.com> 
	<20100413181528.GC27497@kernel.dk>
From: Divyesh Shah <dpshah@google.com>
Date: Tue, 13 Apr 2010 14:28:59 -0700
Message-ID: <y2vaf41c7c41004131428jfc34b4f5u6df952aa04f97fd7@mail.gmail.com>
Subject: Re: [PATCH][v2] Changes to more io-controller stats patches to 
	address review comments.
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org,
       nauman@google.com, ctalbott@google.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 13, 2010 at 11:15 AM, Jens Axboe <jens.axboe@oracle.com> wrote:
> On Tue, Apr 13 2010, Divyesh Shah wrote:
>> Hi Jens,
>>        If this looks ok to you, can you please queue it up? Btw, after
>> Gui's patches there is 1 merge conflict in your for-2.6.35 branch when
>> applying this patch but it seems pretty straightforward to resolve. In
>> case you'd prefer a clean patch that takes care of the merge conflict
>> please let me know.
>
> I hand applied that one hunk, and committed it.
>
> But...
>
> block/blk-cgroup.c:271: error: redefinition of ?blkiocg_set_start_empty_time?
> block/blk-cgroup.h:208: note: previous definition of ?blkiocg_set_start_empty_time? was here
> block/blk-cgroup.c: In function ?blkiocg_set_start_empty_time?:
> block/blk-cgroup.c:291: error: implicit declaration of function ?blkio_blkg_empty?
> block/blk-cgroup.c:292: error: ?struct blkio_group_stats? has no member named ?start_empty_time?
> block/blk-cgroup.c:293: error: implicit declaration of function ?blkio_mark_blkg_empty?
> make[1]: *** [block/blk-cgroup.o] Error 1
> make: *** [block] Error 2

Ahh.. I see this now with CONFIG_DEBUG_CFQ_IOSCHED not set.
blkiocg_set_empty_start_time() should be within the #ifdef
CONFIG_DEBUG_BLK_CGROUP block.

>
> I merged mainline into for-2.6.35 to resolve a merge conflict, but that
> was trivial.

block/cfq-iosched.c: In function 'cfq_forced_dispatch':
block/cfq-iosched.c:2234: error: too few arguments to function
'cfq_slice_expired'

Another compile error after fixing this was due to the merge from
mainline. cfq_slice_expired() now has an extra argument. Fixed that
too. Will send a patch with the 2 fixes in a bit. Sorry for the
breakage.

>
> --
> Jens Axboe
>
>
