Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752343Ab0CZIQK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 04:16:10 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56858 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054Ab0CZIQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 04:16:07 -0400
Date: Fri, 26 Mar 2010 08:14:57 +0000
From: Russell King <rmk@arm.linux.org.uk>
To: Thomas Gleixner <tglx@linutronix.de>, Nicolas Pitre <nico@fluxnic.net>
Cc: Linus Torvalds <torvalds@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Andi Kleen <andi@firstfloor.org>,
       David Miller <davem@davemloft.net>, Greg Kroah-Hartman <gregkh@suse.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [patch 0/2] Run interrupt handlers always with interrupts
	disabled
Message-ID: <20100326081457.GA23570@flint.arm.linux.org.uk>
Mail-Followup-To: Thomas Gleixner <tglx@linutronix.de>,
	Nicolas Pitre <nico@fluxnic.net>,
	Linus Torvalds <torvalds@osdl.org>,
	LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Andi Kleen <andi@firstfloor.org>,
	David Miller <davem@davemloft.net>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Arnaldo Carvalho de Melo <acme@redhat.com>
References: <20100326000325.917127328@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100326000325.917127328@linutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 26, 2010 at 12:06:44AM -0000, Thomas Gleixner wrote:
> The following patch series removes the IRQF_DISABLED functionality
> from the core interrupt code and runs all interrupt handlers with
> interrupts disabled.

As was covered in previous discussions, what about drivers such as
SMC91x which take a long time to retrieve packets from the hardware?
Always running handlers with IRQs disabled will kill things such as
serial on these platforms.

So based on your description, I have no option but to NAK this.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
