Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753001Ab1C1Hft (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 03:35:49 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53489 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605Ab1C1Hfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 03:35:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ZDHVplTzjcJkbWT83oByGg1fA2Ig/6lscPdOFu/Noqd9nsZ1EnDuZZp7WtBnleIbde
         1QnKl32l9JZOdJZChiAJpqlGqqn1gXS0TpzFFDGQmPQrcmG9YlN3wsNutgtKg9p3pA/G
         Z6zwPKev2Que1lfmmbPGc6kweEpSof55xWZag=
Date: Mon, 28 Mar 2011 09:35:42 +0200
From: Tejun Heo <tj@kernel.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Christoph Lameter <cl@linux.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, akpm@linux-foundation.org,
        npiggin@kernel.dk, rientjes@google.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] slub: Disable the lockless allocator
Message-ID: <20110328073542.GA16530@htj.dyndns.org>
References: <20110326112725.GA28612@elte.hu>
 <20110326114736.GA8251@elte.hu>
 <1301161507.2979.105.camel@edumazet-laptop>
 <alpine.DEB.2.00.1103261406420.24195@router.home>
 <alpine.DEB.2.00.1103261428200.25375@router.home>
 <alpine.DEB.2.00.1103261440160.25375@router.home>
 <AANLkTinTzKQkRcE2JvP_BpR0YMj82gppAmNo7RqgftCG@mail.gmail.com>
 <alpine.DEB.2.00.1103262028170.1004@router.home>
 <alpine.DEB.2.00.1103262054410.1373@router.home>
 <4D9026C8.6060905@cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D9026C8.6060905@cs.helsinki.fi>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Heh, a lot of activities over the weekend.

On Mon, Mar 28, 2011 at 09:12:24AM +0300, Pekka Enberg wrote:
> >@@ -37,13 +43,13 @@
> >  	pushf
> >  	cli
> >
> >-	cmpq %gs:(%rsi), %rax
> >+	cmpq SEG_PREFIX(%rsi), %rax
> >  	jne not_same
> >-	cmpq %gs:8(%rsi), %rdx
> >+	cmpq SEG_PREFIX 8(%rsi), %rdx
> >  	jne not_same
> >
> >-	movq %rbx, %gs:(%rsi)
> >-	movq %rcx, %gs:8(%rsi)
> >+	movq %rbx, SEG_PREFIX(%rsi)
> >+	movq %rcx, SEG_PREFIX 8(%rsi)
> >
> >  	popf
> >  	mov $1, %al
> 
> Tejun, does this look good to you as well? I think it should go
> through the percpu tree. It's needed to fix a boot crash with
> lockless SLUB fastpaths enabled.

Linus already applied it so it's all done now.  The patch looks okay
to me although I would like to have the SEG_PREFIX defined in
asm/percpu.h instead.  Well, we can do that later.

Thanks.

-- 
tejun
