Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932104Ab1BWInv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 03:43:51 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:32885 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754806Ab1BWInu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 03:43:50 -0500
X-Sasl-enc: YSy66E8x/wc/7MrN6OVV/zYZXGkMb9DxibOV93lZA4lH 1298450629
Message-ID: <4D64C8C4.7070404@fastmail.fm>
Date: Wed, 23 Feb 2011 08:43:48 +0000
From: Jack Stone <jwjstone@fastmail.fm>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; en-GB; rv:1.9.2.13) Gecko/20101207 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
CC: axboe@kernel.dk, mikem@beardog.cce.hp.com, akpm@linux-foundation.org,
        thenzl@redhat.com, linux-kernel@vger.kernel.org, smcameron@yahoo.com
Subject: Re: [PATCH 3/6] cciss: Mask off error bits of c->busaddr in	cmd_special_free
 when calling pci_free_consistent
References: <20110222201025.21961.82560.stgit@beardog.cce.hp.com> <20110222201426.21961.97588.stgit@beardog.cce.hp.com>
In-Reply-To: <20110222201426.21961.97588.stgit@beardog.cce.hp.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/02/2011 20:14, Stephen M. Cameron wrote:
> From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> 
> Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> ---
>  drivers/block/cciss.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
> index 2e832b0..03cead6 100644
> --- a/drivers/block/cciss.c
> +++ b/drivers/block/cciss.c
> @@ -193,7 +193,7 @@ static int __devinit cciss_find_cfg_addrs(struct pci_dev *pdev,
>  	u64 *cfg_offset);
>  static int __devinit cciss_pci_find_memory_BAR(struct pci_dev *pdev,
>  	unsigned long *memory_bar);
> -
> +static inline u32 cciss_tag_discard_error_bits(ctlr_info_t *h, u32 tag);

Is there any reason we cannot just reorder the functions rather than
have this forward declaration?

Thanks,

Jack
