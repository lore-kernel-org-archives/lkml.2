Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758025Ab1EZP40 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 11:56:26 -0400
Received: from canuck.infradead.org ([134.117.69.58]:41489 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754017Ab1EZP4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 11:56:25 -0400
Subject: Re: [BUG] "sched: Remove rq->lock from the first half of ttwu()"
 locks up on ARM
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Marc Zyngier <Marc.Zyngier@arm.com>, Yong Zhang <yong.zhang0@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Frank Rowand <frank.rowand@am.sony.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
In-Reply-To: <20110526154508.GA13788@redhat.com>
References: <1306260792.27474.133.camel@e102391-lin.cambridge.arm.com>
	 <1306272750.2497.79.camel@laptop> <1306343335.21578.65.camel@twins>
	 <1306358128.21578.107.camel@twins>
	 <BANLkTi=XbTXQsu3jUEvQyCfBy6-aRnqSpw@mail.gmail.com>
	 <1306405979.1200.63.camel@twins>
	 <1306407759.27474.207.camel@e102391-lin.cambridge.arm.com>
	 <1306409575.1200.71.camel@twins> <1306412511.1200.90.camel@twins>
	 <20110526154508.GA13788@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 26 May 2011 17:59:44 +0200
Message-ID: <1306425584.2497.81.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-05-26 at 17:45 +0200, Oleg Nesterov wrote:
> Stupid question. Can't we fix this problem if we do
> 
>         -       if (p == current)
>         +       if (cpu == raw_smp_processor_id())
> 
> ?
> 
> I forgot the rules... but iirc task_cpu(p) can't be changed under us?

Easy enough to test.. brain gave out again,. hold on ;-)

