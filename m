Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758061Ab0ERTr3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 15:47:29 -0400
Received: from www.tglx.de ([62.245.132.106]:46256 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754115Ab0ERTr2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 15:47:28 -0400
Date: Tue, 18 May 2010 21:47:23 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Xianghua Xiao <xiaoxianghua@gmail.com>
cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: Re: PREEMPT_RT (2.6.33-rt17) disabled printk-to-console after
 console_init
In-Reply-To: <AANLkTinClrTDoXH4NPP2-SgSYH24ZTnqsop88aocdg4R@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1005182143100.3368@localhost.localdomain>
References: <AANLkTimxLHngWamPvWt-htGoZ7Nub72rvJAnmGtw4Eqw@mail.gmail.com> <AANLkTinClrTDoXH4NPP2-SgSYH24ZTnqsop88aocdg4R@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 May 2010, Xianghua Xiao wrote:
> I could not get dmesg output to console/serial and
> klogd(/var/log/messages) anymore with 2.6.33-rt17 _after_ the kernel
> boot is done(on non-RT kernel it works fine). I made below changes it
> starts to work again, however I'm unsure how safe the change is.
> Please advise.

Well, obviously it's unsafe if you remove safety checks. And if you
care to look at the changelog of kernel/printk.c you'll find out why.

Short story: It's introducing nasty latencies.

Use "earlyprintk=serial,ttyS0,115200,keep" if you care, but do not
complain about the resulting latencies.

Thanks,

	tglx
