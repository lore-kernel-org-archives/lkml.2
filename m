Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755412Ab1ATLLz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 06:11:55 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48470 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752872Ab1ATLLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 06:11:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=i8qwhb0lLWtVseVMBzr2TzuO7SA2+3jI8T0DdqTq5fAOw6LbT9faHkAJVy5CZ8c8wE
         mwyp7KRX1/1JovHNKQ7fgJwFFhdzgCYQE3IJMpBRbksJqaxohUiW4ktHdi0CVAD1WnJ+
         u0hdiocKmQGrDPrDWZLzsC6NeP+Il6DaCdV7U=
Date: Thu, 20 Jan 2011 12:11:49 +0100
From: Tejun Heo <tj@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 1/2] lockdep: move early boot local IRQ enable/disable
 status to init/main.c
Message-ID: <20110120111149.GD6036@htj.dyndns.org>
References: <AANLkTimajU0x1v6y3rH2+jr-bZ=tNLs1S_agXdGGAa3S@mail.gmail.com>
 <20110119120200.GA1057@elte.hu>
 <20110120110635.GB6036@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110120110635.GB6036@htj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, guys.

These two patches remove both warnings.  The first warning was
completely spurious.  The second lockdep one was triggered by
on_each_cpu() enabling local IRQ too early.

I don't think percpu allocator itself malfunctioned.  There was no
allocation failure.  It whines when percpu allocation fails but didn't
in the log.  Other than calling vfree() early triggering the above
condition, it worked okay.

So, it's either the early enabling of local IRQ by on_each_cpu()
breaking something in the IRQ subsystem or something different.  Ingo,
can you please see whether these two patches cure the panic too?

Thanks.

-- 
tejun
