Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031458Ab2CORUO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 13:20:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22223 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751150Ab2CORUL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 13:20:11 -0400
Date: Thu, 15 Mar 2012 14:19:57 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Niklas =?UTF-8?B?U8O2ZGVybHVuZA==?= 
	<niklas.soderlund@ericsson.com>
Cc: <lucas.demarchi@profusion.mobi>, <borislav.petkov@amd.com>,
        <linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <thang.b.nguyen@dektech.com.au>
Subject: Re: [PATCH] edac: i5100 fix erroneous define for M1Err
Message-ID: <20120315141957.2245678a@redhat.com>
In-Reply-To: <1329475014-15589-1-git-send-email-niklas.soderlund@ericsson.com>
References: <1329475014-15589-1-git-send-email-niklas.soderlund@ericsson.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, 17 Feb 2012 11:36:54 +0100
Niklas Söderlund <niklas.soderlund@ericsson.com> escreveu:

> According to [1] the define for M1Err in the FERR_NF_MEM register is
> wrong. It should be at position 1 not 0.
> 
> [1] Intel 5100 Memory Controller Hub Chipset Doc.Nr: 318378
>     http://www.intel.com/content/dam/doc/datasheet/5100-
>     memory-controller-hub-chipset-datasheet.pdf
> 
> Reported-by: Ba Thang Nguyen <thang.b.nguyen@dektech.com.au>
> Signed-off-by: Niklas Söderlund <niklas.soderlund@ericsson.com>
> ---
>  drivers/edac/i5100_edac.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/edac/i5100_edac.c b/drivers/edac/i5100_edac.c
> index bcbdeec..ab2f906 100644
> --- a/drivers/edac/i5100_edac.c
> +++ b/drivers/edac/i5100_edac.c
> @@ -49,7 +49,7 @@
>  #define		I5100_FERR_NF_MEM_M6ERR_MASK	(1 << 6)
>  #define		I5100_FERR_NF_MEM_M5ERR_MASK	(1 << 5)
>  #define		I5100_FERR_NF_MEM_M4ERR_MASK	(1 << 4)
> -#define		I5100_FERR_NF_MEM_M1ERR_MASK	1
> +#define		I5100_FERR_NF_MEM_M1ERR_MASK	(1 << 1)
>  #define		I5100_FERR_NF_MEM_ANY_MASK	\
>  			(I5100_FERR_NF_MEM_M16ERR_MASK | \
>  			I5100_FERR_NF_MEM_M15ERR_MASK | \

Looks fine. I'm applying on my edac -next tree, together with the other fix:

git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-edac.git linux-next

Cheers,
Mauro

