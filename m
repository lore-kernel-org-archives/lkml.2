Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753128Ab0IXIpT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 04:45:19 -0400
Received: from www.tglx.de ([62.245.132.106]:45717 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751597Ab0IXIpR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 04:45:17 -0400
Date: Fri, 24 Sep 2010 10:45:09 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Potential race in irq_chip_set_defaults()?
In-Reply-To: <4C9BEF6A.9040107@goop.org>
Message-ID: <alpine.LFD.2.00.1009241040420.2416@localhost6.localdomain6>
References: <4C9BEF6A.9040107@goop.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy

On Thu, 23 Sep 2010, Jeremy Fitzhardinge wrote:

>  irq_chip_set_defaults() modifies the irq_chip structure in-place when
> setting up an irq.  If that happens on multiple CPUs at once then it
> could leave the irq_chip structure in an inconsistent state.
> 
> Is there anything preventing that case from happening?  There's no
> locking, and as far as I know there's no rule forbidding concurrent
> calls to set_irq_chip()/irq_chip_set_defaults().

that's true. Never thought about that. Will have a look.

Thanks,

	tglx


