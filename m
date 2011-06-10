Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753134Ab1FJQih (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 12:38:37 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:57260 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885Ab1FJQig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 12:38:36 -0400
Message-ID: <4DF24868.3040900@vflare.org>
Date: Fri, 10 Jun 2011 09:38:00 -0700
From: Nitin Gupta <ngupta@vflare.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Jerome Marchand <jmarchan@redhat.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>,
        Linux Kernel List <linux-kernel@vger.kernel.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 1/4] Staging: zram: Remove useless offset calculation
 in handle_uncompressed_page()
References: <1307712529-9757-1-git-send-email-jmarchan@redhat.com>
In-Reply-To: <1307712529-9757-1-git-send-email-jmarchan@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2011 06:28 AM, Jerome Marchand wrote:
> The offset of uncompressed page is always zero: handle_uncompressed_page()
> doesn't have to care about it.
>
> Signed-off-by: Jerome Marchand<jmarchan@redhat.com>
> ---
>   drivers/staging/zram/zram_drv.c |    3 +--
>   1 files changed, 1 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
> index aab4ec4..3305e1a 100644
> --- a/drivers/staging/zram/zram_drv.c
> +++ b/drivers/staging/zram/zram_drv.c
> @@ -194,8 +194,7 @@ static void handle_uncompressed_page(struct zram *zram,
>   	unsigned char *user_mem, *cmem;
>
>   	user_mem = kmap_atomic(page, KM_USER0);
> -	cmem = kmap_atomic(zram->table[index].page, KM_USER1) +
> -			zram->table[index].offset;
> +	cmem = kmap_atomic(zram->table[index].page, KM_USER1);
>
>   	memcpy(user_mem, cmem, PAGE_SIZE);
>   	kunmap_atomic(user_mem, KM_USER0);


kmap/kunmap requests needs to be strictly nested, so here kunmap(..., 
KM_USER1) must be done before kunmap(..., KM_USER0). This needs to be
fixed in zram_bvec_read() also.  Though these bugs are not introduced
by your patches, it would be nice to have them include them in your 
patch series only.

Thanks for the fixes.
Nitin

