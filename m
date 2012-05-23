Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933505Ab2EWOVk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 10:21:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47377 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932304Ab2EWOVh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 10:21:37 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <87obpfxdpr.fsf@rustcorp.com.au>
References: <87obpfxdpr.fsf@rustcorp.com.au> <20120522230218.24007.3556.stgit@warthog.procyon.org.uk>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: dhowells@redhat.com, kyle@mcmartin.ca, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@linux-nfs.org
Subject: Re: [PATCH 00/23] Crypto keys and module signing
Date: Wed, 23 May 2012 15:20:47 +0100
Message-ID: <7474.1337782847@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell <rusty@rustcorp.com.au> wrote:

>         That's pretty weird.  Why not put the "@This Is A Crypto Signed
> Module\n" before the signature?  Then module-size is implied: everything
> before that signature.  The signature size is implied: everything after
> that signature.

This makes it simpler.  No scanning required.  The magic number can only be in
one place and you can find it by dead reckoning.

>         In fact, I'd modify this slightly, to allow multiple signatures.
> This would work nicely with a deterministic strip.  Find the signatures
> backward, and truncate as they fail.

Why would you want multiple signatures?  That just complicates things.  If
you're in FIPS mode, you probably have to panic if any of them fail.

I suppose I may as well punt the signature detection and removal to userspace
and pass the signature as an argument to init_module() as Dmitry suggested.
Then the signature need not be in the file at all (he wants to use an xattr or
hardware, I think).  mkinitrd and rpmbuild/kernel spec have to be changed to
accommodate enablement of these patches, so why not module-init-tools, dracut
and busybox whilst we're at it?

David
