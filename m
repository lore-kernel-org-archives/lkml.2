Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760950Ab2CNMeg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 08:34:36 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:41751 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760910Ab2CNMef (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 08:34:35 -0400
Date: Wed, 14 Mar 2012 08:34:29 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@shadowen.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] checkpatch: Suggest pr_<level> over printk(KERN_<LEVEL>
Message-ID: <20120314123429.GG15379@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>, Joe Perches <joe@perches.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Whitcroft <apw@shadowen.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <20120313220144.GD11969@thunk.org>
 <20120313150316.6ae19b95.akpm@linux-foundation.org>
 <20120314003157.GA15379@thunk.org>
 <1331686026.24613.6.camel@joe2Laptop>
 <20120314010701.GB15379@thunk.org>
 <1331687831.27389.2.camel@joe2Laptop>
 <20120314021938.GD15379@thunk.org>
 <1331692311.27389.27.camel@joe2Laptop>
 <20120314024104.GE15379@thunk.org>
 <1331694074.27389.42.camel@joe2Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331694074.27389.42.camel@joe2Laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2012 at 08:01:14PM -0700, Joe Perches wrote:
> > That's a debug message which is never by anyone other than ext4
> > developers.  Your patch also hacked the Makefile to enable it by
> > default,
> 
> It's just an example and no it didn't.
> That output is still in an #ifdef EXT4FS_DEBUG
> block and is unchanged.

I looked at your patch, and nearly all of them were in debug code.  I
know, because in practice the messages that come up with any kind of
regularity are all properly prefixed.

Look, the reason why I care about patch noise is because I have a huge
patch backlog.  Take a look at this:

      http://patchwork.ozlabs.org/project/linux-ext4/list/

Very few other people review patches, and even patches that survive
review, I've found problems that could potentially lead to data loss
or system instability.  This is not like your average device driver,
where if the machine panics once a week, "oh well", and you reboot.
Linus would get very cranky if he lost data as a result of a bad patch
slipping through.  Hence, patches don't go in until after significant
review and testing.

As a result, #1, patches that are don't add value, and are large,
simply won't get applied.  Period.  Avoiding the downside of lots of
people losing data is ****far**** more than your OCD wanting me to use
pr_warn(...) instead of printk(KERN_WARN, ...).

If you want your style patches to go in, break them into smaller
chunks, or I *will* ignore them.

#2, patches that don't add substantial value, and make it harder for
me to review and apply patches from my very substantial patch
backlog, I consider as adding ***substantial*** negative value.

That being said, I use checkpatch.pl as an initial screen, but it's
already been the case that there are warnings that I consider pure
noise, and I really, REALLY, rather not add more noise to
checkpatch.pl.  There is no group consensus about things like pr_foo
--- not as far as I've seen --- and to impose it from on high by some
patch wankers making changes to checkpatch.pl very much offends me.

      	      	     	     		      	   - Ted
