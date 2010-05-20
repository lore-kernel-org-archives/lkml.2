Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271Ab0ETXaO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 19:30:14 -0400
Received: from smtp-out.google.com ([74.125.121.35]:57740 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755162Ab0ETXaM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 19:30:12 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=AVEkR7Lz/p2XPIDNY1rN5JHY9z70nlhd1sdAS7V7iZHCjJBTobpquNctzBD8lTop6
	cGiCc+FNMsE/Xkovy74Lg==
MIME-Version: 1.0
In-Reply-To: <4405.1274276055@redhat.com>
References: <1274135154-24082-1-git-send-email-walken@google.com>
	 <1274135154-24082-9-git-send-email-walken@google.com>
	 <4405.1274276055@redhat.com>
Date: Thu, 20 May 2010 16:30:07 -0700
Message-ID: <AANLkTikMBdX5HMrqVs9U2IJLldQ7nQXJ8ivKg4POdFEn@mail.gmail.com>
Subject: Re: [PATCH 08/10] rwsem: down_read_critical infrastructure support
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

On Wed, May 19, 2010 at 6:34 AM, David Howells <dhowells@redhat.com> wrote:
> Can I suggest you change this to:
>
>        enum rwsem_waiter_type {
>                RWSEM_WAITING_FOR_WRITE,
>                RWSEM_WAITING_FOR_READ,
>                RWSEM_WAITING_FOR_UNFAIR_READ
>        };
>
> and then change:
>
>>       unsigned int flags;
>
> to:
>
>        enum rwsem_waiter_type type;
>
> and use this throughout.  It simplifies some of the code too.  See attached
> patch.

Makes perfect sense assuming we don't plan to add more flags in the future.
I'll use this in V4 series.

> -       if (flags & RWSEM_UNFAIR)
> +       if (type & RWSEM_WAITING_FOR_UNFAIR_READ)

if (type == RWSEM_WAITING_FOR_UNFAIR_READ)

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
