Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889Ab0ESOg5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 10:36:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30356 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751441Ab0ESOgy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 10:36:54 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1274135154-24082-10-git-send-email-walken@google.com>
References: <1274135154-24082-10-git-send-email-walken@google.com> <1274135154-24082-1-git-send-email-walken@google.com>
To: Michel Lespinasse <walken@google.com>
Cc: dhowells@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Waychison <mikew@google.com>,
       Suleiman Souhlal <suleiman@google.com>, Ying Han <yinghan@google.com>
Subject: Re: [PATCH 09/10] x86 rwsem: down_read_critical implementation
Date: Wed, 19 May 2010 15:36:06 +0100
Message-ID: <28585.1274279766@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michel Lespinasse <walken@google.com> wrote:

> The basic properties that have been true so far still hold:
> - RWSEM_ACTIVE_READ_BIAS  & RWSEM_ACTIVE_MASK == 1
> - RWSEM_ACTIVE_WRITE_BIAS & RWSEM_ACTIVE_MASK == 1
> - RWSEM_WAITING_BIAS      & RWSEM_ACTIVE_MASK == 0
> - RWSEM_ACTIVE_WRITE_BIAS < 0 and RWSEM_WAITING_BIAS < 0
> 
> A new property is introduced: RWSEM_ACTIVE_WRITE_BIAS is set to be
> 'more negative' than RWSEM_WAITING_BIAS. This way, even the first writer
> will set the rwsem count to be < RWSEM_WAITING_BIAS and down_read_critical()
> can make use of this to determine if there are any active writers.
> 
> Signed-off-by: Michel Lespinasse <walken@google.com>

Acked-by: David Howells <dhowells@redhat.com>
