Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755422Ab0IIRKD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 13:10:03 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:4924 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753027Ab0IIRKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 13:10:01 -0400
Message-ID: <4C8914E8.5030002@caviumnetworks.com>
Date: Thu, 09 Sep 2010 10:10:00 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100720 Fedora/3.0.6-1.fc12 Thunderbird/3.0.6
MIME-Version: 1.0
To: Kevin Cernekee <cernekee@gmail.com>
CC: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] MIPS: DMA: Add plat_extra_sync_for_cpu()
References: <064bb0722da5d8c271c2bd9fe0a521cc@localhost> <99a0868bdbcfa8785a92b4af4f6d9b99@localhost>
In-Reply-To: <99a0868bdbcfa8785a92b4af4f6d9b99@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Sep 2010 17:10:00.0893 (UTC) FILETIME=[D65126D0:01CB5041]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/08/2010 04:02 PM, Kevin Cernekee wrote:
> On noncoherent processors with a readahead cache, an extra platform-
> specific invalidation is required during the dma_sync_*_for_cpu()
> operations to keep drivers from seeing stale prefetched data.
>
> Signed-off-by: Kevin Cernekee<cernekee@gmail.com>
> ---
>   .../include/asm/mach-cavium-octeon/dma-coherence.h |   13 +++++++++++++
>   arch/mips/include/asm/mach-generic/dma-coherence.h |   13 +++++++++++++
>   arch/mips/include/asm/mach-ip27/dma-coherence.h    |   13 +++++++++++++
>   arch/mips/include/asm/mach-ip32/dma-coherence.h    |   13 +++++++++++++
>   arch/mips/include/asm/mach-jazz/dma-coherence.h    |   13 +++++++++++++
>   .../mips/include/asm/mach-loongson/dma-coherence.h |   13 +++++++++++++
>   arch/mips/include/asm/mach-powertv/dma-coherence.h |   13 +++++++++++++
>   arch/mips/mm/dma-default.c                         |    3 +++
>   8 files changed, 94 insertions(+), 0 deletions(-)
>
[...]

But as far as I can see, none of your plat_extra_sync_for_cpu() do anything.

Perhaps adding this hook should be deferred until there is actually a user.

David Daney
