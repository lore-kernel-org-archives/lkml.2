Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934294Ab2FENgx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 09:36:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17652 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934239Ab2FENgv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 09:36:51 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <87ipf73lsi.fsf@rustcorp.com.au>
References: <87ipf73lsi.fsf@rustcorp.com.au> <20120522230218.24007.3556.stgit@warthog.procyon.org.uk> <26029.1337960539@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: dhowells@redhat.com, kyle@mcmartin.ca, dmitry.kasatkin@intel.com,
        zohar@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@linux-nfs.org
Subject: Re: [PATCH 00/23] Crypto keys and module signing
Date: Tue, 05 Jun 2012 14:35:56 +0100
Message-ID: <18581.1338903356@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell <rusty@rustcorp.com.au> wrote:

> > If you prefer to have userspace extract the module signature and pass it in
> > uargs, here's a tree that will do that:
> > 
> > 	http://git.kernel.org/?p=linux/kernel/git/dhowells/linux-modsign.git;a=shortlog;h=refs/heads/modsign-uarg
> 
> OK, there's merit in this approach: it certainly moves the argument
> about how to encode the signature out of my backyard :)

Not really.  The signature still has to be created by the kernel build.  It's
just that you no longer have to care about the trade off when it comes to
parsing it.

> Should we just bite the bullet and create a new syscall:
> 
> SYSCALL_DEFINE5(init_module2, void __user *, umod,
> 		unsigned long, len, const char __user *, uargs,
>                 unsigned int, siglen, const char __user *, sig)
> 
> But I'm easily swayed if you prefer the current approach.

"The current approach" being to attach signature to the blob?  Or to pass the
signature separately but in the uargs?

I would very much prefer to keep the signature in the blob and have the kernel
extract it as there's no particular need for it to be detached - even if you
are using IMA.

However, I don't think an extra syscall would hurt particularly - except that
it uses up more space in the syscall table...  It would, however, be smaller
in the signature verification department as the signature neither needs
decoding from uargs nor extracting from the blob.

David
