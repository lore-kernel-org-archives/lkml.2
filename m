Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965207Ab2J3SFb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 14:05:31 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:53108 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760040Ab2J3SF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 14:05:29 -0400
Message-ID: <509016E7.800@wwwdotorg.org>
Date: Tue, 30 Oct 2012 12:05:27 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Dmitry Osipenko <digetx@gmail.com>, ldewangan@nvidia.com
CC: vinod.koul@intel.com, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] dma: tegra: avoid channel lock up after free
References: <508EA04D.5050805@wwwdotorg.org> <1351552833-4132-1-git-send-email-digetx@gmail.com>
In-Reply-To: <1351552833-4132-1-git-send-email-digetx@gmail.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/2012 05:20 PM, Dmitry Osipenko wrote:
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

Reviewed-by: Stephen Warren <swarren@nvidia.com>

I believe this looks OK. However, I would like Laxman to also ack/review
this since he wrote the driver.
