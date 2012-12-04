Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752018Ab2LDTL7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 14:11:59 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:34316 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751913Ab2LDTL4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 14:11:56 -0500
Message-ID: <1354648303.2652.21.camel@falcor>
Subject: Re: [RFC][PATCH 1/2] modsig: add support to sign kernel modules
 using ephemeral keys
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        linux-security-module@vger.kernel.org,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        linux-kernel@vger.kernel.org, Mimi Zohar <zohar@us.ibm.com>
Date: Tue, 04 Dec 2012 14:11:43 -0500
In-Reply-To: <22345.1354644867@warthog.procyon.org.uk>
References: <877gp0j5kn.fsf@rustcorp.com.au>
	 <1353939786-4829-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <22345.1354644867@warthog.procyon.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12120419-7182-0000-0000-00000386087F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-12-04 at 18:14 +0000, David Howells wrote:
> Rusty Russell <rusty@rustcorp.com.au> wrote:
> 
> > > +PHONY += _newmodpubkey_
> > > +_newmodpubkey_: 
> > > +	@rm -f $(MODSECKEY) $(MODPUBKEY)
> > > +	$(Q)$(MAKE) -W kernel/modsign_pubkey.o
> 
> Please don't do this.  It can muck up the dependencies as make thinks it has
> already done this file at this point.  Also, rebuilding bzImage yet again
> wouldn't be the best.  We already do it a number of times.  Further, if
> vmlinux is already installed when you rebuild, you may confuse gdb if the
> debuginfo then no longer matches vmlinux.

> You have to expose the private key *anyway* - so how much does this actually
> gain you?  Especially with a one-shot transient key.

The issue is creating a new keypair is tied to modsign_pubkey.  This
patch forces the creation of a new keypair, by removing the existing
one, compiles modsign_pubkey.o, and rebuilds the bzImage, and only then
signs the kernel modules and removes the private key.  The benefits of
defining a separate target to generate a keypair are described in the
patch description.

Mimi

