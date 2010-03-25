Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754342Ab0CYLXv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 07:23:51 -0400
Received: from mga09.intel.com ([134.134.136.24]:25363 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752667Ab0CYLXu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 07:23:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.51,306,1267430400"; 
   d="scan'208";a="607484070"
Date: Thu, 25 Mar 2010 12:24:38 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Dan Carpenter <error27@gmail.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       Richard =?iso-8859-1?Q?R=F6jfors?= 
	<richard.rojfors@pelagicore.com>,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] mfd: off by one calculating size
Message-ID: <20100325112437.GB3720@sortiz.org>
References: <20100322121242.GL21571@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100322121242.GL21571@bicker>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,

On Mon, Mar 22, 2010 at 03:12:42PM +0300, Dan Carpenter wrote:
> I'm pretty sure that it should be + 1 here.  It's an off by one, because
> we start counting at zero.
Thanks Dan, patch applied to my for-next branch.

Cheers,
Samuel.


> Signed-off-by: Dan Carpenter <error27@gmail.com>
> ---
> Found by a static checker and untested.  Please review carefully.
> 
> diff --git a/drivers/mfd/timberdale.h b/drivers/mfd/timberdale.h
> index 8d27ffa..902c451 100644
> --- a/drivers/mfd/timberdale.h
> +++ b/drivers/mfd/timberdale.h
> @@ -66,7 +66,7 @@
>  
>  #define CHIPCTLOFFSET	0x800
>  #define CHIPCTLEND	0x8ff
> -#define CHIPCTLSIZE	(CHIPCTLEND - CHIPCTLOFFSET)
> +#define CHIPCTLSIZE	(CHIPCTLEND - CHIPCTLOFFSET + 1)
>  
>  #define INTCOFFSET	0xc00
>  #define INTCEND		0xfff

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
