Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709Ab0CVMh7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 08:37:59 -0400
Received: from av6-2-sn3.vrr.skanova.net ([81.228.9.180]:40168 "EHLO
	av6-2-sn3.vrr.skanova.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754336Ab0CVMh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 08:37:57 -0400
Message-ID: <4BA764A2.6080400@pelagicore.com>
Date: Mon, 22 Mar 2010 13:37:54 +0100
From: =?ISO-8859-1?Q?Richard_R=F6jfors?= <richard.rojfors@pelagicore.com>
Organization: Pelagicore AB
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.7) Gecko/20100121 Iceowl/1.0b1 Icedove/3.0.1
MIME-Version: 1.0
To: Dan Carpenter <error27@gmail.com>, Samuel Ortiz <sameo@linux.intel.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] mfd: off by one calculating size
References: <20100322121242.GL21571@bicker>
In-Reply-To: <20100322121242.GL21571@bicker>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2010 01:12 PM, Dan Carpenter wrote:
> I'm pretty sure that it should be + 1 here.  It's an off by one, because
> we start counting at zero.

You are completely right, fortunately we don't access the last register.

> Signed-off-by: Dan Carpenter<error27@gmail.com>

Acked-by: Richard Röjfors <richard.rojfors@pelagicore.com>

> ---
> Found by a static checker and untested.  Please review carefully.
>
> diff --git a/drivers/mfd/timberdale.h b/drivers/mfd/timberdale.h
> index 8d27ffa..902c451 100644
> --- a/drivers/mfd/timberdale.h
> +++ b/drivers/mfd/timberdale.h
> @@ -66,7 +66,7 @@
>
>   #define CHIPCTLOFFSET	0x800
>   #define CHIPCTLEND	0x8ff
> -#define CHIPCTLSIZE	(CHIPCTLEND - CHIPCTLOFFSET)
> +#define CHIPCTLSIZE	(CHIPCTLEND - CHIPCTLOFFSET + 1)
>
>   #define INTCOFFSET	0xc00
>   #define INTCEND		0xfff
