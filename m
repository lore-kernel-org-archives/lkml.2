Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755171Ab0EKSfH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 14:35:07 -0400
Received: from smtp133.mail.ukl.yahoo.com ([77.238.184.64]:31160 "HELO
	smtp133.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754670Ab0EKSfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 14:35:04 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 May 2010 14:35:04 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.es;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=ZPaIM7wZ20e8k+0XgerrAA6tqSh33fbEgBB85jR4n0//yHEhN1Kx6/eD3XsO3oq7zZP9hpkfVdbp9hKPddCzKrszbg6SPJmlb1NBGLOHSSyMq627OAtGcoG962/7isNzpPOYJHVV2BIx3MMCKAazMhPqJ4JNHk7WrlV54ZZmg8k=  ;
X-Yahoo-SMTP: czee06uswBAtfIYshc.kP27UlfEXaxwWNSjJ
X-YMail-OSG: uA.AM2QVM1lVuN.eREJ8yXdDyudYWhNtKCxt4EAwIEkcmK4j5_PBnZ0FentnssUZXoAZmb9iu2_bhD1BHxoKZKVKyNucSTEYgeDR7Jm.lynM8TF1LCXrtfSqgMCfLnsFVD6xI8v_OjUn8mrO2DDqZ90n0BLCswZ3X3BBGsh6iuGUSK9d.qe5Sydn1AhKOJG460EsJjzQQelUwn8zaIBMSN4LHoNkAFSeoRf.9PHHnPj5LiK1EskinqYJqWMpeDBmj8PLsRf9SeL89a2dfzoZKZn40f2w1Igyp2A-
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4BE9A1C0.3090505@yahoo.es>
Date: Tue, 11 May 2010 20:28:16 +0200
From: Albert Herranz <albert_herranz@yahoo.es>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, chrisw@sous-sol.org,
       Ian.Campbell@eu.citrix.com, jeremy@goop.org, dwmw2@infradead.org
Subject: Re: [PATCH 5/6] swiotlb: Make swiotlb bookkeeping functions visible
 in the header file.
References: <1273592353-23224-1-git-send-email-konrad.wilk@oracle.com> <1273592353-23224-2-git-send-email-konrad.wilk@oracle.com> <1273592353-23224-3-git-send-email-konrad.wilk@oracle.com> <1273592353-23224-4-git-send-email-konrad.wilk@oracle.com> <1273592353-23224-5-git-send-email-konrad.wilk@oracle.com> <1273592353-23224-6-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1273592353-23224-6-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Konrad Rzeszutek Wilk wrote:
> We put the functions dealing with the operations on
> the SWIOTLB buffer in the header and make those functions non-static.
> 
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  include/linux/swiotlb.h |   22 ++++++++++++++++++++++
>  lib/swiotlb.c           |   28 ++++++++++++----------------
>  2 files changed, 34 insertions(+), 16 deletions(-)
> 
> diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
> index f3fc331..dabfd0b 100644
> --- a/include/linux/swiotlb.h
> +++ b/include/linux/swiotlb.h
> @@ -25,6 +25,28 @@ extern int swiotlb_force;
>  extern void swiotlb_init(int verbose);
>  extern void swiotlb_init_with_tbl(char *tlb, unsigned long nslabs, int verbose);
>  
> +/*
> + * Enumeration for sync targets
> + */
> +enum dma_sync_target {
> +	SYNC_FOR_CPU = 0,
> +	SYNC_FOR_DEVICE = 1,
> +};
> +extern void *swiotlb_tbl_map_single(struct device *hwdev, phys_addr_t phys,
> +				    u64 tbl_dma_addr, size_t size,
> +				    enum dma_data_direction dir);
> +

The phys and tbl_dma_addr arguments in the function prototype are swapped compared to the function definition in patch 1/6.

Cheers,
Albert
