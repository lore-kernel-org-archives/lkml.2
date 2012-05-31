Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758249Ab2EaOLW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 10:11:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38483 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758091Ab2EaOLT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 10:11:19 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
In-Reply-To: <87r4u6w58c.fsf@rustcorp.com.au>
References: <87r4u6w58c.fsf@rustcorp.com.au> <8762blyedn.fsf@rustcorp.com.au> <87obpfxdpr.fsf@rustcorp.com.au> <20120522230218.24007.3556.stgit@warthog.procyon.org.uk> <7474.1337782847@redhat.com> <5107.1337868051@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: dhowells@redhat.com, kyle@mcmartin.ca, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@linux-nfs.org
Subject: Re: [PATCH 00/23] Crypto keys and module signing
Date: Thu, 31 May 2012 15:11:02 +0100
Message-ID: <17249.1338473462@redhat.com>
From: David Howells <dhowells@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell <rusty@rustcorp.com.au> wrote:

> > That then adds 5 bytes to the magic string.  Is that really so bad?
> 
> Yes, because it's unnecessary.

I'm sorry Rusty, but this argument is disingenuous.

Yes, a length field in the file is unnecessary - BUT SO TOO is scanning!  By
this argument, your idea is really so bad too.  It's all about the trade off
one chooses to make.  I do not accept your chosen trade off[*] as being the
best one.

David

[*] And, yes, it *is* a trade off: you are trading CPU time and permanently
    resident kernel code space in order to save a tiny amount of disk
    space[**].

[**] Assuming 512 byte blocks and a 5 byte size field, probably fewer than 1%
     of modules will expand sufficiently to consume an extra block.  Further,
     making it a 2-byte binary field would make it even less intrusive, both
     in the file and in the module verifier.
