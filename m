Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755754Ab0DUR2M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 13:28:12 -0400
Received: from tex.lwn.net ([70.33.254.29]:52300 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753671Ab0DUR2K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 13:28:10 -0400
Date: Wed, 21 Apr 2010 11:28:07 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Will Newton <will.newton@gmail.com>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Threaded irq handler question
Message-ID: <20100421112807.5eca9f9d@bike.lwn.net>
In-Reply-To: <l2u87a5b0801004210935wf6ca2991ua777c39c737391f8@mail.gmail.com>
References: <l2u87a5b0801004210935wf6ca2991ua777c39c737391f8@mail.gmail.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Apr 2010 17:35:32 +0100
Will Newton <will.newton@gmail.com> wrote:

> My problem is that this structure does not work, because once I call
> disable_irq_nosync() on the irq in the check handler the thread will
> no longer run because the irq is disabled. However if I don't call
> disable_irq_nosync() I will get endless irqs because the line is
> level-triggered and will not be deasserted until the thread has run.

Trying to disable IRQs at this level is the wrong approach.  You need to
do enough in the primary interrupt handler to cause the hardware to
stop interrupting in the first place; usually that's just a matter of
some sort of acknowledgment.  Then the threaded handler can move data
around in peace.

jon
