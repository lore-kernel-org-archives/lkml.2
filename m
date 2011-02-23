Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932521Ab1BWT1X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 14:27:23 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48958 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927Ab1BWT1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 14:27:22 -0500
MIME-Version: 1.0
X-Originating-IP: [240.146.208.188]
In-Reply-To: <1298482889-21841-1-git-send-email-swarren@nvidia.com>
References: <1298482889-21841-1-git-send-email-swarren@nvidia.com>
Date: Wed, 23 Feb 2011 11:26:33 -0800
Message-ID: <AANLkTikan_3pEcVO082+-fh7BdZK2PzFB5M=bAAE_iQ8@mail.gmail.com>
Subject: Re: [PATCH v2] ARM: Tegra: Make tegra_dma_init a postcore_initcall
From: Olof Johansson <olof@lixom.net>
To: Stephen Warren <swarren@nvidia.com>
Cc: ccross@android.com, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, konkers@android.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 23, 2011 at 9:41 AM, Stephen Warren <swarren@nvidia.com> wrote:
> The following commit makes the Tegra APB DMA engine fail to initialize
> correctly: 0cf6230af909a86f81907455eca2a5c9b8f68fe6
> ARM: tegra: Move tegra_common_init to tegra_init_early
>
> The reason is that tegra_init_early_ calls tegra_dma_init which calls
> request_threaded_irq, which fails since the IRQ hasn't yet been marked
> valid; that only happens in tegra_init_irq, which gets called after
> tegra_init_early.
>
> This used to work OK, since tegra_init_early was tegra_common_init, which
> got called after tegra_init_irq, basically from the beginning of
> tegra_harmony_init.
>
> Solve this by converting tegra_dma_init to a postcore_initcall. This makes
> it execute late enough that IRQs are marked valid, and avoids having to
> add it back to every machine's init function.
>
> Signed-off-by: Stephen Warren <swarren@nvidia.com>

Acked-by: Olof Johansson <olof@lixom.net>
