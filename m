Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623Ab2IZJJt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 05:09:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26657 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753325Ab2IZJJs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 05:09:48 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <87ehlp30pd.fsf@rustcorp.com.au>
References: <87ehlp30pd.fsf@rustcorp.com.au> <5555.1348531649@warthog.procyon.org.uk>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: dhowells@redhat.com, herbert@gondor.hengli.com.au, pjones@redhat.com,
        jwboyer@redhat.com, linux-crypto@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        keyrings@linux-nfs.org
Subject: Re: [GIT PULL] Asymmetric keys and module signing
Date: Wed, 26 Sep 2012 10:09:35 +0100
Message-ID: <8168.1348650575@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell <rusty@rustcorp.com.au> wrote:

> We do a very simple search for a particular string appended to the module
> (which is cache-hot and about to be SHA'd anyway).  There's both a config
> option and a boot parameter which control whether we accept (and taint) or
> fail with unsigned modules.

I've adjusted your patch description to this:

    We do a very simple search for a particular string appended to the module
    (which is cache-hot and about to be SHA'd anyway).  There's both a config
    option and a boot parameter which control whether we accept or fail with
    unsigned modules and modules that are signed with an unknown key.

    If module signing is enabled, the kernel will be tainted if a module is
    accepted that is unsigned or has a signature for which we don't have the
    key.

I think it's worth mentioning the policy for unknown keys and worth making
clear under what circumstances we mean the kernel to be tainted.

David
