Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935316Ab0HFCgR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 22:36:17 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:53237 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935259Ab0HFCfz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 22:35:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=cxGIX2WntDu+6br29ZVX1piiwWD+q3AqDI85LhNWsYAE/T74ycMuuCDWbSMRPVZ0dA
         KB4V+YIIABw3nGDEntu+3neA4/BPfuv6kwtlxVHIt1YT5H05LGumHj2hzRjwUQZlCFi1
         wtDkGMmoalbJYxGkOb1xnDrJErjKFecH/KLA0=
MIME-Version: 1.0
In-Reply-To: <20100805135149.98b2001b.sfr@canb.auug.org.au>
References: <20100805135149.98b2001b.sfr@canb.auug.org.au>
Date: Thu, 5 Aug 2010 21:35:50 -0500
Message-ID: <AANLkTimW1pwO468c2iHNvEdzt42b-O4PeAKUgqN_30Jk@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the final tree (cifs 
	tree related)
From: Steve French <smfrench@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-cifs@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wang Lei <wang840925@gmail.com>,
        David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The fix for the missing err.h include is merged.   Not sure why I did
not run into that on my Ubuntu test builds or Dave on his builds.

Have not heard any feedback about the init.h change that Ben suggested yet.

On Wed, Aug 4, 2010 at 10:51 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Steve,
>
> After merging the final tree, today's linux-next build (powerpc
> allyesconfig) failed like this:
>
> net/dns_resolver/dns_key.c: In function 'init_dns_resolver':
> net/dns_resolver/dns_key.c:170: error: implicit declaration of function 'IS_ERR'
> net/dns_resolver/dns_key.c:171: error: implicit declaration of function 'PTR_ERR'
> net/dns_resolver/dns_query.c: In function 'dns_query':
> net/dns_resolver/dns_query.c:126: error: implicit declaration of function 'IS_ERR'
> net/dns_resolver/dns_query.c:127: error: implicit declaration of function 'PTR_ERR'
>
> Caused by commit bae8da144bd6254d1e9cec2a7d6da7cade84e00e ("DNS: Separate
> out CIFS DNS Resolver code").
>
> See Rule 1 in Documentation/SubmitChecklist.
>
> I have added this patch for today:
>
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Thu, 5 Aug 2010 13:49:29 +1000
> Subject: [PATCH] cifs: include linux/err.h for IS_ERR and PTR_ERR
>
> Fixes build errors:
>
> net/dns_resolver/dns_key.c: In function 'init_dns_resolver':
> net/dns_resolver/dns_key.c:170: error: implicit declaration of function 'IS_ERR'
> net/dns_resolver/dns_key.c:171: error: implicit declaration of function 'PTR_ERR'
> net/dns_resolver/dns_query.c: In function 'dns_query':
> net/dns_resolver/dns_query.c:126: error: implicit declaration of function 'IS_ERR'
> net/dns_resolver/dns_query.c:127: error: implicit declaration of function 'PTR_ERR'
>
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  net/dns_resolver/dns_key.c   |    1 +
>  net/dns_resolver/dns_query.c |    1 +
>  2 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/net/dns_resolver/dns_key.c b/net/dns_resolver/dns_key.c
> index 1b1b411..400a04d 100644
> --- a/net/dns_resolver/dns_key.c
> +++ b/net/dns_resolver/dns_key.c
> @@ -28,6 +28,7 @@
>  #include <linux/string.h>
>  #include <linux/kernel.h>
>  #include <linux/keyctl.h>
> +#include <linux/err.h>
>  #include <keys/dns_resolver-type.h>
>  #include <keys/user-type.h>
>  #include "internal.h"
> diff --git a/net/dns_resolver/dns_query.c b/net/dns_resolver/dns_query.c
> index 6c0cf31..b33e1f7 100644
> --- a/net/dns_resolver/dns_query.c
> +++ b/net/dns_resolver/dns_query.c
> @@ -39,6 +39,7 @@
>  #include <linux/module.h>
>  #include <linux/slab.h>
>  #include <linux/dns_resolver.h>
> +#include <linux/err.h>
>  #include <keys/dns_resolver-type.h>
>  #include <keys/user-type.h>
>
> --
> 1.7.1
>
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> http://www.canb.auug.org.au/~sfr/
>



-- 
Thanks,

Steve
