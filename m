Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751812Ab0HLFJk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 01:09:40 -0400
Received: from smtp-out.google.com ([74.125.121.35]:40071 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085Ab0HLFJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 01:09:39 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=pOcPVKqeT9EUHL9CNvEGx288M4qMoCohR7i6zDasfhV4HOdVy+4Eg/DxMV/lFMSi2
	4begImmhw3flc5MHZ7rEQ==
MIME-Version: 1.0
In-Reply-To: <AANLkTimDGbrja5EgGQ+sQxHBRNMnmt7=rjtOfwAKEKFe@mail.gmail.com>
References: <1274733081-4623-1-git-send-email-walken@google.com>
	<1274733081-4623-7-git-send-email-walken@google.com>
	<AANLkTikFEy26V4epRGCJiDkQNQ5BH0fPP0C=4phUB=o3@mail.gmail.com>
	<AANLkTimDGbrja5EgGQ+sQxHBRNMnmt7=rjtOfwAKEKFe@mail.gmail.com>
Date: Wed, 11 Aug 2010 22:09:34 -0700
Message-ID: <AANLkTim3thKSwTHSQ7UXir+1cT9cfFaEjTFGGMdz0_Bt@mail.gmail.com>
Subject: Re: [PATCH 06/11] rwsem: wake queued readers when writer blocks on 
	active read lock
From: Michel Lespinasse <walken@google.com>
To: Tony Luck <tony.luck@intel.com>
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

On Wed, Aug 11, 2010 at 10:02 PM, Michel Lespinasse <walken@google.com> wrote:
> In arch/ia64/include/asm/rwsem.h I see RWSEM_WAITING_BIAS defined as
> -__IA64_UL_CONST(0x0000000100000000)
>
> This makes it a large, positive unsigned value. This is probably
> throwing off the rwsem_atomic_update(0, sem) < RWSEM_WAITING_BIAS
> comparison in my patch (supposed to be long versus long, but actually
> is long versus unsigned long on ia64).

FYI, I just verified that RWSEM_WAITING_BIAS is defined as signed on
all architectures except for ia64. So, this would be consistent with
the issue being observed only on ia64.

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
