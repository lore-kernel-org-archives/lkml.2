Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758253Ab2EVWMV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 18:12:21 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:49607 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755517Ab2EVWMT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 18:12:19 -0400
Message-ID: <1337724736.11918.8.camel@joe2Laptop>
Subject: Re: [GIT PATCH] driver core patches for 3.5-rc1 - try 2
From: Joe Perches <joe@perches.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Kay Sievers <kay@vrfy.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Date: Tue, 22 May 2012 15:12:16 -0700
In-Reply-To: <20120522220534.GC12705@kroah.com>
References: <1337723927.9270.15.camel@joe2Laptop>
	 <20120522220534.GC12705@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(adding lkml and not editing Greg's reply)

On Tue, 2012-05-22 at 15:05 -0700, Greg KH wrote:
> On Tue, May 22, 2012 at 02:58:47PM -0700, Joe Perches wrote:
> > While there are several things I like about the
> > printk modifications, (binary header, delta time,
> > slightly better partial message deinterleaving,
> > global msg_id, kmsg is ok too), I am concerned
> > about the utility and expectations for the new
> > [v]printk_emit functions.
> > 
> > I think it is not really ready to be merged
> > at this time.
> > 
> > The commit sequencing was unclean.
> 
> Yes, but the build was never broken, the system always worked, and the
> end result was agreed apon by everyone as a nice addition.
> 
> > The original commit originally required KERN_CONT
> > and it was modified by another commit to return
> > to the current behavior.
> > 
> > What really are the expectations and true use-cases
> > for [v]printk_emit?
> 
> What's wrong with the existing use case?  Since when do we write
> use-cases for kernel functions?

When it's a generic function that appears to be used
to attach additional data to message logging,
and it takes up buffer space and currently reduces
the number of dev_<foo> messages in dmesg without
adding value.

What's it for and who's going to use it and more
importantly, why?

I do not want to link human readable messaging with
machine parsing of binary data.  I'm not sure it's
useful and possibly sets expectations for immutability.

> > How is it really better that what is available now?
> > 
> > Perhaps it would be better to respin all the
> > printk modifications without adding [v]printk_emit
> > and have the [v]printk_emit bits debated a bit more.
> 
> I'm always glad to review patches, but to just propose something that
> works to be reverted without a patch to replace the functionality, isn't
> ok.

It hasn't been committed yet in anything other than
-next.

Lots of stuff gets committed there and later removed
and hits Linus' mainline tree.

