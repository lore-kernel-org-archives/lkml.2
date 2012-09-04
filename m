Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757955Ab2IDXYQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 19:24:16 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:36096 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757931Ab2IDXYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 19:24:14 -0400
Message-ID: <1346801051.3130.31.camel@lorien2>
Subject: Re: [PATCH] swiotlb: add kernel error message to track iobtlb
 overflow buffer usage
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: konrad.wilk@oracle.com
Cc: akpm@linux-foundation.org, paul.gortmaker@windriver.com,
        bhelgaas@google.com, amwang@redhat.com, linux-kernel@vger.kernel.org,
        fujita.tomonori@lab.ntt.co.jp, shuahkhan@gmail.com
Date: Tue, 04 Sep 2012 17:24:11 -0600
In-Reply-To: <1346460959.3393.3.camel@lorien2>
References: <1346460959.3393.3.camel@lorien2>
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-08-31 at 18:55 -0600, Shuah Khan wrote:
> Add kernel error message to track iotlb overflow buffer triggers to understand
> how often the overflow buffer gets used.

Does this change look reasonable? My intent is to be able to assess how
often the overflow buffer usage gets triggered.

-- Shuah
> 
> Signed-off-by: Shuah Khan <shuah.khan@hp.com>
> ---
>  lib/swiotlb.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/lib/swiotlb.c b/lib/swiotlb.c
> index 45bc1f8..597d7b9 100644
> --- a/lib/swiotlb.c
> +++ b/lib/swiotlb.c
> @@ -682,6 +682,7 @@ dma_addr_t swiotlb_map_page(struct device *dev, struct page *page,
>  	if (!map) {
>  		swiotlb_full(dev, size, dir, 1);
>  		map = io_tlb_overflow_buffer;
> +		dev_err(dev, "SWIOTLB is full. Mapping overflow buffer.\n");
>  	}
>  
>  	dev_addr = swiotlb_virt_to_bus(dev, map);


