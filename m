Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756403Ab0HMXsx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 19:48:53 -0400
Received: from smtp-out.google.com ([74.125.121.35]:59190 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754361Ab0HMXsw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 19:48:52 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=djAt7+APHxhaZ3tN/PzQXzAuz0FZKB/9JHofcqIsaP/iuX7xEEX9NcWGH2Zx8SllE
	0pwI9fgLP3dZ00yZ0bL4w==
MIME-Version: 1.0
In-Reply-To: <AANLkTi=o6g2cxcL_F-ZTZZkMUFT39jLtyRdTigZRbA5o@mail.gmail.com>
References: <1274733081-4623-1-git-send-email-walken@google.com>
	<1274733081-4623-7-git-send-email-walken@google.com>
	<AANLkTikFEy26V4epRGCJiDkQNQ5BH0fPP0C=4phUB=o3@mail.gmail.com>
	<AANLkTimDGbrja5EgGQ+sQxHBRNMnmt7=rjtOfwAKEKFe@mail.gmail.com>
	<AANLkTim3thKSwTHSQ7UXir+1cT9cfFaEjTFGGMdz0_Bt@mail.gmail.com>
	<AANLkTikz2=pa5csA+pqDfKc_zYihyn+C9pUb_YNS9g0L@mail.gmail.com>
	<AANLkTiny_GOfvX-t=SoXZVi8uO3SHC_h2YgbPtCcLXcu@mail.gmail.com>
	<AANLkTin6cHofTWkAysi_hojxaYUJtXg44_F0AyffMy5k@mail.gmail.com>
	<AANLkTi=hW0ceGxAPko4qG6uRz6tSEQEdzxRdeKWMueiz@mail.gmail.com>
	<AANLkTi=c9DsAZArMpbz-7wUmR3nPQyAsOyOYxmeKh=2Q@mail.gmail.com>
	<AANLkTi=o6g2cxcL_F-ZTZZkMUFT39jLtyRdTigZRbA5o@mail.gmail.com>
Date: Fri, 13 Aug 2010 16:48:46 -0700
Message-ID: <AANLkTikXwPRoL0VzcqX0gATw=k0AkJaG1Xk9Df0vht7D@mail.gmail.com>
Subject: Re: [PATCH 06/11] rwsem: wake queued readers when writer blocks on
 active read lock
From: Michel Lespinasse <walken@google.com>
To: Tony Luck <tony.luck@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
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

On Fri, Aug 13, 2010 at 4:38 PM, Tony Luck <tony.luck@gmail.com> wrote:
> Aha!. I think I found it.
>
> This embarrassing declaration in ia64's asm/atomic.h:
>
> static __inline__ int
> ia64_atomic64_add (__s64 i, atomic64_t *v)
>
> looks to be the key.  Obviously it would be better to return all
> 64 bits of the answer using "long" rather than just 32 bits with "int".

Aha, good catch. Thanks for going to the bottom of this, it would have
taken me forever to figure it out (and I could not test this).

BTW there seems to be the same issue in ia64_atomic64_sub() too
(though I wonder if that ever gets used :)

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
