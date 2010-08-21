Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751423Ab0HUPtk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 11:49:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48224 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750926Ab0HUPtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 11:49:39 -0400
MIME-Version: 1.0
In-Reply-To: <1282391770.29609.1223.camel@localhost.localdomain>
References: <AANLkTimuP9cFvd4pfqy6=vixSMdagrSEv1-VLNAEuWgr@mail.gmail.com> <1282391770.29609.1223.camel@localhost.localdomain>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 21 Aug 2010 08:48:29 -0700
Message-ID: <AANLkTimYnfewBCDNYXZHxbcX=TRE__Cu07_FFK_kAK2h@mail.gmail.com>
Subject: Re: [RFC] mlock/stack guard interaction fixup
To: Ian Campbell <ijc@hellion.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Greg KH <gregkh@suse.de>, Peter Zijlstra <peterz@infradead.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 21, 2010 at 4:56 AM, Ian Campbell <ijc@hellion.org.uk> wrote:
>
> I don't know that they are particularly good tests for this change but I
> also ran allmodconfig kernel build and ltp on 2.6.35.3+fixes without
> issue. Are there any good mlock heavy workloads?

mlock itself isn't very interesting, I think more interesting is
testing that the doubly linked list handles all the cases correctly.
Something that splits mappings, unmaps partial ones etc etc. Running
something like Electric Fence is probably a good idea.

The happy news is that we really didn't have lots of assignments to
vma->vm_next - they were all pretty cleanly separated into just a
couple of cases. So I'm pretty confident in the patches. But...

> Out of interest, why is there no guard page for the VM_GROWSUP stack
> case? Is it just that the memory layout on PA-RISC makes the stack grows
> into the heap scenario impossible?

No, it's just that I can't find it in myself to care about PA-RISC, so
I never wrote the code. I don't think anything else has a grows-up
stack. And even if I were to write the code, I couldn't even test it.

It should be reasonably easy to do the VM_GROWSUP case too, but
somebody with a PA-RISC would need to do it.

                         Linus
