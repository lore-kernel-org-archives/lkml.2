Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760942Ab2CNNFk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 09:05:40 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:45532 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757969Ab2CNNFh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 09:05:37 -0400
Message-ID: <1331730336.27389.70.camel@joe2Laptop>
Subject: Re: [PATCH] checkpatch: Suggest pr_<level> over printk(KERN_<LEVEL>
From: Joe Perches <joe@perches.com>
To: "Ted Ts'o" <tytso@mit.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@shadowen.org>, LKML <linux-kernel@vger.kernel.org>
Date: Wed, 14 Mar 2012 06:05:36 -0700
In-Reply-To: <20120314123429.GG15379@thunk.org>
References: <20120313220144.GD11969@thunk.org>
	 <20120313150316.6ae19b95.akpm@linux-foundation.org>
	 <20120314003157.GA15379@thunk.org> <1331686026.24613.6.camel@joe2Laptop>
	 <20120314010701.GB15379@thunk.org> <1331687831.27389.2.camel@joe2Laptop>
	 <20120314021938.GD15379@thunk.org> <1331692311.27389.27.camel@joe2Laptop>
	 <20120314024104.GE15379@thunk.org> <1331694074.27389.42.camel@joe2Laptop>
	 <20120314123429.GG15379@thunk.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-03-14 at 08:34 -0400, Ted Ts'o wrote:
> On Tue, Mar 13, 2012 at 08:01:14PM -0700, Joe Perches wrote:
> > > That's a debug message which is never by anyone other than ext4
> > > developers.  Your patch also hacked the Makefile to enable it by
> > > default,
> > 
> > It's just an example and no it didn't.
> > That output is still in an #ifdef EXT4FS_DEBUG
> > block and is unchanged.
> 
> I looked at your patch, and nearly all of them were in debug code.  I
> know, because in practice the messages that come up with any kind of
> regularity are all properly prefixed.

Not really, some are prefixed with EXT4-fs, others EXT4,
some with colons, some without, some with no prefix,
some with function names only.

The idea is to be consistent and allow a mechanical
comprehensive dmesg grep with "EXT4-fs:" or some
other appropriate subsystem name.

$ grep -rP --include=*.[ch] "\bprintk\s*\(\s*KERN_[A-Z]+\s*\"[^\":]*" fs/ext4/

>       http://patchwork.ozlabs.org/project/linux-ext4/list/

Patchwork queues are pretty useless when patches entered
do not have their status updated for long periods.

The patch I sent in August 2011 shows "new" rather than
have an appropriate status.

There are patches in that queue from 2008 marked as "new"
that will never be applied or looked at again.

If you actually use patchwork, though it seems you don't,
I think you should just mark every patch that's new as
rejected and start over.

> Very few other people review patches, and even patches that survive
> review, I've found problems that could potentially lead to data loss
> or system instability.  This is not like your average device driver,
> where if the machine panics once a week, "oh well", and you reboot.
> Linus would get very cranky if he lost data as a result of a bad patch
> slipping through.  Hence, patches don't go in until after significant
> review and testing.
> 
> As a result, #1, patches that are don't add value, and are large,
> simply won't get applied.  Period.  Avoiding the downside of lots of
> people losing data is ****far**** more than your OCD wanting me to use
> pr_warn(...) instead of printk(KERN_WARN, ...).

I believe it's less OCD than you do.

Using a facility to prefix dmesg output consistently
per subsystem adds value in my opinion.

> If you want your style patches to go in, break them into smaller
> chunks, or I *will* ignore them.

OK, I'll resubmit it as micropatches.

cheers, Joe

