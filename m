Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137Ab0KWXXc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 18:23:32 -0500
Received: from mail.perches.com ([173.55.12.10]:1822 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752324Ab0KWXXc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 18:23:32 -0500
Date: Tue, 23 Nov 2010 15:23:27 -0800 (PST)
From: Joe Perches <joe@perches.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, Arjan van de Ven <arjan@infradead.org>,
        <kernel@pengutronix.de>, <linux-arm-kernel@lists.infradead.org>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: About multi-line printk and the need (not) to repeat loglevel
 markers [Was: Re: [PATCH] ARM: mx3/pcm037: properly allocate memory for
 mx3-camera]
In-Reply-To: <20101123223344.GE26510@n2100.arm.linux.org.uk>
Message-ID: <Pine.LNX.4.30.1011231520150.20819-100000@mail.perches.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Nov 2010, Russell King - ARM Linux wrote:

> On Wed, Nov 24, 2010 at 07:16:06AM +0900, Linus Torvalds wrote:
> > No. The KERN_WARNING in the middle of a string is always totally
> > bogus. There is no "should be". It's just wrong.
> Oh dear.
> Sounds like this is something which needs auditing as a result of your
> change, and sounds like its something that kernelnewbies people could
> do.  My own greps haven't revealed any cases though.

They used to.  I tried to fix all of the ones I could find
about a year ago.

commit ad361c9884e809340f6daca80d56a9e9c871690a
Author: Joe Perches <joe@perches.com>
Date:   Mon Jul 6 13:05:40 2009 -0700

    Remove multiple KERN_ prefixes from printk formats

    Commit 5fd29d6ccbc98884569d6f3105aeca70858b3e0f ("printk: clean up
    handling of log-levels and newlines") changed printk semantics.  printk
    lines with multiple KERN_<level> prefixes are no longer emitted as
    before the patch.

    <level> is now included in the output on each additional use.

    Remove all uses of multiple KERN_<level>s in formats.

    Signed-off-by: Joe Perches <joe@perches.com>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

