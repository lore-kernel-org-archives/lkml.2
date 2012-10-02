Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966Ab2JBOH7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 10:07:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31255 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753738Ab2JBOH5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 10:07:57 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <874nmd4d2o.fsf@rustcorp.com.au>
References: <874nmd4d2o.fsf@rustcorp.com.au> <87wqzdnwus.fsf@rustcorp.com.au> <87ipay3cof.fsf@rustcorp.com.au> <87bogs492s.fsf@rustcorp.com.au> <87ehlp30pd.fsf@rustcorp.com.au> <5555.1348531649@warthog.procyon.org.uk> <8168.1348650575@warthog.procyon.org.uk> <16088.1348736905@warthog.procyon.org.uk> <27378.1348819793@warthog.procyon.org.uk> <29451.1348903010@warthog.procyon.org.uk>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: dhowells@redhat.com, herbert@gondor.hengli.com.au, pjones@redhat.com,
        jwboyer@redhat.com, linux-crypto@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        keyrings@linux-nfs.org
Subject: Re: [GIT PULL] Asymmetric keys and module signing
Date: Tue, 02 Oct 2012 15:07:45 +0100
Message-ID: <23688.1349186865@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell <rusty@rustcorp.com.au> wrote:

> Right.  I think we need to use different names for generated vs supplied
> files

The problem with supplied files is people who do allyesconfig, allmodconfig
and randconfig just to test things finding that their builds break.  The
kernel build magic is not really set up to handle external files like this.  I
suppose make logic can be used to conditionally include stuff that might not
exist.

> BTW, you missed a Signed-off-by: on your "MODSIGN: Use the same digest
> for the autogen key sig as for the module sig" patch.  Please update.

Done.

I've also added a patch to convert the system clock to a struct tm and to
produce a struct tm within the ASN.1 decode and then compare those rather than
time_t values as a way to deal with the validity time overflow problem.  We
may have to be able to handle certificates that we haven't generated that
stretch beyond 2038 (I wonder if we might find such in the UEFI key database
for example.

Another way of dealing with this could be to make mktime() within the kernel
produce a u64 rather than an unsigned long, and then compare those.

David
