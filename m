Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758675Ab2I2HOc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2012 03:14:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64165 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757946Ab2I2HOa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2012 03:14:30 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <87wqzdnwus.fsf@rustcorp.com.au>
References: <87wqzdnwus.fsf@rustcorp.com.au> <87ipay3cof.fsf@rustcorp.com.au> <87bogs492s.fsf@rustcorp.com.au> <87ehlp30pd.fsf@rustcorp.com.au> <5555.1348531649@warthog.procyon.org.uk> <8168.1348650575@warthog.procyon.org.uk> <16088.1348736905@warthog.procyon.org.uk> <27378.1348819793@warthog.procyon.org.uk>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: dhowells@redhat.com, herbert@gondor.hengli.com.au, pjones@redhat.com,
        jwboyer@redhat.com, linux-crypto@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        keyrings@linux-nfs.org
Subject: Re: [GIT PULL] Asymmetric keys and module signing
Date: Sat, 29 Sep 2012 08:13:25 +0100
Message-ID: <29407.1348902805@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell <rusty@rustcorp.com.au> wrote:

> [    2.808075] Loading module verification certificates
> [    2.809331] X.509: Cert 6e03943da0f3b015ba6ed7f5e0cac4fe48680994 has expired
> [    2.810500] MODSIGN: Problem loading in-kernel X.509 certificate (-127)

Hmmm...  Other people have seen that.

Ahhhhh!

I wonder if the problem is that the certificate is valid for 100 years....
That might well cause an overflow on a 32-bit system.

Could you try changing the '36500' in kernel/Makefile to something shorter,
like 365?

David
