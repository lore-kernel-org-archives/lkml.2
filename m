Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754398Ab0LAK2f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 05:28:35 -0500
Received: from www.tglx.de ([62.245.132.106]:59878 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754284Ab0LAK2d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 05:28:33 -0500
Date: Wed, 1 Dec 2010 11:28:28 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Lennert Buytenhek <buytenh@wantstofly.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] genirq: Provide reverse compat handling for irq_chip
 methods.
In-Reply-To: <20101130120813.GR12037@mail.wantstofly.org>
Message-ID: <alpine.LFD.2.00.1012011123150.2653@localhost6.localdomain6>
References: <20101130120813.GR12037@mail.wantstofly.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Nov 2010, Lennert Buytenhek wrote:

> kernel/irq/chip.c provides compat wrappers for when users of the
> new-style (->irq_foo()) irq_chip methods try to call into irq_chips
> that provide only old-style (->foo()) methods, but doesn't currently
> provide compatibility in the other direction.
> 
> As there exist chained irq flow handlers outside kernel/irq/ that have
> not been converted over to call the new methods yet, this means that
> the irq_chips that they are chained off can't be converted to the new
> methods yet.
> 
> This patch adds reverse compat wrappers, so that old-style flow
> handlers can call into new-style irq_chips, too, and the flow handlers
> and irq_chips can be converted to the new API independently.

Uuurg. That's backwards. Why not fixing the flow handlers first ?
 
Thanks,

	tglx
