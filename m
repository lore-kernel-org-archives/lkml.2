Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753054Ab1DRA02 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 20:26:28 -0400
Received: from smtp-out.google.com ([216.239.44.51]:32496 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411Ab1DRA0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 20:26:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=YXoipWVlV1KnPgYBdiDW8k9RRIBZ3YdkL7+f6cth6rvIjhO04Kc58pT3VnG/k6zUDG
         97xDHL/OK6bP9kCaRGxA==
Date: Sun, 17 Apr 2011 17:26:19 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: mm: convert vma->vm_flags to 64bit
In-Reply-To: <20110412151116.B50D.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.LSU.2.00.1104171649350.21405@sister.anvils>
References: <20110412151116.B50D.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Apr 2011, KOSAKI Motohiro wrote:
> 
> Benjamin, Hugh, I hope to add your S-O-B to this one because you are original author. 
> Can I do?

Well, now you've fixed the mm/fremap.c omission, you're welcome to my
Acked-by: Hugh Dickins <hughd@google.com>

I happen not to shared Ben's aversion to unsigned long long, I just
don't really care one way or another on that; but I do get irritated by
obfuscatory types which we then have to cast or unfold all over the place,
I don't know if vm_flags_t would have been in that category or not.

You've made a few different choices than I did, okay: the only place
where it might be worth disagreeing with you, is on mm->def_flags:
I would rather make that an unsigned int than an unsigned long long,
to save 4 bytes on 64-bit (if it were moved) rather than waste 4 bytes
on 32-bit - in the unlikely event that someone adds a high VM_flag to
def_flags, I'd rather hope they would test its effect.  However,
it's every mm not every vma, so maybe not worth worrying about.

I am surprised that
#define VM_EXEC		0x00000004ULL
does not cause trouble for arch/arm/kernel/asm-offsets.c,
but you tried cross-building it which I never did.

Does your later addition of __nocast on vm_flags not make trouble
for the unsigned long casts in arch/arm/include/asm/cacheflush.h?
(And if it does not, then just what does __nocast do?)

Thanks for seeing this through,
Hugh
