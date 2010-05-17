Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756625Ab0EQWrZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 18:47:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37647 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753923Ab0EQWrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 18:47:24 -0400
Date: Mon, 17 May 2010 15:44:24 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Michel Lespinasse <walken@google.com>
cc: David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Waychison <mikew@google.com>,
       Suleiman Souhlal <suleiman@google.com>, Ying Han <yinghan@google.com>
Subject: Re: [PATCH 07/10] generic rwsem: implement down_read_critical() /
 up_read_critical()
In-Reply-To: <1274135154-24082-8-git-send-email-walken@google.com>
Message-ID: <alpine.LFD.2.00.1005171532430.4195@i5.linux-foundation.org>
References: <1274135154-24082-1-git-send-email-walken@google.com> <1274135154-24082-8-git-send-email-walken@google.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 17 May 2010, Michel Lespinasse wrote:
>
> Add down_read_critical() / up_read_critical() API.
> 
> down_read_critical() is similar to down_read() with the following changes:
> - when the rwsem is read owned with queued writers, down_read_unfair() callers
>   are allowed to acquire the rwsem for read without queueing;

You didn't update the comment for the new name here...

> - when the rwsem is write owned, down_read_unfair() callers get queued in
>   front of threads trying to acquire the rwsem by other means.

.. or here. In this case, it really is more about "unfairness", but I'm 
not convinced it should be so in the naming anyway, even if internally it 
might be __down_read_unfair. "critical" I think covers both.

> - caller can't sleep until releasing lock with up_read_critical(),
>   and preemption is disabled for that time.

But you did here (because it's a new thing).

Anyway, the series looks mostly acceptable to me in this form. I think it 
conceptually works out, and I think that the non-preemption guarantee 
should mean that starvation of writers is not likely an issue. However, 
I'd definitely like some second opinions on it. I'm not going to apply 
this series without acks from people. So you should try to convince DavidH 
too that this actually really does matter and makes sense.

		Linus
