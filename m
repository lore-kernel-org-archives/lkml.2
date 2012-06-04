Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056Ab2FDEsl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 00:48:41 -0400
Received: from ozlabs.org ([203.10.76.45]:60396 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754352Ab2FDEsk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 00:48:40 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: David Howells <dhowells@redhat.com>
Cc: dhowells@redhat.com, kyle@mcmartin.ca, dmitry.kasatkin@intel.com,
        zohar@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@linux-nfs.org
Subject: Re: [PATCH 00/23] Crypto keys and module signing
In-Reply-To: <26029.1337960539@redhat.com>
References: <20120522230218.24007.3556.stgit@warthog.procyon.org.uk> <26029.1337960539@redhat.com>
User-Agent: Notmuch/0.12 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Mon, 04 Jun 2012 11:01:25 +0930
Message-ID: <87ipf73lsi.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 May 2012 16:42:19 +0100, David Howells <dhowells@redhat.com> wrote:
> 
> Hi Rusty,
> 
> If you prefer to have userspace extract the module signature and pass it in
> uargs, here's a tree that will do that:
> 
> 	http://git.kernel.org/?p=linux/kernel/git/dhowells/linux-modsign.git;a=shortlog;h=refs/heads/modsign-uarg

OK, there's merit in this approach: it certainly moves the argument
about how to encode the signature out of my backyard :)

Should we just bite the bullet and create a new syscall:

SYSCALL_DEFINE5(init_module2, void __user *, umod,
		unsigned long, len, const char __user *, uargs,
                unsigned int, siglen, const char __user *, sig)

But I'm easily swayed if you prefer the current approach.

Thanks,
Rusty.
