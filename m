Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756521Ab0EYJMU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 05:12:20 -0400
Received: from smtp-out.google.com ([74.125.121.35]:11110 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956Ab0EYJMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 05:12:18 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=ZGlltjyIZkEZMb72ES3h7tE+20dwWL+MMReArry4dlvE2JRcUB36oTf1wVpCzowIx
	xWdOpNhOs9MJLPPxIaqBg==
MIME-Version: 1.0
In-Reply-To: <1274777239.5882.581.camel@twins>
References: <1274733081-4623-1-git-send-email-walken@google.com>
	<1274777239.5882.581.camel@twins>
Date: Tue, 25 May 2010 02:12:14 -0700
Message-ID: <AANLkTikbeXjmRW4gqiy1Ss-Suce5gIM4xJ5o9Z81ZTQX@mail.gmail.com>
Subject: Re: [PATCH 00/11] V4: rwsem changes + down_read_critical() proposal
From: Michel Lespinasse <walken@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Waychison <mikew@google.com>,
       Suleiman Souhlal <suleiman@google.com>, Ying Han <yinghan@google.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 25, 2010 at 1:47 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> So what happened to those patches that dropped mmap_sem during I/O?

Yes, we do have patches trying to release the mmap_sem when a page
fault for a file backed VMA blocks on accessing the corresponding
file. We have not given up on these, and we intend to try submitting
them again. However, these patches do *not* address the case of a page
fault blocking while trying to get a free page (i.e. when you get
under high memory pressure).

> I really don't like people tinkering with the lock implementations like
> this. Nor do I like the naming, stats are in no way _critical_.

Critical here refers to the fact that you're not allowed to block
while holding the unfairly acquired rwsem.

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
