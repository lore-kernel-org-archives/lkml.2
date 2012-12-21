Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603Ab2LUWDU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 17:03:20 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:50893 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949Ab2LUWDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 17:03:17 -0500
Date: Fri, 21 Dec 2012 23:03:15 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Sasha Levin <sasha.levin@oracle.com>
cc: Pekka Enberg <penberg@kernel.org>, Sasha Levin <levinsasha928@gmail.com>,
        Asias He <asias.hejun@gmail.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm tools: remove unneeded checks in qcow code
In-Reply-To: <1356030701-16284-2-git-send-email-sasha.levin@oracle.com>
Message-ID: <alpine.LNX.2.00.1212212301290.6098@swampdragon.chaosbits.net>
References: <1356030701-16284-1-git-send-email-sasha.levin@oracle.com> <1356030701-16284-2-git-send-email-sasha.levin@oracle.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Dec 2012, Sasha Levin wrote:

> We already know q!=NULL at that point, no need to retest.
> 
Right, and even if it was ==NULL then 'free(NULL)' is guaranteed to be a 
NOP, so it would still be fine.

Reviewed-by: Jesper Juhl <jj@chaosbits.net>


> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
> ---
>  tools/kvm/disk/qcow.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/kvm/disk/qcow.c b/tools/kvm/disk/qcow.c
> index ee2992e..64a2550 100644
> --- a/tools/kvm/disk/qcow.c
> +++ b/tools/kvm/disk/qcow.c
> @@ -1361,8 +1361,7 @@ free_header:
>  	if (q->header)
>  		free(q->header);
>  free_qcow:
> -	if (q)
> -		free(q);
> +	free(q);
>  
>  	return NULL;
>  }
> @@ -1492,8 +1491,7 @@ free_header:
>  	if (q->header)
>  		free(q->header);
>  free_qcow:
> -	if (q)
> -		free(q);
> +	free(q);
>  
>  	return NULL;
>  }
> 

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

