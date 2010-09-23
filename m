Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756151Ab0IWSyg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 14:54:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5875 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755830Ab0IWSyf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 14:54:35 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1285266454.31572.29.camel@Joe-Laptop>
References: <1285266454.31572.29.camel@Joe-Laptop> <4013.1285177436@redhat.com> <25759.1285169592@redhat.com> <1283888517.23280.241.camel@Joe-Laptop> <23323.1283864982@redhat.com> <20100907180025.GD2662@shadowen.org> <22516.1285265739@redhat.com>
To: Joe Perches <joe@perches.com>
Cc: dhowells@redhat.com, Andy Whitcroft <apw@canonical.com>,
        linux-kernel@vger.kernel.org
Subject: Re: checkpatch problem
Date: Thu, 23 Sep 2010 19:54:29 +0100
Message-ID: <25057.1285268069@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches <joe@perches.com> wrote:

> Exactly right.  Andy has a version in his testing directory
> that fixes this #define run-on block and speeds up checkpatch
> runtime rather a lot for certain files like .h files that have
> nothing but #defines.
> 
> Try applying my patch to this newer version:
> 
> http://www.kernel.org/pub/linux/kernel/people/apw/checkpatch/checkpatch.pl-testing

It still doesn't work.  In fact, I'm seeing more "Logging function has
unnecessary whitespace before a newline" warnings, such as on this:

		printk(KERN_ERR
		       "BUG: CPU#%d started up but did not get a callout!\n",
		       cpu);

where I wasn't before.

I am still getting them on #defines:

-:6841: WARNING: Logging function has unnecessary whitespace before a newline
#6841: FILE: arch/mn10300/kernel/smp.c:57:
+#define Dprintk(fmt, ...) printk(KERN_DEBUG fmt, ##__VA_ARGS__)


Also, --emacs mode appears to be broken.  It sticks something like "#7768: "
on the front of the filename encoded in the patch:

-:7768: WARNING: Logging function has unnecessary whitespace before a newline
#7768: FILE: arch/mn10300/kernel/smp.c:984:
+		printk(KERN_ERR

which emacs interprets as a filename.  Without that, emacs happily strips off
the 'FILE: ' prefix and uses the filename and line number.  I don't
particularly care about the line number in the patch: I'm not editing the
patch - I'm editing the file contributing to the patch.

David
