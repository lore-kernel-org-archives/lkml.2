Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014Ab1BIP27 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 10:28:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750973Ab1BIP26 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 10:28:58 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20110203004210.434316157@linutronix.de>
References: <20110203004210.434316157@linutronix.de> <20110203003745.371989282@linutronix.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: dhowells@redhat.com, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ralf Baechle <ralf@linux-mips.org>, Tony Luck <tony.luck@intel.com>,
        Michal Simek <monstr@monstr.eu>
Subject: Re: [patch 5/8] mn10300: Remove stale irq_chip.end
Date: Wed, 09 Feb 2011 15:28:25 +0000
Message-ID: <15052.1297265305@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner <tglx@linutronix.de> wrote:

> -static void mn10300_serial_nop(unsigned int irq)
> -{
> -}
> -
>  static struct irq_chip mn10300_serial_pic = {
>  	.name		= "mnserial",
>  	.ack		= mn10300_serial_mask_ack,
>  	.mask		= mn10300_serial_mask_ack,
>  	.mask_ack	= mn10300_serial_mask_ack,
>  	.unmask		= mn10300_serial_nop,
> -	.end		= mn10300_serial_nop,
>  };

This doesn't compile.  .unmask still refers to that function.

David
