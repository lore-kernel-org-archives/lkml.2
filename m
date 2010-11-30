Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755621Ab0K3SIN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 13:08:13 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:47694 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755392Ab0K3SIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 13:08:12 -0500
Date: Tue, 30 Nov 2010 18:07:18 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Stephen Caudle <scaudle@codeaurora.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, dwalker@codeaurora.org,
        adharmap@codeaurora.org, miltonm@bga.com
Subject: Re: [PATCH v2] [ARM] gic: Unmask private interrupts on all cores
	during IRQ enable
Message-ID: <20101130180718.GB8521@n2100.arm.linux.org.uk>
References: <1288820762-16077-1-git-send-email-scaudle@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288820762-16077-1-git-send-email-scaudle@codeaurora.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 03, 2010 at 05:46:02PM -0400, Stephen Caudle wrote:
> Some multi-core ARM chips designate a unique IRQ number for each core for
> private peripheral interrupts (PPIs). Others designate a common IRQ number
> for all cores. In the latter case, requesting/freeing private peripheral
> interrupts currently unmasks/masks the interrupt for only the
> executing core, respectively.
> 
> With this change, request_irq will unmask a PPI on all cores so a separate
> call to enable_irq on the other cores is not required. Likewise, free_irq
> will mask a PPI on the other cores. Also, shutdown is implemented instead
> of disable to allow for lazy IRQ disabling.

Sorry, missed this.

If it's a private peripheral, it can only be accessed from its associated
CPU.  What that means is you don't want to enable the interrupt on other
CPUs as the peripheral may not be present or initialized on that CPU.

So I'm nervous about this change - architecturally it feels like the
wrong thing to do to take the PPI interrupts through the generic IRQ
infrastructure.
