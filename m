Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751434Ab0EPXgW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 19:36:22 -0400
Received: from www.tglx.de ([62.245.132.106]:57648 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751142Ab0EPXgU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 19:36:20 -0400
Date: Mon, 17 May 2010 01:36:06 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Donald Allen <donaldcallen@gmail.com>
cc: john stultz <johnstul@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: PROBLEM: tickless scheduling
In-Reply-To: <AANLkTinBPDY_WVGaq2LUuOzH0niRpgJ4LEpXWkwBxVqh@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1005170123090.3368@localhost.localdomain>
References: <AANLkTin6D2GP0yJJbPYGH1AcAM9-g219rAxSyW_ZlrXV@mail.gmail.com>  <AANLkTikjgoBQWqvNxncMUFqWOEXtq4ePvGkvF-m0sGUE@mail.gmail.com>  <AANLkTimnlZYonxKzfGHZTV8vwaDptOPHEPBjNhwnV55Y@mail.gmail.com>  <1273540344.3843.101.camel@localhost.localdomain> 
 <AANLkTilg2cn3lAIOruz6oZE7V-9uAFDORlbvTX3qxmwF@mail.gmail.com>  <AANLkTilb_CGBolyv5Ps9VuhNxFZKtjck4om4G21ICaif@mail.gmail.com>  <1273697523.2856.3.camel@localhost.localdomain> <AANLkTinBPDY_WVGaq2LUuOzH0niRpgJ4LEpXWkwBxVqh@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Donald,

On Sat, 15 May 2010, Donald Allen wrote:
> Attached. This is from the 2.6.30 kernel on the Arch Linux install cd.
> 
> Here's another bit of data. As I've said previously, the problems I'm
> reporting were observed on a Toshiba NB310-305 netbook with a
> single-core Atom 450 processor. I just built myself a mini-ITX system
> using the Intel D510MO motherboard, which provides a dual-core D510
> Atom processor. The other hardware on the board is similar to the
> Toshiba. I installed the same Slackware snapshot I used on the
> Toshiba, and did the home directory transfer without any problem at
> all with the default tickless kernel. The hardware isn't identical,
> and while I don't know the internals of the Linux kernel at all, my
> gut, backed up by many years of OS development work in scheduling and
> memory management, is telling me that the key difference is dual- vs.
> single-core. Just a guess.

I fear you are wrong. 

The key difference is almost certainly that the BIOS of your netbook
tries to be overly clever vs. power management and is not aware of the
fact that the Linux kernel uses timer hardware in a very different way
than the other OS which comes preinstalled on that machine. 

The overly clever BIOS power management which works nicely with the
vendor provided "drivers" for the other OS is just interfering with
the kernels way of dealing with the problem.

Can you please boot with "hpet=disable" on the kernel command line ?

Thanks,

	tglx
