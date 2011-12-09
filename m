Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753666Ab1LISnt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 13:43:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57729 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752613Ab1LISnq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 13:43:46 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <87boriouwa.fsf@rustcorp.com.au>
References: <87boriouwa.fsf@rustcorp.com.au> <20111202184229.21874.25782.stgit@warthog.procyon.org.uk> <20111202184651.21874.57769.stgit@warthog.procyon.org.uk>
To: Rusty Russell <rusty@ozlabs.org>
Cc: dhowells@redhat.com, keyrings@linux-nfs.org, linux-crypto@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmitry.kasatkin@intel.com, zohar@linux.vnet.ibm.com,
        arjan.van.de.ven@intel.com, alan.cox@intel.com
Subject: Re: [PATCH 21/21] MODSIGN: Apply signature checking to modules on module load [ver #3]
Date: Fri, 09 Dec 2011 18:43:26 +0000
Message-ID: <2657.1323456206@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell <rusty@ozlabs.org> wrote:

> And adds a great deal of code in a supposedly security-sensitive path to
> achieve it.
> 
> How about simply append a signature to the module?  That'd be about 20 lines
> of code to carefully check the bounds of the module to figure out where the
> signature is.  You could even allow multiple signatures, then have one for
> stripped, and one for non-stripped versions.

A big chunk of the code is dealing with the cryptographic bits - and you need
those anyway - and if it's done right it can be shared with other things
(eCryptfs for example; maybe CIFS from what Steve French said) and auxiliary
keys can be stored in places other than the kernel (the TPM for example).

> Sure, you now need to re-append that after stripping, but that's not the
> kernel's problem.

You may also have to remove the signature before passing it to any binutils
tool lest it malfunction on the trailer - and would you also have to modify
insmod and modprobe?  I suspect they parse the ELF to find out about parameters
and things.

I've found that rpmbuild and mkinitrd alter the module files at various times,
so you'd need a bunch of signatures, one for each (may just be two, but I can't
guarantee that).  This means the kernel build process needs to know what
transformations are going to be applied to a module - something that has
changed occasionally within the distribution I use and may vary between
distributions (or even just someone building for themselves).

David
