Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144Ab0IHNLO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 09:11:14 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:42838 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752741Ab0IHNLM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 09:11:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=MCLTav8qRVmTMOuoTPmTNVqktC64IGeSfrlh3c+Z+4SjWdqeXU+Zp/e4fiPG+2/EN+
         7qvWf4bRyt1M5fArYlaJ3l78PAkRi4zz1z1yrIAAj1hfAZKQkNRkYslI+7FTv8h4/1Ma
         udIEwiCOUfDiQkPlTY8D+ken0YGzgOHHjFFy8=
MIME-Version: 1.0
In-Reply-To: <201009081508.30490.fabio@metanix.org>
References: <201009081508.30490.fabio@metanix.org>
From: "chxanders@gmail.com" <chxanders@gmail.com>
Date: Wed, 8 Sep 2010 20:10:49 +0700
Message-ID: <AANLkTik7sSbiPBM8Sdo2R3=NwLN4oJr3Q7MSNp+Y4jo3@mail.gmail.com>
Subject: Re: linux/kernel/sched.c: context_switch().
To: fabio de francesco <fabio@metanix.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Long day? Do you mean likely(!mm) actually means unlikely(0)?


On 8 September 2010 20:08, fabio de francesco <fabio@metanix.org> wrote:
> There must be something I am missing in sched.c at context_switch() function
> definition.
>
> There I can read the following code:
>
> static inline void
> context_switch(struct rq *rq, struct task_struct *prev,
>               struct task_struct *next)
> {
>        ...
>        struct mm_struct *mm;
>        mm = next->mm;
>        if (likely(!mm)) {
>                next->active_mm = oldmm;
>                atomic_inc(&oldmm->mm_count);
>                enter_lazy_tlb(oldmm, next);
>        } else
>                switch_mm(oldmm, mm, next);
>        ...
> }
>
> May someone please explain why the mm pointer is likely supposed to be NULL?
>
> Thanks in advance.
>
> fabio
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
