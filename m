Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755806Ab0EMCjo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 22:39:44 -0400
Received: from smtp-out.google.com ([74.125.121.35]:53531 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065Ab0EMCjm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 22:39:42 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=ubUs+4OHR0mQ63ax64UwzhlG4MPj6sbXeYRDI/v4HbA/qdOzoYwxJuuDIkgs5ZHkA
	YcCTBk+OFt+WboiJKXIUw==
MIME-Version: 1.0
In-Reply-To: <22741.1273666943@redhat.com>
References: <1273634462-2672-1-git-send-email-walken@google.com>
	 <1273634462-2672-7-git-send-email-walken@google.com>
	 <22741.1273666943@redhat.com>
Date: Wed, 12 May 2010 19:39:37 -0700
Message-ID: <h2h8d20b11a1005121939tb35d9708p92eebd1f7b66b93a@mail.gmail.com>
Subject: Re: [PATCH 06/12] rwsem: wake queued readers when other readers are 
	active
From: Michel Lespinasse <walken@google.com>
To: David Howells <dhowells@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Waychison <mikew@google.com>,
       Suleiman Souhlal <suleiman@google.com>, Ying Han <yinghan@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 12, 2010 at 5:22 AM, David Howells <dhowells@redhat.com> wrote:
> Michel Lespinasse <walken@google.com> wrote:
>
>> In this situation, it would be perfectly fine to let threads B and C work
>> in parallel as they each only want a read acquire on the rwsem. We can
>> recognize this situation and let A wake B as long as there are no active
>> writers on the rwsem.
>
> There can't be any active writers on the rwsem.  An active writer must have
> just been upped and is in the process of waking the first sleeper up.

Yes. My point is that by the point thread A (the writer that just got
upped) gets around to waking B (a blocked reader), another reader C
might have gotten active already. We don't want the nonzero active
count (due to C) to prevent B from getting woken.

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
