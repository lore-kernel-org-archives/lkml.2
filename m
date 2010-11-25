Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751725Ab0KYGca (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 01:32:30 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37634 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662Ab0KYGc2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 01:32:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=iNTSV0RLV6LiTKfMXAi/cb63nqGEl46rMJlUp6RXrnBO2L3AvbrkrP6yPcWM3UOpkn
         kJ05ShisjG7LgNkGh0wMMzkox6dHE19HtcZj30Y0izCbk25AfLbpUAOAtQ474D9L8I96
         kZ+emBqaCeFD0pA9cn0YsfRD8Mgu8XooyeHzw=
Date: Thu, 25 Nov 2010 07:32:23 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        x86@kernel.org, sandmann@redhat.com
Subject: Re: [PATCH] x86, dumpstack: Fix unused variable warning.
Message-ID: <20101125073223.1d53b8c6@nowhere>
In-Reply-To: <AANLkTik9U_Z0WSZ7YjrykER_pBUfPDdgUUmtYx=R74nL@mail.gmail.com>
References: <AANLkTinV6r_1yHdxbi+o=_w=pHXrdu4fYXONMjYg0yiG@mail.gmail.com>
	<AANLkTik0iWzP4KwVwpY4bDJuyZnQTFnW0Q5pj3TM-s_O@mail.gmail.com>
	<AANLkTik9U_Z0WSZ7YjrykER_pBUfPDdgUUmtYx=R74nL@mail.gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le Thu, 25 Nov 2010 11:35:16 +0600,
Rakib Mullick <rakib.mullick@gmail.com> a écrit :

> On Wed, Nov 24, 2010 at 7:19 PM, Frederic Weisbecker
> <fweisbec@gmail.com> wrote:
> > 2010/11/24 Rakib Mullick <rakib.mullick@gmail.com>:
> >
> > Looks like you can even remove that block. bp is not used any more
> > in this function.
> > get_bp() was only loading bp but did not make any use of it.
> 
> Yes, right. Here is the updated one.
> 
>  In dump_stack function, bp isn't used anymore, which is introduced by
> commit 9c0729dc8062bed96189bd14ac6d4920f3958743. This patch removes bp
> completely.
> 
> 
> Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
> ---
> 
> diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
> index 8474c99..d6fb146 100644
> --- a/arch/x86/kernel/dumpstack.c
> +++ b/arch/x86/kernel/dumpstack.c
> @@ -197,14 +197,8 @@ void show_stack(struct task_struct *task,
> unsigned long *sp)
>   */
>  void dump_stack(void)
>  {
> -	unsigned long bp = 0;
>  	unsigned long stack;
> 
> -#ifdef CONFIG_FRAME_POINTER
> -	if (!bp)
> -		get_bp(bp);
> -#endif
> -
>  	printk("Pid: %d, comm: %.20s %s %s %.*s\n",
>  		current->pid, current->comm, print_tainted(),
>  		init_utsname()->release,
> 

Queued, thanks!
