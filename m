Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758864Ab0DHQ1q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 12:27:46 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:57690 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758818Ab0DHQ1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 12:27:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=JizzXN5YuzicrDKckf0okDtboRPfco0v/i1ISPt2NT5xS7TIpAjeEwflRyMfXfp4vq
         QKl8yPpv8b0mCY5lwHjcg+uVCzHFfFIxdS2nJ5D00YbPH0WzsQ/LJCw8ZS0FhbKwfELH
         OdavOYbYVPKkuqlwVHbZVq+cXO8E+xxV4m8CM=
MIME-Version: 1.0
In-Reply-To: <4BB64CDA.4000405@windriver.com>
References: <1270233145-29335-1-git-send-email-jason.wessel@windriver.com>
	 <1270233145-29335-2-git-send-email-jason.wessel@windriver.com>
	 <1270233145-29335-3-git-send-email-jason.wessel@windriver.com>
	 <1270233145-29335-4-git-send-email-jason.wessel@windriver.com>
	 <1270233145-29335-5-git-send-email-jason.wessel@windriver.com>
	 <alpine.LFD.2.00.1004021205080.3634@i5.linux-foundation.org>
	 <4BB64762.6040806@windriver.com> <4BB649E3.5060606@windriver.com>
	 <alpine.LFD.2.00.1004021246470.3634@i5.linux-foundation.org>
	 <4BB64CDA.4000405@windriver.com>
Date: Thu, 8 Apr 2010 18:27:41 +0200
Message-ID: <p2gb647ffbd1004080927r6079414dof04ef128d8ff3bfd@mail.gmail.com>
Subject: Re: [Kgdb-bugreport] [PATCH 4/5] kgdb: Use atomic operators whichuse 
	barriers
From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       kgdb-bugreport@lists.sourceforge.net, Will Deacon <will.deacon@arm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       linux-arm@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> ---
> From: Jason Wessel <jason.wessel@windriver.com>
> Subject: [PATCH] kgdb: use atomic_inc and atomic_dec instead of atomic_set
>
> Memory barriers should be used for the kgdb cpu synchronization.  The
> atomic_set() does not imply a memory barrier.

Hmm, but as far as I can see [ Documentation/memory-barriers.txt and
some actual implementations of atomic_inc/dec() ] atomic_inc/dec()
does not imply memory barriers either.

Either I'm missing the real point of this change and the very category
of "memory barriers" bears another meaning here or the following piece
looks especially dubious...

[...]
         * Make sure the above info reaches the primary CPU before
         * our cpu_in_kgdb[] flag setting does:
         */
-       smp_wmb();
-       atomic_set(&cpu_in_kgdb[cpu], 1);
+       atomic_inc(&cpu_in_kgdb[cpu]);

so what ensures the "Make sure the above info reaches..." requirement here?

TIA,


-- Dmitry
