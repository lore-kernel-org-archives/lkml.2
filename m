Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932570Ab1C3PTw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 11:19:52 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:56786 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754910Ab1C3PTv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 11:19:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=C4BFMnN8rfyAfyC/WxLETZ9wQNTd6fB5hMoZ1na1Og3jz55a+umImHN1L3SNgvTEnj
         4K6cTx3T/tx/R2FiSEApqFUpsKLAlV+fkyUsuSx0lzaLW2tyTZ5pjlC/AJHzspznJ6Zq
         ZMlwlSwy678A5aXOos+ofPP7lRM/ZUk+kgZMU=
MIME-Version: 1.0
In-Reply-To: <D6CBEE2F420741indou.takao@jp.fujitsu.com>
References: <D6CBEE2F420741indou.takao@jp.fujitsu.com>
Date: Wed, 30 Mar 2011 23:19:50 +0800
Message-ID: <AANLkTi=cne0mSNOV0BC3X-SGeNOPPa5MSUf3L6yLJ1-t@mail.gmail.com>
Subject: Re: [PATCH v2] generic-ipi: Initialize call_single_queue before
 enabling interrupt
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Takao Indoh <indou.takao@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        Milton Miller <miltonm@bga.com>, Jens Axboe <axboe@kernel.dk>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Vivek Goyal <vgoyal@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 30, 2011 at 12:35 AM, Takao Indoh
<indou.takao@jp.fujitsu.com> wrote:
> Hi all,
>
> This patch renames init_call_single_data() to call_function_init() and
> calls it in start_kernel() so that call_single_queue can be initialized
> before enabling interrupt.
>
> There is a problem that kdump(2nd kernel) sometimes hangs up due to
> pending IPI from 1st kernel. Kernel panic occurs because IPI comes
> before call_single_queue is initialized. The details are as follows.
> (1) 2nd kernel boot up
> (2) A pending IPI from 1st kernel comes when irqs are first enabled
>    in start_kernel().
> (3) Kernel tries to handle the interrupt, but call_single_queue is not
>    initialized yet at this point. As a result, in the
>    generic_smp_call_function_single_interrupt(), NULL pointer
>    dereference occurs when list_replace_init() tries to access
>    &q->list.next.
> Therefore this patch changes the name of init_call_single_data() to
> call_function_init() and calls it before local_irq_enable() in
> start_kernel().
>
> v2:
> - Rename init_call_single_data() to call_function_init() and calls it in
>  start_kernel()
> - Change insert position in start_kernel().
> - Adjust for CONFIG_SMP/CONFIG_USE_GENERIC_SMP_HELPERS options
> - Rebased to Linus's latest tree
>

Looks good to my eyes,

Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>

Thanks.
