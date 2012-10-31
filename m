Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423073Ab2JaPAh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 11:00:37 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:18423 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423051Ab2JaPAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 11:00:33 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 31 Oct 2012 07:47:50 -0700
Message-ID: <50913CAC.5090808@nvidia.com>
Date: Wed, 31 Oct 2012 20:28:52 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Dmitry Osipenko <digetx@gmail.com>
CC: "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2] dma: tegra: avoid channel lock up after free
References: <508EA04D.5050805@wwwdotorg.org> <1351552833-4132-1-git-send-email-digetx@gmail.com>
In-Reply-To: <1351552833-4132-1-git-send-email-digetx@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 October 2012 04:50 AM, Dmitry Osipenko wrote:
> Fixed channel "lock up" after free.
>
> Lock scenario: Channel 1 was allocated and prepared as slave_sg, used and freed.
> Now preparation of cyclic dma on channel 1 will fail with err "DMA configuration
> conflict" because tdc->isr_handler still selected to handle_once_dma_done.
>
> This happens because tegra_dma_abort_all() won't be called on channel freeing
> if pending list is empty or channel not busy. We need to clear isr_handler
> on channel freeing to avoid locking. Also I added small optimization to prepare
> functions, so current channel type checked before making allocations.
>
> Signed-off-by: Dmitry Osipenko<digetx@gmail.com>
> ---

Looks good to me.
Acked-by: Laxman Dewangan <ldewangan@nvidia.com>

