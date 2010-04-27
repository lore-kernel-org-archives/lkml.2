Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753144Ab0D0KPS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 06:15:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53534 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751092Ab0D0KPQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 06:15:16 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20100426160918.6f624d86.akpm@linux-foundation.org>
References: <20100426160918.6f624d86.akpm@linux-foundation.org> <20100426154441.26028.52967.stgit@warthog.procyon.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dhowells@redhat.com, torvalds@linux-foundation.org, keyrings@linux-nfs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KEYS: The request_key() syscall should link an existing key to the dest keyring
Date: Tue, 27 Apr 2010 11:15:06 +0100
Message-ID: <17298.1272363306@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote:

> I don't think I understand that description.  Are you saying that the
> patch switches things from the first example output into the second case?

request_key() system call is meant to recursively search all your keyrings for
the key you desire, and, optionally, if it doesn't exist, call out to userspace
to create one for you.

If request_key() finds or creates a key, it should, optionally, create a link
to that key from the destination keyring specified.

Therefore, if, after a successful call to request_key() with a desination
keyring specified, you see the destination keyring empty, the code didn't work
correctly.

If you see the found key in the keyring, then it did - which is what the patch
is required for.

> Is the fix needed in -stable?

Yes.

David
