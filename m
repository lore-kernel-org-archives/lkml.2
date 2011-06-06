Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754469Ab1FFQSp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 12:18:45 -0400
Received: from www.linutronix.de ([62.245.132.108]:54273 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752500Ab1FFQSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 12:18:43 -0400
Date: Mon, 6 Jun 2011 18:18:41 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: David Jander <david.jander@protonic.nl>
cc: linux-kernel@vger.kernel.org
Subject: Re: Why does handle_simple_irq() require IRQ's to be disabled?
In-Reply-To: <20110606172840.322f09d4@archvile>
Message-ID: <alpine.LFD.2.02.1106061816280.13964@ionos>
References: <20110606172840.322f09d4@archvile>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Jun 2011, David Jander wrote:
> 
> Hi,
> 
> I am trying to implement/fix interrupt controller functionality in
> gpio/pca953x.c, and for some reason which I don't understand, I need to disable
> interrupts with local_irq_disable() before calling generic_handle_irq(). This
> does not seem right.
> If I follow the code of handle_simple_irq(), the handler function setup for
> this IRQ, I get to handle_irq_event_percpu(), which has a
> WARN_ONCE(!irqs_disabled(),...
> This WARN is triggered, since nobody explicitly disables interrupts. Why?
>  
> generic_hanlde_irq() is called from a threaded interrupt handler of the parent
> of this interrupt controller, and calling local_irq_disable() here seems like
> a crime. What am I doing wrong?

handle_nested_irq() is your friend.
