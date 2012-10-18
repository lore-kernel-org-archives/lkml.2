Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260Ab2JRJrl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 05:47:41 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:27424 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754784Ab2JRJrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 05:47:40 -0400
Date: Thu, 18 Oct 2012 12:47:15 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Shuah Khan <shuah.khan@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, konrad.wilk@oracle.com,
        rob@landley.net, joerg.roedel@amd.com, shuahkhan@gmail.com,
        devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH] Documentation DMA-API-HOWTO.txt Add dma mapping error
 check usage examples
Message-ID: <20121018094715.GC5685@mwanda>
References: <1350230064.4069.1.camel@lorien2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350230064.4069.1.camel@lorien2>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 14, 2012 at 09:54:24AM -0600, Shuah Khan wrote:
> diff --git a/Documentation/DMA-API-HOWTO.txt b/Documentation/DMA-API-HOWTO.txt
> index a0b6250..cf1adb4 100644
> --- a/Documentation/DMA-API-HOWTO.txt
> +++ b/Documentation/DMA-API-HOWTO.txt
> @@ -468,11 +468,46 @@ To map a single region, you do:
>  	size_t size = buffer->len;
>  
>  	dma_handle = dma_map_single(dev, addr, size, direction);
> +	if (unlikely(dma_mapping_error(dma_handle))) {

Don't encourage people to put unlikely() and likely() into their
driver code.  It should only be used after benchmarking both with
and without.  I can't imagine how it would make a measurable
difference here.

regards,
dan carpenter


