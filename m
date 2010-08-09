Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755311Ab0HITc4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 15:32:56 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:52814 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755061Ab0HITcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 15:32:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=E8n2/1lGruLx1HSKg/kcSC9oqzq7wqu7D68hMVaidWHfisApgKckM1MKUfAiuNm8Be
         lKwGrPCDVPG1nh+d7b6AlAkWC5PRQE1G7lHvh/vQBXfYEBrsxj2KkacFi0BIvMrig+6O
         fL8bjZ15YF0tjV6dvJPd7KkHz+0dU0ZSC5DqE=
Date: Mon, 9 Aug 2010 23:32:46 +0400
From: Vasiliy Kulikov <segooon@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: herbert@gondor.hengli.com.au, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: n2 RNG driver bogus cast removal
Message-ID: <20100809193246.GA11374@albatros>
References: <20100809.004514.73697921.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100809.004514.73697921.davem@davemloft.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 09, 2010 at 00:45 -0700, David Miller wrote:
> 
> Kulikov, can you at least build test your patches?  Casts are not
> always incorrect, particularly when private cookies are "unsigned
> long" as is the case here:
> 
> drivers/char/hw_random/n2-drv.c: In function ‘n2rng_data_read’:
> drivers/char/hw_random/n2-drv.c:390: warning: initialization makes pointer from integer without a cast
Ahh, shame on me... I'd compiled this on x86 and looked through error
log, I wrongly pointed out that there is no error at this line. As I see
now, this tactic is incorrect. I'd not do this any more, sorry for
this...

> 
> Herbert, please revert this change, thanks.  And I suspect there
> might be more of these hwrng driver duds that went into the tree,
> it's worth checking out. :-)
> 
> Thanks.
> 
> commit 8b9cfdca9c52f7d39c3ccfac1668e31c20c9f42e
> Author: Kulikov Vasiliy <segooon@gmail.com>
> Date:   Mon Jul 5 21:25:06 2010 +0800
> 
>     hwrng: n2-drv - remove casts from void*
>     
>     Remove unnesessary casts from void*.
>     
>     Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
>     Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 
