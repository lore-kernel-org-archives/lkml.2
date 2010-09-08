Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758776Ab0IHNXj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 09:23:39 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39998 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755591Ab0IHNXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 09:23:38 -0400
From: fabio de francesco <fabio@metanix.org>
Organization: metanix.org
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux/kernel/sched.c: context_switch().
Date: Wed, 8 Sep 2010 15:23:40 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-tuxonice-r1-100826; KDE/4.4.5; x86_64; ; )
References: <201009081508.30490.fabio@metanix.org> <AANLkTik7sSbiPBM8Sdo2R3=NwLN4oJr3Q7MSNp+Y4jo3@mail.gmail.com>
In-Reply-To: <AANLkTik7sSbiPBM8Sdo2R3=NwLN4oJr3Q7MSNp+Y4jo3@mail.gmail.com>
MIME-Version: 1.0
Message-Id: <201009081523.41718.fabio@metanix.org>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 September 2010 15:10:49 you wrote:
> Long day? Do you mean likely(!mm) actually means unlikely(0)?

No, no. I am sorry for my poor English. I mean:"likely(!mm)" is like 
"likely(0)".
 
> On 8 September 2010 20:08, fabio de francesco <fabio@metanix.org> wrote:
> > There must be something I am missing in sched.c at context_switch()
> > function definition.
> > 
> > There I can read the following code:
> > 
> > static inline void
> > context_switch(struct rq *rq, struct task_struct *prev,
> >               struct task_struct *next)
> > {
> >        ...
> >        struct mm_struct *mm;
> >        mm = next->mm;
> >        if (likely(!mm)) {
> >                next->active_mm = oldmm;
> >                atomic_inc(&oldmm->mm_count);
> >                enter_lazy_tlb(oldmm, next);
> >        } else
> >                switch_mm(oldmm, mm, next);
> >        ...
> > }
> > 
> > May someone please explain why the mm pointer is likely supposed to be
> > NULL?
> > 
> > Thanks in advance.
> > 
> > fabio
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel"
> > in the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
