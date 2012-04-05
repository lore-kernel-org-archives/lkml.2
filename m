Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449Ab2DEInV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 04:43:21 -0400
Received: from www.linutronix.de ([62.245.132.108]:34078 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752951Ab2DEInU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 04:43:20 -0400
Date: Thu, 5 Apr 2012 10:43:12 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Sam Ravnborg <sam@ravnborg.org>
cc: lkml <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>, linux-m68k@vger.kernel.org,
        Greg Ungerer <gerg@uclinux.org>,
        sparclinux <sparclinux@vger.kernel.org>
Subject: Re: [PATCH] irq: remove obsolete definitions in interrupt.h
In-Reply-To: <20120404074553.GA14959@merkur.ravnborg.org>
Message-ID: <alpine.LFD.2.02.1204051036470.2542@ionos>
References: <20120404074553.GA14959@merkur.ravnborg.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Apr 2012, Sam Ravnborg wrote:

> interrupt.h contained a small fixlet for the days when
> m68k and sparc32 did not use genirq.
> As they have both entered the modern world this
> fixlet can be dropped.

You forgot that there is still an esoteric architecture which has
CONFIG_GENERIC_HARDIRQS=n.

So at least the exit_irq_thread() needs to stay.

The request_threaded_irq() one should not be used by any S390
driver. If it's used, they have probably a special opcode for it. :)

Thanks,

	tglx

 
