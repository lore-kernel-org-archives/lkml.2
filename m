Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760526Ab2FDMtO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 08:49:14 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:34780 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753560Ab2FDMtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 08:49:12 -0400
Message-ID: <1338814071.4044.19.camel@falcor>
Subject: Re: [PATCH 00/23] Crypto keys and module signing
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: David Howells <dhowells@redhat.com>, kyle@mcmartin.ca,
        dmitry.kasatkin@intel.com, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@linux-nfs.org
Date: Mon, 04 Jun 2012 08:47:51 -0400
In-Reply-To: <87ipf73lsi.fsf@rustcorp.com.au>
References: <20120522230218.24007.3556.stgit@warthog.procyon.org.uk>
	 <26029.1337960539@redhat.com> <87ipf73lsi.fsf@rustcorp.com.au>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12060412-7408-0000-0000-0000058E8497
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-04 at 11:01 +0930, Rusty Russell wrote:
> On Fri, 25 May 2012 16:42:19 +0100, David Howells <dhowells@redhat.com> wrote:
> > 
> > Hi Rusty,
> > 
> > If you prefer to have userspace extract the module signature and pass it in
> > uargs, here's a tree that will do that:
> > 
> > 	http://git.kernel.org/?p=linux/kernel/git/dhowells/linux-modsign.git;a=shortlog;h=refs/heads/modsign-uarg
> 
> OK, there's merit in this approach: it certainly moves the argument
> about how to encode the signature out of my backyard :)
> 
> Should we just bite the bullet and create a new syscall:
> 
> SYSCALL_DEFINE5(init_module2, void __user *, umod,
> 		unsigned long, len, const char __user *, uargs,
>                 unsigned int, siglen, const char __user *, sig)
> 
> But I'm easily swayed if you prefer the current approach.
> 
> Thanks,
> Rusty.

If you're really considering creating a new syscall, then perhaps this
discussion should include passing the file descriptor instead of a
buffer and signature.  As I said https://lkml.org/lkml/2012/5/25/261, I
don't know the historical reasons for passing a buffer instead of the
file descriptor itself.  If the file descriptor was passed, it would
allow IMA-appraisal, which is in the process of being upstreamed, to
verify and enforce file data and metadata integrity like on the other
hooks open, execve, and mmap.

thanks,

Mimi

