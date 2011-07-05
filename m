Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316Ab1GEU1M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 16:27:12 -0400
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:52238 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754650Ab1GEU1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 16:27:09 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=vF6Za/Sxkw0hVnptNvPCwFT+M2sbC1idduRsvBAGfJ0dS2KSDTcDq5NSOhCEBSZ1wVrjDDXkXxHNzLJhzbq+78Utoyn/NvqIzApb40JVQ9Tjj3WRHMHQoaChITUk9LMf;
Date: Tue, 5 Jul 2011 13:27:06 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Per Forlin <per.forlin@linaro.org>
Cc: linaro-dev@lists.linaro.org, Nicolas Pitre <nicolas.pitre@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-doc@vger.kernel.org,
        Venkatraman S <svenkatr@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>, Sourav Poddar <sourav.poddar@ti.com>,
        Chris Ball <cjb@laptop.org>
Subject: Re: [PATCH v3] mmc: documentation of mmc non-blocking request usage
 and design.
Message-Id: <20110705132706.f610abb0.rdunlap@xenotime.net>
In-Reply-To: <1309895008-2587-2-git-send-email-per.forlin@linaro.org>
References: <1309895008-2587-1-git-send-email-per.forlin@linaro.org>
	<1309895008-2587-2-git-send-email-per.forlin@linaro.org>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  5 Jul 2011 21:43:28 +0200 Per Forlin wrote:

> Documentation about the background and the design of mmc non-blocking.
> Host driver guidelines to minimize request preparation overhead.
> 
> Signed-off-by: Per Forlin <per.forlin@linaro.org>
> ---

It would be better to omit the introductory email and put all of its comments
in this one [PATCH] email.


>  Documentation/mmc/00-INDEX          |    2 +
>  Documentation/mmc/mmc-async-req.txt |   86 +++++++++++++++++++++++++++++++++++
>  2 files changed, 88 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/mmc/mmc-async-req.txt
> 
> diff --git a/Documentation/mmc/00-INDEX b/Documentation/mmc/00-INDEX
> index 93dd7a7..11bc2cf 100644
> --- a/Documentation/mmc/00-INDEX
> +++ b/Documentation/mmc/00-INDEX
> @@ -4,3 +4,5 @@ mmc-dev-attrs.txt
>          - info on SD and MMC device attributes
>  mmc-dev-parts.txt
>          - info on SD and MMC device partitions
> +mmc-async-req.txt
> +        - info on mmc asynchronous request

                                      requests


> diff --git a/Documentation/mmc/mmc-async-req.txt b/Documentation/mmc/mmc-async-req.txt
> new file mode 100644
> index 0000000..d7e7698
> --- /dev/null
> +++ b/Documentation/mmc/mmc-async-req.txt
> @@ -0,0 +1,86 @@
> +Rationale
> +=========
> +
> +How significant is the cache maintenance overhead?
> +It depends, fast eMMC and multiple cache levels with speculative cache

   It depends:
or
   It depends. Fast

> +pre-fetch makes the cache overhead relatively significant. If the DMA
> +preparations for the next request are done in parallel to the current

                                                          with the current

> +transfer the DMA preparation overhead would not affect the MMC performance.

   transfer,

> +The intention of non-blocking (asynchronous) mmc requests is to minimize the
> +time between when an mmc request ends and another mmc request begins.
> +Using mmc_wait_for_req() the MMC controller is idle while dma_map_sg and

         mmc_wait_for_req(),

> +dma_unmap_sg is processing. Using non-blocking mmc requests makes it

                are processing.

> +possible to prepare the caches for next job in parallel to an active

                                                           with an active

> +mmc request.
> +
> +MMC block driver
> +================
> +
> +The issue_rw_rq() in the mmc block driver is made non-blocking.

preferably:                 MMC
throughout the file (when not a function or data name, etc.)

> +The increase in throughput is proportional to the time it takes to
> +prepare (major part of preparations is dma_map_sg and dma_unmap_sg)

                                       are

> +a request and how fast the memory is. The faster the MMC/SD is
> +the more significant the prepare request time becomes. Roughly the expected
> +performance gain is 5% for large writes and 10% on large reads on a L2 cache
> +platform. In power save mode, when clocks run on a lower frequency, the DMA
> +preparation may cost even more. As long as these slower preparations are run
> +in parallel to the transfer performance wont be affected.

               with                        won't

> +
> +Details on measurements from IOZone and mmc_test
> +================================================
> +
> +https://wiki.linaro.org/WorkingGroups/Kernel/Specs/StoragePerfMMC-async-req
> +
> +MMC core API extension
> +======================
> +
> +There is one new public function mmc_start_req()

                                    mmc_start_req().

> +It starts a new MMC command request for a host. The function isn't
> +truly non-blocking. If there is on ongoing async request it waits
> +for completion of that request and starts the new one and returns. It
> +doesn't wait for the new request to complete. If there is no ongoing
> +request it starts the new request and returns immediately.
> +
> +MMC host extensions
> +===================
> +
> +There are two optional hooks pre_req() and post_req() that the host driver

                          hooks -- pre_req() and post_req() -- that

> +may implement in order to move work to before and after the actual
> +mmc_request function is called. In the DMA case pre_req() may do
> +dma_map_sg() and prepare the dma descriptor, and post_req runs

                                DMA

> +the dma_unmap_sg.
> +
> +Optimize for the first request
> +==============================
> +
> +The first request in a series of requests can't be prepared in parallel to

                                                                           with

> +the previous transfer, since there is no previous request.
> +The argument is_first_req in pre_req() indicates that there is no previous
> +request. The host driver may optimize for this scenario to minimize
> +the performance loss. A way to optimize for this is to split the current
> +request in two chunks, prepare the first chunk and start the request,
> +and finally prepare the second chunk and start the transfer.
> +
> +Pseudocode to handle is_first_req scenario with minimal prepare overhead:
> +if (is_first_req && req->size > threshold)
> +   /* start MMC transfer for the complete transfer size */
> +   mmc_start_command(MMC_CMD_TRANSFER_FULL_SIZE)

      Please use ';' at the end of each pseudo-call.

> +
> +   /*
> +    * Begin to prepare DMA while cmd is being processed by MMC.
> +    * The first chunk of the request should take the same time
> +    * to prepare as the "MMC process command time".
> +    * If prepare time exceeds MMC cmd time
> +    * the transfer is delayed, guesstimate max 4k as first chunk size.
> +    */
> +    prepare_1st_chunk_for_dma(req)
> +    /* flush pending desc to the DMAC (dmaengine.h) */
> +    dma_issue_pending(req->dma_desc)
> +
> +    prepare_2nd_chunk_for_dma(req)
> +    /*
> +     * The second issue_pending should be called before MMC runs out
> +     * of the first chunk. If the MMC runs out of the first data chunk
> +     * before this call, the transfer is delayed.
> +     */
> +    dma_issue_pending(req->dma_desc)
> -- 


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
