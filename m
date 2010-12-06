Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513Ab0LFW3m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 17:29:42 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:59328 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753174Ab0LFW3l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 17:29:41 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mikael Pettersson <mikpe@it.uu.se>
Subject: Re: [Bug #23902] [BUG] 2.6.37-rc3 massive interactivity regression on ARM
Date: Mon, 6 Dec 2010 23:28:59 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc4+; KDE/4.4.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Venkatesh Pallipadi <venki@google.com>
References: <1OMp3vU_qjP.A.JXG.uxC-MB@chimera> <19706.13300.115878.641839@pilspetsen.it.uu.se> <19706.39875.954626.75344@pilspetsen.it.uu.se>
In-Reply-To: <19706.39875.954626.75344@pilspetsen.it.uu.se>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012062328.59938.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, December 04, 2010, Mikael Pettersson wrote:
> Mikael Pettersson writes:
>  > Rafael J. Wysocki wrote:
>  > > This message has been generated automatically as a part of a summary report
>  > > of recent regressions.
>  > > 
>  > > The following bug entry is on the current list of known regressions
>  > > from 2.6.36.  Please verify if it still should be listed and let the tracking team
>  > > know (either way).
>  > > 
>  > > 
>  > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=23902
>  > > Subject		: [BUG] 2.6.37-rc3 massive interactivity regression on ARM
>  > > Submitter	: Mikael Pettersson <mikpe@it.uu.se>
>  > > Date		: 2010-11-27 15:16 (6 days old)
>  > > Message-ID	: <19697.8378.717761.236202@pilspetsen.it.uu.se>
>  > > References	: http://marc.info/?l=linux-kernel&m=129087098911837&w=2
>  > 
>  > The bug is still present in 2.6.37-rc4.  I'm currently trying to bisect it.
> 
> git bisect identified
> 
> [305e6835e05513406fa12820e40e4a8ecb63743c] sched: Do not account irq time to current task
> 
> as the cause of this regression.  Reverting it from 2.6.37-rc4 (requires some
> hackery due to subsequent changes in the same area) restores sane behaviour.
> 
> (Author of original patch cc:d.)
> 
> The original patch submission talks about irq-heavy scenarios.  My case is the
> exact opposite: UP, !PREEMPT, NO_HZ, very low irq rate, essentially 100% CPU
> bound in userspace but expected to schedule quickly when needed (e.g. running
> top or ps or just hitting CR in one shell while another runs a compile job).

Thanks, added the first bad commit information to the bug entry.

Rafael
