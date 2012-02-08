Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755523Ab2BHQ11 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 11:27:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8914 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752906Ab2BHQ10 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 11:27:26 -0500
Date: Wed, 8 Feb 2012 17:20:13 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Frysinger <vapier@gentoo.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Richard Weinberger <richard@nod.at>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/8] blackfin: Fix possible race on task->mm
Message-ID: <20120208162013.GC17177@redhat.com>
References: <20120207064809.GA29061@oksana.dev.rtsoft.ru> <20120207065054.GF1496@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120207065054.GF1496@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07, Anton Vorontsov wrote:
>
> Even when in atomic context, grabbing irqsave variant of tasklist lock
> is not enough to protect task->mm from disappearing on SMP machines.
> Instead, we have to grab the task lock.

Yes, but afaics there is no reason for write_lock_irqsave(tasklist).
read_lock() should be enough.

I know nothing about arch/blackfin/ but in fact this looks simply wrong.

For example. sysrq_showregs_othercpus() does smp_call_function(showacpu)
and showacpu() show_stack()->decode_address(). Now suppose that IPI
interrupts the task holding read_lock(tasklist).

Mike?

Oleg.

