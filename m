Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933515Ab1ERSrY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 14:47:24 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40010 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933460Ab1ERSrX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 14:47:23 -0400
Date: Wed, 18 May 2011 20:47:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: "Yu, Fenghua" <fenghua.yu@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        H Peter Anvin <hpa@zytor.com>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Avi Kivity <avi@redhat.com>, Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 9/9] x86/lib/memset_64.S: Optimize memset by enhanced REP
 MOVSB/STOSB
Message-ID: <20110518184703.GB6225@elte.hu>
References: <1305671358-14478-1-git-send-email-fenghua.yu@intel.com>
 <1305671358-14478-10-git-send-email-fenghua.yu@intel.com>
 <08d8c27c0495452cad52b62b362dd1d1.squirrel@www.firstfloor.org>
 <493994B35A117E4F832F97C4719C4C04011505C39D@orsmsx505.amr.corp.intel.com>
 <9317a84b59d0a78a4b8e304ac2da490a.squirrel@www.firstfloor.org>
 <493994B35A117E4F832F97C4719C4C04011505C7DC@orsmsx505.amr.corp.intel.com>
 <20110518183913.GA12317@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110518183913.GA12317@one.firstfloor.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andi Kleen <andi@firstfloor.org> wrote:

> > I use gcc 4.3.2 installed by FC10 to build kernel with defconfig. Only memcpy is built with gcc builtin and inline memcpy. All of others (i.e. memset, clear_page, memmove, and copy_user) call the kernel lib.
> > 
> > It's easy to check this by disassembling kernel binary.
> 
> gcc has a complex set of heuristics. For example if it cannot decide the 
> length or the alignment it calls the kernel code. Otherwise it inlines.
> 
> So just looking at a few examples won't give you the whole picture.

Well, your generic, vague claims about what GCC could possibly do does not 
count much when weighted against the hard data he provided.

He used a defconfig and reported his results and has proven that your claim is 
wrong in fairly common circumstances.

If you think the result is or should be different provide a config and test it 
yourself, contradicting/countering the data he provided.

Thanks,

	Ingo
