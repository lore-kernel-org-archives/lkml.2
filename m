Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758077Ab1FINeP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 09:34:15 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:40065 "EHLO duck.linux-mips.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757955Ab1FINeL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 09:34:11 -0400
Date: Thu, 9 Jun 2011 14:34:48 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Russell King <linux@arm.linux.org.uk>,
        Ingo Molnar <mingo@elte.hu>, John Stultz <john.stultz@linaro.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [patch 5/5] i8253: Cleanup outb/inb magic
Message-ID: <20110609133448.GA8772@linux-mips.org>
References: <20110609130509.346588418@linutronix.de>
 <20110609130622.348437125@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110609130622.348437125@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 09, 2011 at 01:08:30PM -0000, Thomas Gleixner wrote:

> Remove the hysterical outb/inb_pit defines and use outb_p/inb_p in the
> code.

FWIW, I've traced the use of inb_p and outb_p to access the PIT timer
all the way back to Linux 0.10

I wonder if any of the systems affected actually has enough memory to boot
a modern kernel or if the _p versions have become useless bagagge that
should be dropped - cleanup which would then also allow more code to the
iomap() API.

I'm interested because quite a few MIPS systems have been built based on
Intel, OPTi and other chipsets which may or may not have been affected.

  Ralf
