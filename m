Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914Ab1JDHfj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 03:35:39 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:7356 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754071Ab1JDHfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 03:35:37 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6488"; a="124414987"
X-IronPort-AV: E=Sophos;i="4.68,482,1312182000"; 
   d="scan'208";a="137522323"
Message-ID: <4E8AB741.9030707@qca.qualcomm.com>
Date: Tue, 4 Oct 2011 10:35:29 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>,
        <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the moduleh tree
References: <20111004180333.44f741dc08063a918c9b581f@canb.auug.org.au>
In-Reply-To: <20111004180333.44f741dc08063a918c9b581f@canb.auug.org.au>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.64.139.57]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/2011 10:03 AM, Stephen Rothwell wrote:
> After merging the moduleh tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> drivers/net/wireless/ath/ath6kl/debug.c:237:11: error: 'THIS_MODULE' undeclared here (not in a function)
> 
> Caused by commit 9a7308341b71 ("ath6kl: silence "invalid rate" warning")
> from the wireless tree interacting with the module.h split.
> 
> I added this patch:

John&Paul, how do we handle this patch?

> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Tue, 4 Oct 2011 18:01:03 +1100
> Subject: [PATCH] ath6kl: THIS_MODULES needs export.h
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  drivers/net/wireless/ath/ath6kl/debug.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath6kl/debug.c b/drivers/net/wireless/ath/ath6kl/debug.c
> index ba3f23d..7879b53 100644
> --- a/drivers/net/wireless/ath/ath6kl/debug.c
> +++ b/drivers/net/wireless/ath/ath6kl/debug.c
> @@ -19,6 +19,7 @@
>  #include <linux/circ_buf.h>
>  #include <linux/fs.h>
>  #include <linux/vmalloc.h>
> +#include <linux/export.h>
>  
>  #include "debug.h"
>  #include "target.h"

Kalle
