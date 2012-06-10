Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752137Ab2FJGif (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 02:38:35 -0400
Received: from ozlabs.org ([203.10.76.45]:55423 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751045Ab2FJGic (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 02:38:32 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: David Howells <dhowells@redhat.com>
Cc: dhowells@redhat.com, kyle@mcmartin.ca, dmitry.kasatkin@intel.com,
        zohar@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@linux-nfs.org
Subject: Re: [PATCH 00/23] Crypto keys and module signing
In-Reply-To: <18581.1338903356@redhat.com>
References: <87ipf73lsi.fsf@rustcorp.com.au> <20120522230218.24007.3556.stgit@warthog.procyon.org.uk> <26029.1337960539@redhat.com> <18581.1338903356@redhat.com>
User-Agent: Notmuch/0.12 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Sun, 10 Jun 2012 15:17:29 +0930
Message-ID: <8762aziuq6.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 05 Jun 2012 14:35:56 +0100, David Howells <dhowells@redhat.com> wrote:
> Rusty Russell <rusty@rustcorp.com.au> wrote:
> 
> > > If you prefer to have userspace extract the module signature and pass it in
> > > uargs, here's a tree that will do that:
> > > 
> > > 	http://git.kernel.org/?p=linux/kernel/git/dhowells/linux-modsign.git;a=shortlog;h=refs/heads/modsign-uarg
> > 
> > OK, there's merit in this approach: it certainly moves the argument
> > about how to encode the signature out of my backyard :)
> 
> Not really.  The signature still has to be created by the kernel build.  It's
> just that you no longer have to care about the trade off when it comes to
> parsing it.

Yes, exactly.

> > Should we just bite the bullet and create a new syscall:
> > 
> > SYSCALL_DEFINE5(init_module2, void __user *, umod,
> > 		unsigned long, len, const char __user *, uargs,
> >                 unsigned int, siglen, const char __user *, sig)
> > 
> > But I'm easily swayed if you prefer the current approach.
> 
> "The current approach" being to attach signature to the blob?  Or to pass the
> signature separately but in the uargs?

The former.

> I would very much prefer to keep the signature in the blob and have the kernel
> extract it as there's no particular need for it to be detached - even if you
> are using IMA.
> 
> However, I don't think an extra syscall would hurt particularly - except that
> it uses up more space in the syscall table...  It would, however, be smaller
> in the signature verification department as the signature neither needs
> decoding from uargs nor extracting from the blob.

Good.  Let's have init_module2(), and let userspace decide where to get
the signature from.

Thanks,
Rusty.
