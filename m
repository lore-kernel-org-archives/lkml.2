Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755739Ab1DMGqZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 02:46:25 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37583 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754009Ab1DMGqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 02:46:24 -0400
Date: Wed, 13 Apr 2011 08:46:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joro@8bytes.org>, Yinghai Lu <yinghai@kernel.org>
Cc: Alex Deucher <alexdeucher@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>
Subject: Re: Linux 2.6.39-rc3
Message-ID: <20110413064609.GA18777@elte.hu>
References: <BANLkTimNvX=U6qy2FgvDpWE6HY7cehWvyQ@mail.gmail.com>
 <20110412090207.GE19819@8bytes.org>
 <BANLkTimSgAmT5a1s0ciBr2jsE-Nu7n4buQ@mail.gmail.com>
 <20110412184433.GF19819@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110412184433.GF19819@8bytes.org>
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


* Joerg Roedel <joro@8bytes.org> wrote:

> > > The problem does not happen with 2.6.38. I try to bisect this further 
> > > down to a commit. Alex, please let me know if you need any further 
> > > information.
> > 
> > If you can bisect it, that would be great.  Thanks,
> 
> Bisecting actually gave a very weird result. It points to
> 
> 	d2137d5af4259f50c19addb8246a186c9ffac325
> 
> which is a merge-commit in the x86 tree. Even more weird is that this
> notebook is the only machine with these symptoms, all my other boxes are
> fine.
>
> During the bisect I tested commits from Yinghai which were good. It seems 
> like the problem appeared with the merge.

There's a similar looking bug being debugged here:

  https://bugzilla.kernel.org/show_bug.cgi?id=33012

Could you please send the before/after bootlog (in particular all memory init 
messages included) and your .config?

 before:  f005fe12b90c: x86-64: Move out cleanup higmap [_brk_end, _end) out of init_memory_mapping()
  after:  d2137d5af425: Merge branch 'linus' into x86/bootmem

I've Cc:-ed more people who might have an idea about it.

Thanks,

	Ingo
