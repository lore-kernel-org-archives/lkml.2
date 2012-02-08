Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757294Ab2BHBwA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 20:52:00 -0500
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:32032 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756831Ab2BHBv5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 20:51:57 -0500
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=GZn8e3lTBEeJrlGK3+GUWyR5aYe1SJcDn5uEERMe9yQ= c=1 sm=1
 a=NNzzr0qL0PwA:10 a=BLceEmwcHowA:10 a=kj9zAlcOel0A:10
 a=k8hqzbHzjweV03hO1KKrVA==:17 a=3DfWnJiXAAAA:8 a=B6GvL0XKAAAA:8
 a=BB99dJHrAAAA:8 a=VwQbUJbxAAAA:8 a=ioJmRQKTinwM7t5lJTkA:9
 a=_Kgd4ySJl8zr2ohg4WYA:7 a=CjuIK1q_8ugA:10 a=x8gzFH9gYPwA:10
 a=nrQdhOzvz4kA:10 a=QfXgnLJrAMjoicai:21 a=iJHAkVTgEbpvRW-9:21
 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Subject: Re: Direct i/o changes break all non-GPL file systems
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <673AFC57-2B73-49AC-962E-CAB1DE775B2C@tuxera.com>
Date: Tue, 7 Feb 2012 18:51:55 -0700
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Szabolcs Szakacsits <szaka@tuxera.com>,
        =?iso-8859-1?Q?Janne_Kalliom=E4ki?= <janne@tuxera.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <D35F212C-0C17-43CE-885D-62C6DF58E2C2@dilger.ca>
References: <92291682-5422-4AE2-9608-97775603E7FD@tuxera.com> <20120208001519.501b6fea@pyramind.ukuu.org.uk> <673AFC57-2B73-49AC-962E-CAB1DE775B2C@tuxera.com>
To: Anton Altaparmakov <anton@tuxera.com>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-02-07, at 5:28 PM, Anton Altaparmakov wrote:
> Linus has previously stated that he is happy for binary kernel modules to exist and I believe that a kernel module calling EXPORT_SYMBOL() functions is the equivalent of a user space program executing system calls.  I do not believe this has even been decided in court so let us please not start a flamewar on the subject!  I am sure both points of view have their merits but unless they are tested in court there is no point in wasting everyones time discussing the subject to death.  That has been done many times before ad nauseum.
> 
> Can we please let this sort of debate be and just focus on the question whether this breakage for non-GPL modules was intentional or accidental and if the latter whether the author, namely Christoph, would be willing to reconsider his choice and allow the symbols to become generically exported, in which case we can return to the state we had before by exporting the two symbols to all modules.

This doesn't affect me directly, since Lustre is itself a GPL filesystem,
but it does seem a bit harsh for such a minor amount of functionality.

Looking at inode_dio_wait(), there isn't anything in there that couldn't
be implemented without using that GPL-only symbol export.  Both inode_dio_wait()
and __inode_dio_wait() use only functions that are themselves EXPORT_SYMBOL()
(i.e. not GPL-only) and locally accessible structures (inode->i_dio_count
and inode->i_state), so I don't see any benefit or reason in making
inode_dio_wait() itself GPL.

Cheers, Andreas

> On 8 Feb 2012, at 00:15, Alan Cox wrote:
>> On Wed, 8 Feb 2012 00:07:15 +0000
>> Anton Altaparmakov <anton@tuxera.com> wrote:
>> 
>>> Hi Linus, Andrew, Christoph,
>>> 
>>> With kernel 3.1, Christoph removed i_alloc_sem and replaced it with calls (namely inode_dio_wait() and inode_dio_done()) which are EXPORT_SYMBOL_GPL() thus they cannot be used by non-GPL file systems and further inode_dio_wait() was pushed from notify_change() into the file system ->setattr() method but no non-GPL file system can make this call.
>> 
>> I'm advised by my lawyer that when this occurs that I should always
>> inform the other party the following
>> 
>> "For a Linux kernel containing any code I own the code is under the GNU
>> public license v2 (in some cases or later), I have never given permission
>> for that code to be used as part of a combined or derivative work which
>> contains binary chunks. I have never said that modules are somehow
>> magically outside the GPL and I am doubtful that in most cases a work
>> containing binary modules for a Linux kernel is compatible with the
>> licensing, although I accept there may be some cases that it is."
>> 
>> 
>> 
>> So unless your code is remarkably non-derivative I don't see that
>> anything has changed.
> 
> 
> -- 
> Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
> Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
> Linux NTFS maintainer, http://www.linux-ntfs.org/
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas





