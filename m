Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756227Ab0IWUbE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 16:31:04 -0400
Received: from mail.perches.com ([173.55.12.10]:2298 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753814Ab0IWUbD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 16:31:03 -0400
Subject: Re: checkpatch problem
From: Joe Perches <joe@perches.com>
To: David Howells <dhowells@redhat.com>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
In-Reply-To: <25057.1285268069@redhat.com>
References: <1285266454.31572.29.camel@Joe-Laptop>
	 <4013.1285177436@redhat.com> <25759.1285169592@redhat.com>
	 <1283888517.23280.241.camel@Joe-Laptop> <23323.1283864982@redhat.com>
	 <20100907180025.GD2662@shadowen.org> <22516.1285265739@redhat.com>
	 <25057.1285268069@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 23 Sep 2010 13:31:01 -0700
Message-ID: <1285273861.25928.6.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-09-23 at 19:54 +0100, David Howells wrote:
> Joe Perches <joe@perches.com> wrote:
> > Exactly right.  Andy has a version in his testing directory
> > that fixes this #define run-on block and speeds up checkpatch
> > runtime rather a lot for certain files like .h files that have
> > nothing but #defines.
> > Try applying my patch to this newer version:
> > http://www.kernel.org/pub/linux/kernel/people/apw/checkpatch/checkpatch.pl-testing
> 
> It still doesn't work.  In fact, I'm seeing more "Logging function has
> unnecessary whitespace before a newline" warnings, such as on this:
> 
> 		printk(KERN_ERR
> 		       "BUG: CPU#%d started up but did not get a callout!\n",
> 		       cpu);

Yes, it's completely borked.

ctx_statement_block returns code beyond the current
statement terminating ";".

Andy may be able to do something about it or know
about some appropriate knob to twist.

I don't really want to learn too much about
checkpatch internals.  Sorry.

