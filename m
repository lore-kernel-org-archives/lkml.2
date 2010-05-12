Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280Ab0ELNL7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 09:11:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29981 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751565Ab0ELNL5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 09:11:57 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1273634462-2672-13-git-send-email-walken@google.com>
References: <1273634462-2672-13-git-send-email-walken@google.com> <1273634462-2672-1-git-send-email-walken@google.com>
To: Michel Lespinasse <walken@google.com>
Cc: dhowells@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Waychison <mikew@google.com>,
       Suleiman Souhlal <suleiman@google.com>, Ying Han <yinghan@google.com>
Subject: Re: [PATCH 12/12] Use down_read_unfair() for /sys/<pid>/exe and /sys/<pid>/maps files
Date: Wed, 12 May 2010 14:10:38 +0100
Message-ID: <10175.1273669838@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michel Lespinasse <walken@google.com> wrote:

> - Thread C is a monitoring process trying to read every /proc/pid/maps
>   in the system. This requires acquiring the mmap_sem for read. Thread C
>   blocks behind B, waiting for A to release the rwsem.  If thread C
>   could be allowed to run in parallel with A, it would probably get done
>   long before thread A's disk access completes, thus not actually slowing
>   down thread B.

Is it possible for someone to execute a DoS attack on another process using
a bunch of threads reading /proc/pid/maps?

David
