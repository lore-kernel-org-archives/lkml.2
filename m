Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932473Ab1FAWRV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 18:17:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37584 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932148Ab1FAWQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 18:16:56 -0400
Date: Wed, 1 Jun 2011 15:16:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: linux-cris-kernel@axis.com, LKML <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>
Subject: Re: [Patch] cris: add missing declaration of kgdb_init() and
 breakpoint()
Message-Id: <20110601151618.15759bfb.akpm@linux-foundation.org>
In-Reply-To: <BANLkTimdog_wi+7_Vx7Qzpc0ZYor_RHg2g@mail.gmail.com>
References: <BANLkTimdog_wi+7_Vx7Qzpc0ZYor_RHg2g@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 May 2011 22:42:56 +0800
Am__rico Wang <xiyou.wangcong@gmail.com> wrote:

> --- a/arch/cris/arch-v10/kernel/irq.c
> +++ b/arch/cris/arch-v10/kernel/irq.c
> @@ -20,6 +20,9 @@
>  #define crisv10_mask_irq(irq_nr) (*R_VECT_MASK_CLR = 1 << (irq_nr));
>  #define crisv10_unmask_irq(irq_nr) (*R_VECT_MASK_SET = 1 << (irq_nr));
>  
> +extern void kgdb_init(void);
> +extern void breakpoint(void);

They should be declared in a header file, please. 
arch/cris/arch-v32/kernel/irq.c has a private declaration of
kgdb_init(), too.

