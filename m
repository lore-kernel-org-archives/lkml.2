Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932Ab0HSXoO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 19:44:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38430 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751252Ab0HSXoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 19:44:10 -0400
Date: Thu, 19 Aug 2010 16:43:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alan Cox <alan@linux.intel.com>
Cc: Michal Simek <monstr@monstr.eu>, michal.simek@petalogix.com,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Ralf Baechle <ralf@linux-mips.org>,
        Manuel Lauss <manuel.lauss@googlemail.com>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] serial: 8250: Initialize pointer to irq_info
Message-Id: <20100819164354.09e30dc9.akpm@linux-foundation.org>
In-Reply-To: <20100817091720.56183993@linux.intel.com>
References: <1282031947-16483-1-git-send-email-monstr@monstr.eu>
	<20100817091720.56183993@linux.intel.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Aug 2010 09:17:20 +0100
Alan Cox <alan@linux.intel.com> wrote:

> On Tue, 17 Aug 2010 09:59:06 +0200
> Michal Simek <monstr@monstr.eu> wrote:
> 
> > Initialize "i" irq_info pointer in serial_unlink_irq_chain.
> > 
> > Compilation warning:
> >   CC      drivers/serial/8250.o
> > drivers/serial/8250.c: In function 'serial8250_shutdown':
> > drivers/serial/8250.c:1701: warning: 'i' may be used uninitialized in
> > this function
> 
> NAK (again)
> 
> Use a newer compiler - modern ones get this right.

: static void serial_unlink_irq_chain(struct uart_8250_port *up)
: {
: 	struct irq_info *i;
: 	struct hlist_node *n;
: 	struct hlist_head *h;
: 
: 	mutex_lock(&hash_mutex);
: 
: 	h = &irq_lists[up->port.irq % NR_IRQ_HASH];
: 
: 	hlist_for_each(n, h) {
: 		i = hlist_entry(n, struct irq_info, node);
: 		if (i->irq == up->port.irq)
: 			break;
: 	}
: 
: 	BUG_ON(n == NULL);
: 	BUG_ON(i->head == NULL);

How can any compiler possibly determine that the hlist_for_each() is
never executed zero times?

