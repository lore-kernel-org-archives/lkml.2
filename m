Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753685Ab0EUCoS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 22:44:18 -0400
Received: from smtp-out.google.com ([216.239.44.51]:7484 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013Ab0EUCoR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 22:44:17 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=b3nhirEEn1u4juMo+ilyaOdE01DVK5Lj9NZbphgJT1q+FQhREgztLqFtzV+Jf9zP5
	7uJhD1e758EgH4AqlM0jQ==
MIME-Version: 1.0
In-Reply-To: <31783.1274282492@redhat.com>
References: <1274135154-24082-1-git-send-email-walken@google.com>
	 <1274135154-24082-11-git-send-email-walken@google.com>
	 <31783.1274282492@redhat.com>
Date: Thu, 20 May 2010 19:44:12 -0700
Message-ID: <AANLkTimcqi9TUnWMOIRAYA-SphHzqXeb9s_B54eNnkT4@mail.gmail.com>
Subject: Re: [PATCH 10/10] Use down_read_critical() for /sys/<pid>/exe and 
	/sys/<pid>/maps files
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

On Wed, May 19, 2010 at 8:21 AM, David Howells <dhowells@redhat.com> wrote:
>  0   0  10   2   1 s   2/2         0         0   2217200    636227    210255
>  0   0  10   2   1 s   2/2         0         0   2217903    629175    212926
>  0   0  10   2   1 s   2/2         0         0   2224136    647912    212506
>
> Feel free to have a play.

Thanks for sharing your testing code.

> BTW, the code also works on FRV in NOMMU mode (which uses the spinlock-based
> rwsem version).

Yes, I made sure to keep the generic (and non-x86 asm) versions
working by always separating x86 specific changes from the rest.

> However...  I'm not certain that giving a process that's accessing
> /proc/pid/maps priority over a second process that may be trying to do mmap or
> page fault or something internally is a good idea.

One thing to keep in mind if you're concerned about the higher
priority is that these /proc files are still not open to everyone - a
user can't read the /proc/<pid>/exe and /proc/<pid>/maps files for
another user's processes unless he's got CAP_SYS_PTRACE priviledges.

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
