Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755967Ab1KHOz6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 09:55:58 -0500
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:41136 "EHLO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755138Ab1KHOz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 09:55:57 -0500
MIME-Version: 1.0
In-Reply-To: <1320763712-764-1-git-send-email-marc.zyngier@arm.com>
References: <1320763712-764-1-git-send-email-marc.zyngier@arm.com>
From: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Date: Tue, 8 Nov 2011 20:25:35 +0530
Message-ID: <CAMQu2gwL+enHoyiAB7LWix3WqW76HMbmSs_DmPX0h8uX=OBmdw@mail.gmail.com>
Subject: Re: [PATCH] genirq: don't allow per cpu interrupts to be suspended
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 8, 2011 at 8:18 PM, Marc Zyngier <marc.zyngier@arm.com> wrote:
> The power management functions related to interrupts do not know
> (yet) about per-cpu interrupts and end up calling the wrong
> low-level methods to enable/disable interrupts.
>
> This leads to all kind of interesting issues (action taken on one
> CPU only, updating a refcount which is not used otherwise...).
>
> The workaround for the time being is simply to flag these interrupts
> with IRQF_NO_SUSPEND. At least on ARM, these interrupts are actually
> dealt with at the architecture level.
>
> Reported-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
Just to add, the suspend is broken on mainline
for ARM machines which are using IRQCHIP_MASK_ON_SUSPEND.
The $subject patch fixes that issue.

Tested-by: Santosh Shilimkar <santosh.shilimkar@ti.com>

Regards,
Santosh
