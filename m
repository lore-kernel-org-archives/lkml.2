Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756323Ab1FTXnO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 19:43:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35596 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756269Ab1FTXnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 19:43:12 -0400
Date: Mon, 20 Jun 2011 16:42:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@linux-foundation.org, linux-am33-list@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] linux/uaccess.h needs to #include linux/kernel.h for
 might_sleep()
Message-Id: <20110620164241.ac6b5d2a.akpm@linux-foundation.org>
In-Reply-To: <20110615002210.1392.64165.stgit@warthog.procyon.org.uk>
References: <20110615002210.1392.64165.stgit@warthog.procyon.org.uk>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Jun 2011 01:22:10 +0100
David Howells <dhowells@redhat.com> wrote:

> linux/uaccess.h needs to #include linux/kernel.h to get might_sleep() otherwise
> it fails to build on MN10300 allyesconfig.  This fails in a few places with
> messages like the following:

uaccess.h doesn't textually refer to might_sleep().

> In file included from security/keys/trusted.c:14:
> include/linux/uaccess.h: In function '__copy_from_user_nocache':
> include/linux/uaccess.h:52: error: implicit declaration of function 'might_sleep'

This happened because of arch/mn10300/include/asm/uaccess.h's

#define __copy_from_user(to, from, n)			\
({							\
	might_sleep();					\
	__copy_from_user_inatomic((to), (from), (n));	\
})

>  include/linux/uaccess.h |    1 +

So I'd suggest that patching the arch header file is the appropriate fix.

