Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757678Ab2EaHbS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 03:31:18 -0400
Received: from www.linutronix.de ([62.245.132.108]:55298 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757558Ab2EaHbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 03:31:17 -0400
Date: Thu, 31 May 2012 09:30:52 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Sundar Iyer <sundar.iyer@intel.com>
cc: linux-kernel@vger.kernel.org, arjan.van.de.ven@intel.com,
        german.monroy@intel.com
Subject: Re: [PATCH v1] x86/irq: handle chained interrupts during IRQ
 migration
In-Reply-To: <1338298808-2265-1-git-send-email-sundar.iyer@intel.com>
Message-ID: <alpine.LFD.2.02.1205310930030.3231@ionos>
References: <1338298808-2265-1-git-send-email-sundar.iyer@intel.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 May 2012, Sundar Iyer wrote:

> Chained interrupt handlers dont have an irqaction and hence are not
> handled during migrating interrupts when some cores go offline.
> 
> Handle this by introducing a irq_is_chained() check which is based
> on the IRQ_NOREQUEST flag being set for such interrupts. fixup_irq()
> can then handle such interrupts and not skip them over.

No, we need a separate flag for those. IRQ_NORREQUEST is not a
reliable indicator.
 
Thanks,

	tglx
