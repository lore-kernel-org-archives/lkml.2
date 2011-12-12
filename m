Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766Ab1LLBWE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 20:22:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8967 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752702Ab1LLBWA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 20:22:00 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <87obvfogc6.fsf@rustcorp.com.au>
References: <87obvfogc6.fsf@rustcorp.com.au> <8739csq5ac.fsf@rustcorp.com.au> <87boriouwa.fsf@rustcorp.com.au> <20111202184229.21874.25782.stgit@warthog.procyon.org.uk> <20111202184651.21874.57769.stgit@warthog.procyon.org.uk> <2657.1323456206@redhat.com> <30007.1323526114@redhat.com>
To: Rusty Russell <rusty@ozlabs.org>
Cc: dhowells@redhat.com, keyrings@linux-nfs.org, linux-crypto@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmitry.kasatkin@intel.com, zohar@linux.vnet.ibm.com,
        arjan.van.de.ven@intel.com, alan.cox@intel.com,
        Jon Masters <jcm@jonmasters.org>
Subject: Re: [PATCH 21/21] MODSIGN: Apply signature checking to modules on module load [ver #3]
Date: Mon, 12 Dec 2011 01:21:40 +0000
Message-ID: <26644.1323652900@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell <rusty@ozlabs.org> wrote:

> I think you misunderstand, I'm talking about the modinfo command, not
> the .modinfo section.

Sorry, yes.  But why do you need to enhance modinfo?

> But I need to know exactly what these version-dependent mangling of
> modules is.  Is it real?  Is it more than strip?  Is it so hard to fix
> that it makes sense to add 450 lines of dense kernel code to allow
> alteration of a module after signing?

The strip program (as far as I know that's the only binutil that we need worry
about) rearranges and reorders the section, symbol and relocation tables when
it discards stuff, and different versions of strip have done it differently.

There's GNU build ID.  gcc/binutils was changed at some point to insert an ELF
note with the time at which the binary was built (something to do with
debuginfo matching, I think), and strip would update this when run on the
binary.

I haven't encountered many other things introducing breakage that wasn't the
fault of the tool doing the breaking - which usually got fixed pretty quickly.


However, you said it should be fairly easy to jump over the ELF parcel to get
to the signature.  How do you plan on doing that?  I presume you would just
parse sufficient of the ELF to find the theoretical ELF EOF and then look there
for a whole string of signatures - and hope they haven't got removed by some
unanticipated tool before you see the module.

David
