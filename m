Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754441Ab2FSObq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 10:31:46 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:43965 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754354Ab2FSObn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 10:31:43 -0400
Message-ID: <4FE08D1A.5060400@linux.vnet.ibm.com>
Date: Tue, 19 Jun 2012 09:30:50 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH 03/10] zcache: fix a compile warning
References: <4FE0392E.3090300@linux.vnet.ibm.com> <4FE03961.5050001@linux.vnet.ibm.com>
In-Reply-To: <4FE03961.5050001@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12061914-2398-0000-0000-000007A81DB1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2012 03:33 AM, Xiao Guangrong wrote:

> fix:
> 
> drivers/staging/zcache/zcache-main.c: In function ‘zcache_comp_op’:
> drivers/staging/zcache/zcache-main.c:112:2: warning: ‘ret’ may be used uninitial
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> ---
>  drivers/staging/zcache/zcache-main.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/staging/zcache/zcache-main.c b/drivers/staging/zcache/zcache-main.c
> index 32fe0ba..74a3ac8 100644
> --- a/drivers/staging/zcache/zcache-main.c
> +++ b/drivers/staging/zcache/zcache-main.c
> @@ -93,7 +93,7 @@ static inline int zcache_comp_op(enum comp_op op,
>  				u8 *dst, unsigned int *dlen)
>  {
>  	struct crypto_comp *tfm;
> -	int ret;
> +	int ret = -1;
> 
>  	BUG_ON(!zcache_comp_pcpu_tfms);
>  	tfm = *per_cpu_ptr(zcache_comp_pcpu_tfms, get_cpu());


What about adding a default case in the switch like this?

default:
	ret = -EINVAL;

That way we don't assign ret twice.

--
Seth

