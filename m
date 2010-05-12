Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728Ab0ELMei (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 08:34:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55380 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751714Ab0ELMeh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 08:34:37 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1273634462-2672-8-git-send-email-walken@google.com>
References: <1273634462-2672-8-git-send-email-walken@google.com> <1273634462-2672-1-git-send-email-walken@google.com>
To: Michel Lespinasse <walken@google.com>
Cc: dhowells@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Waychison <mikew@google.com>,
       Suleiman Souhlal <suleiman@google.com>, Ying Han <yinghan@google.com>
Subject: Re: [PATCH 07/12] rwsem: wake queued readers when writer blocks on active read lock
Date: Wed, 12 May 2010 13:33:31 +0100
Message-ID: <25280.1273667611@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michel Lespinasse <walken@google.com> wrote:

> +	/* if there are no active locks, wake the front queued process(es) up.
> +	 *
> +	 * or if we're called from a failed down_write(), and there were
> +	 * already threads queued before us, and there are no active writers,
> +	 * the lock must be read owned; try to wake any read locks that were
> +	 * queued ahead of us. */

That looks weird.  Can I suggest rewriting it thus:

	/* If there are no active locks, wake the front queued process(es) up.
	 *
	 * Alternatively, if we're called from a failed down_write(), there
	 * were already threads queued before us and there are no active
	 * writers, the lock must be read owned; so we try to wake any read
	 * locks that were queued ahead of us. */

David
