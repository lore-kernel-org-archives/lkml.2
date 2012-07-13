Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756395Ab2GMUPR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 16:15:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55463 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753350Ab2GMUPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 16:15:16 -0400
Date: Fri, 13 Jul 2012 13:15:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michel Lespinasse <walken@google.com>
Cc: aarcange@redhat.com, dwmw2@infradead.org, riel@redhat.com,
        peterz@infradead.org, daniel.santos@pobox.com, axboe@kernel.dk,
        ebiederm@xmission.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH v2 05/12] rbtree: performance and correctness test
Message-Id: <20120713131514.86ab4df4.akpm@linux-foundation.org>
In-Reply-To: <1342139517-3451-6-git-send-email-walken@google.com>
References: <1342139517-3451-1-git-send-email-walken@google.com>
	<1342139517-3451-6-git-send-email-walken@google.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jul 2012 17:31:50 -0700
Michel Lespinasse <walken@google.com> wrote:

> This small module helps measure the performance of rbtree insert and erase.
> 
> Additionally, we run a few correctness tests to check that the rbtrees have
> all desired properties:
> - contains the right number of nodes in the order desired,
> - never two consecutive red nodes on any path,
> - all paths to leaf nodes have the same number of black nodes,
> - root node is black
> 
> Signed-off-by: Michel Lespinasse <walken@google.com>
> ---
>  Makefile            |    2 +-
>  lib/Kconfig.debug   |    1 +
>  tests/Kconfig       |   18 +++++++
>  tests/Makefile      |    1 +
>  tests/rbtree_test.c |  135 +++++++++++++++++++++++++++++++++++++++++++++++++++

This patch does a new thing: adds a kernel self-test module into
lib/tests/ and sets up the infrastructure to add new kernel self-test
modules in that directory.

I don't see a problem with this per-se, but it is a new thing which we
should think about.

In previous such cases (eg, kernel/rcutorture.c) we put those modules
into the same directory as the code which is being tested.  So to
follow that pattern, this new code would have gone into lib/.

If we adopt your new proposal then we should perhaps also move tests
such as rcutorture over into tests/.  And that makes one wonder whether
we should have a standalone directory for kernel selftest modules.  eg
tests/self-test-nmodules/.

