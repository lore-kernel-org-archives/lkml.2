Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932200Ab0JFNe4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 09:34:56 -0400
Received: from casper.infradead.org ([85.118.1.10]:38522 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756315Ab0JFNey convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 09:34:54 -0400
Subject: Re: 1 RT task blocks 4-core machine ?
From: Peter Zijlstra <peterz@infradead.org>
To: Tommaso Cucinotta <tommaso.cucinotta@sssup.it>
Cc: Dhaval Giani <dhaval.giani@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dario Faggioli <faggioli@gandalf.sssup.it>,
        Fabio Checconi <fabio@gandalf.sssup.it>, linux-kernel@vger.kernel.org
In-Reply-To: <4CAA54A1.6050507@sssup.it>
References: <AANLkTim2icGqFWB1S6TVcQwmo+sCcGdNDPO3s8LFqzR=@mail.gmail.com>
	 <4CAA54A1.6050507@sssup.it>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 06 Oct 2010 15:34:05 +0200
Message-ID: <1286372045.2144.180.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-05 at 00:26 +0200, Tommaso Cucinotta wrote:
> A possible explanation might be that the CFS load balancing logic sees
> my only active task (e.g., the ssh server or shell etc.) as running
> alone on its core, and does not detect that it is inhibited to actually
> run due to RT tasks on the same core. Therefore, it will not migrate
> the task to the free cores. Does this explanation make sense
> or is it completely wrong ?

Possibly, its got some logic to detect this but maybe it gets confused
still, in particular look at the adaptive cpu_power in
update_cpu_power() and calling functions.

> Also, I'd like to hear whether this is considered the "normal/desired"
> behavior of intermixing RT and non-RT tasks. 

Pegging a cpu using sched_fifo/rr pretty much means you get to keep the
pieces, if it works nice, if you can make it work better kudos, but no
polling from sched_fifo/rr is not something that is considered sane for
the general health of your system.
