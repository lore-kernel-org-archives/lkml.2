Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890Ab2LCCok (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 21:44:40 -0500
Received: from ozlabs.org ([203.10.76.45]:38402 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754519Ab2LCCoh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 21:44:37 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        linux-security-module@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        Mimi Zohar <zohar@us.ibm.com>, "David Howells" <dhowells@redhat.com>
Subject: Re: [RFC][PATCH 2/2] modsig: differentiate between ephemeral and persistent key names
In-Reply-To: <1353939786-4829-2-git-send-email-zohar@linux.vnet.ibm.com>
References: <1353939786-4829-1-git-send-email-zohar@linux.vnet.ibm.com> <1353939786-4829-2-git-send-email-zohar@linux.vnet.ibm.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Mon, 03 Dec 2012 11:56:39 +1030
Message-ID: <874nk4j580.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mimi Zohar <zohar@linux.vnet.ibm.com> writes:
> Using the same name for ephemeral and "persistent" keys results
> in deleting the "persistent" key.  This patch renames the normal
> kbuild asymmetric key pair name to "default_signing_key" and the
> ephemeral key pair name to "ephemeral_signing_key".

I like the idea: I was always uncomfortable with the mixing of
persistent and temporary keys.  But it's a bit misguided, because surely
persistent keys don't belong in the build tree at all.

How about we do something like:

# Default to temporary keys
MODKEYPREFIX = ./temp_signing_key

MODSECKEY = $(MODKEYPREFIX).priv
MODPUBKEY = $(MODKEYPREFIX).x509

Then encourage people to do:

        make MODKEYPREFIX=...

We could also use a config option to set the path, but that's probably
less convenient.

Cheers,
Rusty.
