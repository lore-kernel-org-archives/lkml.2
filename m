Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952Ab1FFXSs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 19:18:48 -0400
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:36287 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751634Ab1FFXSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 19:18:47 -0400
From: Kevin Hilman <khilman@ti.com>
To: Colin Cross <ccross@android.com>
Cc: linux-omap@vger.kernel.org, Santosh Shilimkar <santosh.shilimkar@ti.com>,
        tarun.kanti@ti.com, linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] ARM: omap4: gpio: fix setting IRQWAKEN bits
Organization: Texas Instruments, Inc.
References: <1307392698-21170-1-git-send-email-ccross@android.com>
Date: Mon, 06 Jun 2011 16:18:44 -0700
In-Reply-To: <1307392698-21170-1-git-send-email-ccross@android.com> (Colin
	Cross's message of "Mon, 6 Jun 2011 13:38:17 -0700")
Message-ID: <87boyav99n.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Colin,

Colin Cross <ccross@android.com> writes:

> Setting the IRQWAKEN bit was overwriting previous IRQWAKEN bits,
> causing only the last bit set to take effect, resulting in lost
> wakeups when the GPIO controller is in idle.
>
> Replace direct writes to IRQWAKEN with MOD_REG_BIT calls to
> perform a read-modify-write on the register.
>
> Signed-off-by: Colin Cross <ccross@android.com>

Thanks, I'll queue these both for Grant for the 3.0-rc fixes along with
another GPIO fix for a section mismatch I have queued.

Minor: now that this driver has moved to drivers, I changed the subject
prefixes slightly.  They now read:

GPIO: OMAP: fix setting IRQWAKEN bits for OMAP4
GPIO: OMAP: add locking around calls to _set_gpio_triggering

Kevin
