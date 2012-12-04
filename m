Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752510Ab2LDSOk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 13:14:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23740 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751829Ab2LDSOh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 13:14:37 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <877gp0j5kn.fsf@rustcorp.com.au>
References: <877gp0j5kn.fsf@rustcorp.com.au> <1353939786-4829-1-git-send-email-zohar@linux.vnet.ibm.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: dhowells@redhat.com, Mimi Zohar <zohar@linux.vnet.ibm.com>,
        linux-security-module@vger.kernel.org,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        linux-kernel@vger.kernel.org, Mimi Zohar <zohar@us.ibm.com>
Subject: Re: [RFC][PATCH 1/2] modsig: add support to sign kernel modules using ephemeral keys
Date: Tue, 04 Dec 2012 18:14:27 +0000
Message-ID: <22345.1354644867@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell <rusty@rustcorp.com.au> wrote:

> > +PHONY += _newmodpubkey_
> > +_newmodpubkey_: 
> > +	@rm -f $(MODSECKEY) $(MODPUBKEY)
> > +	$(Q)$(MAKE) -W kernel/modsign_pubkey.o

Please don't do this.  It can muck up the dependencies as make thinks it has
already done this file at this point.  Also, rebuilding bzImage yet again
wouldn't be the best.  We already do it a number of times.  Further, if
vmlinux is already installed when you rebuild, you may confuse gdb if the
debuginfo then no longer matches vmlinux.

You have to expose the private key *anyway* - so how much does this actually
gain you?  Especially with a one-shot transient key.

David
