Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758866Ab0EDMtP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 08:49:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23948 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752958Ab0EDMtN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 08:49:13 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20100503220420.GA6968@us.ibm.com>
References: <20100503220420.GA6968@us.ibm.com> <20100430133208.2126.56765.stgit@warthog.procyon.org.uk>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: dhowells@redhat.com, torvalds@osdl.org, akpm@linux-foundation.org,
       keyrings@linux-nfs.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] KEYS: Fix an RCU warning in the reading of user keys
Date: Tue, 04 May 2010 13:48:56 +0100
Message-ID: <31231.1272977336@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge E. Hallyn <serue@us.ibm.com> wrote:

> heck it also serves to document it a bit, as looking at the fn
> itself it's not clear that it is called under key->sem.

Give or take the banner comment on user_read() where it states this explicitly:

	/*
	 * read the key data
	 * - the key's semaphore is read-locked
	 */
	long user_read(const struct key *key, char __user *buffer, size_t buflen)

and Documentation/keys.txt where it also states this explicitly:

 (*) long (*read)(const struct key *key, char __user *buffer, size_t buflen);

     ...

     This method will be called with the key's semaphore read-locked. This will
     prevent the key's payload changing. It is not necessary to use RCU locking
     when accessing the key's payload. It is safe to sleep in this method, such
     as might happen when the userspace buffer is accessed.

:-)

David

David
