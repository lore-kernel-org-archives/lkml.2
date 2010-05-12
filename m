Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751972Ab0ELMX1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 08:23:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62368 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751219Ab0ELMX0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 08:23:26 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1273634462-2672-7-git-send-email-walken@google.com>
References: <1273634462-2672-7-git-send-email-walken@google.com> <1273634462-2672-1-git-send-email-walken@google.com>
To: Michel Lespinasse <walken@google.com>
Cc: dhowells@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Waychison <mikew@google.com>,
       Suleiman Souhlal <suleiman@google.com>, Ying Han <yinghan@google.com>
Subject: Re: [PATCH 06/12] rwsem: wake queued readers when other readers are active
Date: Wed, 12 May 2010 13:22:23 +0100
Message-ID: <22741.1273666943@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michel Lespinasse <walken@google.com> wrote:

> In this situation, it would be perfectly fine to let threads B and C work
> in parallel as they each only want a read acquire on the rwsem. We can
> recognize this situation and let A wake B as long as there are no active
> writers on the rwsem.

There can't be any active writers on the rwsem.  An active writer must have
just been upped and is in the process of waking the first sleeper up.

David
