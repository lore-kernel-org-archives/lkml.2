Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758030Ab2BOI4U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 03:56:20 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:51594 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753437Ab2BOI4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 03:56:18 -0500
MIME-Version: 1.0
In-Reply-To: <1329285786.2555.38.camel@edumazet-laptop>
References: <1329280586-6878-1-git-send-email-tom.leiming@gmail.com>
	<1329281947.2555.26.camel@edumazet-laptop>
	<CACVXFVN7ye6QkJLWSTecy24FeHY6SRB6cDLAXyrPF7kBKgvq5g@mail.gmail.com>
	<1329285786.2555.38.camel@edumazet-laptop>
Date: Wed, 15 Feb 2012 16:56:17 +0800
Message-ID: <CACVXFVOyJa8K4rqNatYdQqiPd9nS+6fU0e2A6mU4urejfS9wuQ@mail.gmail.com>
Subject: Re: [PATCH v1] percpu: use raw_local_irq_* in _this_cpu op
From: Ming Lei <tom.leiming@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Christoph Lameter <cl@linux.com>, Tejun Heo <tj@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q1F8uPqf015030

On Wed, Feb 15, 2012 at 2:03 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Le mercredi 15 février 2012 à 13:08 +0800, Ming Lei a écrit :
>
>> Just several warnings, no errors. Also the 5 warnings are introduced
>> by previous commit, sounds nothing to do with motivation of this patch.
>> You may prepare a standalone patch to fix all the code style in this file, :-)
>>
>
> Oh well, I dont use checkpatch but spoke about trailing \
>
> Cant you see them on your screen ?
>
> We had :
>
> #define _this_cpu_generic_to_op(pcp, val, op)                           \
> do {                                                                    \
>        unsigned long flags;                                            \
>        local_irq_save(flags);                                          \
>        *__this_cpu_ptr(&(pcp)) op val;                                 \
>        local_irq_restore(flags);                                       \
> } while (0)
>
>
> You want :
>
> #define _this_cpu_generic_to_op(pcp, val, op)                           \
> do {                                                                    \
>        unsigned long flags;                                            \
>        raw_local_irq_save(flags);                                              \
>        *__this_cpu_ptr(&(pcp)) op val;                                 \
>        raw_local_irq_restore(flags);                                   \
> } while (0)
>
>
> I suggest :
>
> #define _this_cpu_generic_to_op(pcp, val, op)                           \
> do {                                                                    \
>        unsigned long flags;                                            \
>        raw_local_irq_save(flags);                                      \
>        *__this_cpu_ptr(&(pcp)) op val;                                 \
>        raw_local_irq_restore(flags);                                   \
> } while (0)
>
>
> Is it clear now ?

Thanks for your pointing it out.
Yes, I have updated the patch and sent it out.


thanks,
-- 
Ming Lei
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
