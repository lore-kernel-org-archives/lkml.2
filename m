Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755953Ab1FNKFx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 06:05:53 -0400
Received: from www.linutronix.de ([62.245.132.108]:41118 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755908Ab1FNKFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 06:05:52 -0400
Date: Tue, 14 Jun 2011 12:05:50 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Manuel Lauss <manuel.lauss@googlemail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: chained irq handler problems
In-Reply-To: <BANLkTi=urdW0WBHcVbVzDwwLzupP_Vh2EA@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1106141202531.11814@ionos>
References: <BANLkTi=urdW0WBHcVbVzDwwLzupP_Vh2EA@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Jun 2011, Manuel Lauss wrote:
> My question is: what are the differences in interrupt handling between the
> "traditional" handler and the cascade handler case?
> I also noticed that the cascade irq (the muxer irq line to the cpu) is not
> disabled when the interrupt is serviced. Is this by design?

The normal handler, which should btw never ever be setup from an
startup callback, deals with the irq chip functions (mask, ack, eoi)
which are assigned to that irq line. The chained handler is called
directly from the low level entry code and bypasses the standard
handling mechanism. That means no chip functions are called. If your
irq chip of the primary line requires e.g. an ack, then this needs to
be done explicitely in the chained handler itself.

Thanks,

	tglx
