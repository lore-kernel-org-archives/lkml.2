Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755160Ab1K0XLb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 18:11:31 -0500
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:46948 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753075Ab1K0XL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 18:11:29 -0500
Subject: Re: [PATCH 18/62] media: remove the second argument of
 k[un]map_atomic()
From: Andy Walls <awalls@md.metrocast.net>
To: Cong Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        ivtv-devel@ivtvdriver.org, linux-media@vger.kernel.org
Date: Sun, 27 Nov 2011 18:10:40 -0500
In-Reply-To: <1322371662-26166-19-git-send-email-amwang@redhat.com>
References: <1322371662-26166-1-git-send-email-amwang@redhat.com>
	 <1322371662-26166-19-git-send-email-amwang@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1322435442.2363.0.camel@palomino.walls.org>
Mime-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.5.7110,1.0.211,0.0.0000
 definitions=2011-11-27_01:2011-11-27,2011-11-26,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 suspectscore=0
 phishscore=0 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=6.0.2-1012030000 definitions=main-1111270268
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-11-27 at 13:26 +0800, Cong Wang wrote:
> Signed-off-by: Cong Wang <amwang@redhat.com>

Acked-by: Andy Walls <awalls@md.metrocast.net>

Regards,
Andy

> ---
>  drivers/media/video/ivtv/ivtv-udma.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/video/ivtv/ivtv-udma.c b/drivers/media/video/ivtv/ivtv-udma.c
> index 69cc816..7338cb2 100644
> --- a/drivers/media/video/ivtv/ivtv-udma.c
> +++ b/drivers/media/video/ivtv/ivtv-udma.c
> @@ -57,9 +57,9 @@ int ivtv_udma_fill_sg_list (struct ivtv_user_dma *dma, struct ivtv_dma_page_info
>  			if (dma->bouncemap[map_offset] == NULL)
>  				return -1;
>  			local_irq_save(flags);
> -			src = kmap_atomic(dma->map[map_offset], KM_BOUNCE_READ) + offset;
> +			src = kmap_atomic(dma->map[map_offset]) + offset;
>  			memcpy(page_address(dma->bouncemap[map_offset]) + offset, src, len);
> -			kunmap_atomic(src, KM_BOUNCE_READ);
> +			kunmap_atomic(src);
>  			local_irq_restore(flags);
>  			sg_set_page(&dma->SGlist[map_offset], dma->bouncemap[map_offset], len, offset);
>  		}


