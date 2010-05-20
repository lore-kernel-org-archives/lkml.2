Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755397Ab0ETJzW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 05:55:22 -0400
Received: from www.tglx.de ([62.245.132.106]:58139 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755344Ab0ETJzU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 05:55:20 -0400
Date: Thu, 20 May 2010 11:47:32 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Sujit K M <sjt.kar@gmail.com>
cc: "Nikita V. Youshchenko" <yoush@cs.msu.su>, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: PREEMPT_RT (2.6.33-rt17) disabled printk-to-console after
 console_init
In-Reply-To: <AANLkTil18TnOR9D-dSFsSFA74Q4UFnldrGLhG1H4jwhf@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1005201142360.3368@localhost.localdomain>
References: <AANLkTimxLHngWamPvWt-htGoZ7Nub72rvJAnmGtw4Eqw@mail.gmail.com>  <AANLkTinClrTDoXH4NPP2-SgSYH24ZTnqsop88aocdg4R@mail.gmail.com>  <alpine.LFD.2.00.1005182143100.3368@localhost.localdomain>  <201005201233.56877@zigzag.lvk.cs.msu.su> 
 <AANLkTilEbFndi-rPczi6OBxeU8p87gOz4yfveEsyHqcE@mail.gmail.com> <AANLkTil18TnOR9D-dSFsSFA74Q4UFnldrGLhG1H4jwhf@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please stop top posting !

On Thu, 20 May 2010, Sujit K M wrote:

> >>> Well, obviously it's unsafe if you remove safety checks. And if you
> >>> care to look at the changelog of kernel/printk.c you'll find out why.
> >>
> >> Hmm... did a quick look and could not find anything related there.
> >> Could you please give a pointer?

Gah, yes. The changelog of the commit is not really helpful. Let me
explain:

The console drivers might take locks, which are converted to "sleeping
locks" in preempt-rt. As a result we cannot call into those drivers
from atomic contexts. And that's what the checks in the printk code
prevent.

Hope that helps.

Thanks,

	tglx



