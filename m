Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814Ab0K3JIS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 04:08:18 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41194 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753835Ab0K3JIO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 04:08:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=rT9o2UyftCJElTtZLXiAQehv+fFsRjPsnJnRlRRycxwcsm5MTZt26PgF139IX32FKy
         5zo7WpafLqy+xaYff5HpPT1CuNzYs51iQi9qtZV3KX+Nv+CPCwP06RC7Xiz9FLf6wxKj
         Bc+5CDH33LErI0lalaX0QUImTnvtA/AYyv6Jk=
MIME-Version: 1.0
In-Reply-To: <4CF4B778.90604@jp.fujitsu.com>
References: <4CF4B778.90604@jp.fujitsu.com>
Date: Tue, 30 Nov 2010 17:08:13 +0800
Message-ID: <AANLkTinSYu9JhqY8NAH+sNAKuO9cUZwJTxK46_8nx3Qh@mail.gmail.com>
Subject: Re: [PATCH] genirq: fix incorrect proc spurious output
From: Yong Zhang <yong.zhang0@gmail.com>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/11/30 Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>:
> Fix the problem that all the /proc/irq/XX/spurious files shows the IRQ
> 0 information.
>
> Current irq_spurious_proc_open() passes on NULL as the 3rd argument,
> which is used as an IRQ number in irq_spurious_proc_show(), to the
> single_open(). Because of this, all the /proc/irq/XX/spurious file
> shows IRQ 0 information regardless of the IRQ number.
>
> To fix the problem, irq_spurious_proc_open() must pass on the
> appropreate data (IRQ number) to single_open().
>
> Signed-off-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>

Looks good.

Reviewed-by: Yong Zhang <yong.zhang0@gmail.com>

BTW, it's introduced by a1afb6371bb5341057056194d1168753f6d77242
So should we Cc'ing stable?

>
> ---
>  kernel/irq/proc.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> Index: linux-next-20101125/kernel/irq/proc.c
> ===================================================================
> --- linux-next-20101125.orig/kernel/irq/proc.c
> +++ linux-next-20101125/kernel/irq/proc.c
> @@ -214,7 +214,7 @@ static int irq_spurious_proc_show(struct
>
>  static int irq_spurious_proc_open(struct inode *inode, struct file *file)
>  {
> -       return single_open(file, irq_spurious_proc_show, NULL);
> +       return single_open(file, irq_spurious_proc_show, PDE(inode)->data);
>  }
>
>  static const struct file_operations irq_spurious_proc_fops = {
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
