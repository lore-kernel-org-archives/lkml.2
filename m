Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932306Ab0EDPqU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 11:46:20 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:37565 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754546Ab0EDPqQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 11:46:16 -0400
Date: Tue, 4 May 2010 10:46:01 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@osdl.org, akpm@linux-foundation.org, paulmck@linux.vnet.ibm.com,
       keyrings@linux-nfs.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KEYS: Fix RCU handling in key_gc_keyring()
Message-ID: <20100504154601.GA20291@us.ibm.com>
References: <20100504131610.2015.50934.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100504131610.2015.50934.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting David Howells (dhowells@redhat.com):
> key_gc_keyring() needs to either hold the RCU read lock or hold the keyring
> semaphore if it's going to scan the keyring's list.  Given that it only needs
> to read the key list, and it's doing so under a spinlock, the RCU read lock is
> the thing to use.
> 
> Furthermore, the RCU check added in e7b0a61b7929632d36cf052d9e2820ef0a9c1bfe is
> incorrect as holding the spinlock on key_serial_lock is not grounds for
> assuming a keyring's pointer list can be read safely.  Instead, a simple
> rcu_dereference() inside of the previously mentioned RCU read lock is what we
> want.
> 
> Reported-by: Serge E. Hallyn <serue@us.ibm.com>

You're obviously being far too kind.  In apparent trend for last night
I missed the lack of locking here.

> Signed-off-by: David Howells <dhowells@redhat.com>

Acked-by: Serge Hallyn <serue@us.ibm.com>

thanks,
-serge
