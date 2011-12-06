Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755354Ab1LFX3A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 18:29:00 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:46067 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754591Ab1LFX27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 18:28:59 -0500
Date: Wed, 7 Dec 2011 01:28:46 +0200
From: Ido Yariv <ido@wizery.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC] genirq: Flush the irq thread on synchronization
Message-ID: <20111206232824.GA23893@WorkStation>
References: <1322843052-7166-1-git-send-email-ido@wizery.com>
 <alpine.LFD.2.02.1112022345300.2735@ionos>
 <alpine.LFD.2.02.1112052248010.2735@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1112052248010.2735@ionos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

On Mon, Dec 05, 2011 at 10:55:01PM +0100, Thomas Gleixner wrote:
> Does the following (untested) patch solve your issues?

I briefly tested this patch and it appears to also solve the issues I
mentioned.

I think both solutions would work. The only drawbacks I see in using
this patch over the other one are that this patch involves a bit more
locking in synchronize_irq() and irq_finalize_oneshot() (for non-oneshot
irqs), and that the oneshot mechanism is used for non-oneshot threads.

Thanks,
Ido.
