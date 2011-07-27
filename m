Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506Ab1G0A0s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 20:26:48 -0400
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:40119 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751064Ab1G0A0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 20:26:46 -0400
From: Kevin Hilman <khilman@ti.com>
To: Colin Cross <ccross@android.com>
Cc: linux-pm@lists.linux-foundation.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-kernel@vger.kernel.org, Nishanth Menon <nm@ti.com>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v2] PM: runtime: add might_sleep to PM runtime functions
Organization: Texas Instruments, Inc.
References: <1311627344-8097-1-git-send-email-ccross@android.com>
Date: Tue, 26 Jul 2011 17:26:42 -0700
In-Reply-To: <1311627344-8097-1-git-send-email-ccross@android.com> (Colin
	Cross's message of "Mon, 25 Jul 2011 13:55:44 -0700")
Message-ID: <871uxcr2kd.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Colin Cross <ccross@android.com> writes:

> Some of the entry points to pm runtime are not safe to
> call in atomic context unless pm_runtime_irq_safe() has
> been called.  Inspecting the code, it is not immediately
> obvious that the functions sleep at all, as they run
> inside a spin_lock_irqsave, but under some conditions
> they can drop the lock and turn on irqs.
>
> If a driver incorrectly calls the pm_runtime apis, it can
> cause sleeping and irq processing when it expects to stay
> in atomic context.
>
> Add might_sleep_if to all the __pm_runtime_* entry points
> to enforce correct usage.

Minor: s/all/most of/, or something similar since in v2, it doesn't
annotate all of the functions anymore, just the main ones likely to be
(mis)used by drivers.

Other than that, looks good...

> Add pm_runtime_put_sync_autosuspend to the list of
> functions that can be called in atomic context.
>
> Signed-off-by: Colin Cross <ccross@android.com>

Reviewed-by: Kevin Hilman <khilman@ti.com>

Kevin
