Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925Ab2GIXrg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 19:47:36 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54725 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754770Ab2GIXre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 19:47:34 -0400
Date: Mon, 9 Jul 2012 16:47:31 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Joe Perches <joe@perches.com>
cc: linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org,
        apw@canonical.com
Subject: Re: + checkpatch-add-check-for-use-of-sizeof-without-parenthesis.patch
 added to -mm tree
In-Reply-To: <1341876067.6118.67.camel@joe2Laptop>
Message-ID: <alpine.DEB.2.00.1207091640170.8185@chino.kir.corp.google.com>
References: <20120709215256.9A4F71E0043@wpzn4.hot.corp.google.com> <alpine.DEB.2.00.1207091514310.32082@chino.kir.corp.google.com> <1341873376.6118.56.camel@joe2Laptop> <alpine.DEB.2.00.1207091553120.3552@chino.kir.corp.google.com>
 <1341876067.6118.67.camel@joe2Laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jul 2012, Joe Perches wrote:

> > So, nack, don't start enforcing your own coding style and preferences in 
> > checkpatch.pl.
> 
> Not just my opinion.
> 
> https://lkml.org/lkml/2008/12/23/138
> --------------------------------------------------------
> Date: Tue, 23 Dec 2008 10:08:50 -0800 (PST)
> From: Linus Torvalds <>
> []
> Another example of this is "sizeof". The kernel universally (I hope) has 
> parenthesis around the sizeof argument, even though it's clearly not 
> required by the C language. 
> 

Well, let's add Linus to the cc then because it's certainly not a C 
standard.  The sizeof operator requires parenthesis for type names, you 
can't do "sizeof unsigned long", for example, it requires 
"sizeof (unsigned long)".  All other unary operators do not need the 
parenthesis by ANY C standard.

Documentation/CodingStyle does not ask for the parenthesis to be added 
just like it doesn't ask for parenthesis to do things like (i++); which is 
another unary operator.  You would complain that (i++) has unnecessary 
parenthesis, and I claim the same for sizeof (*foo).

The fact that the kernel has over 1000 occurrences of "sizeof ..." without 
parenthesis shows that people actually know what _is_ standard, otherwise 
you'd get an error at compile time.  Taking just unary operators with 
pointers as an example, it spans the entire kernel:

$ grep -lr 'sizeof \*' * | cut -f1 -d / | uniq
arch
crypto
Documentation
drivers
fs
include
ipc
kernel
lib
net
security
sound
tools

So, for people like me who don't use checkpatch.pl at all, please modify 
Documentation/CodingStyle and get Linus to merge it to add this as a 
stylistic preference.  Saying it's a standard, though, is wrong.
