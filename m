Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935215Ab1IOWD4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 18:03:56 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:55492 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934111Ab1IOWDy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 18:03:54 -0400
Subject: Re: linux-next: build failure after merge of the final tree
 (security tree related)
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: James Morris <jmorris@namei.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110915170715.a380a5be954efc5891386ee3@canb.auug.org.au>
References: <20110915170715.a380a5be954efc5891386ee3@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Sep 2011 18:03:51 -0400
Message-ID: <1316124231.3345.29.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-15 at 17:07 +1000, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the final tree, today's linux-next build (powerpc
> allyesconfig) failed like this:
> 
> security/keys/encrypted-keys/masterkey_trusted.c: In function 'request_trusted_key':
> security/keys/encrypted-keys/masterkey_trusted.c:35:2: error: implicit declaration of function 'IS_ERR'
> 
> Caused by commit 982e617a313b ("encrypted-keys: remove trusted-keys
> dependency").  Forgot to include linux/err.h.  See Rule 1 in
> Documentation/SubmitChecklist.
> 
> I have applied the following patch for today.
> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Thu, 15 Sep 2011 17:03:09 +1000
> Subject: [PATCH] encrypted-keys: IS_ERR need include/err.h
> 
> Fixes this build error:
> 
> security/keys/encrypted-keys/masterkey_trusted.c: In function 'request_trusted_key':
> security/keys/encrypted-keys/masterkey_trusted.c:35:2: error: implicit declaration of function 'IS_ERR'
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  security/keys/encrypted-keys/masterkey_trusted.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/security/keys/encrypted-keys/masterkey_trusted.c b/security/keys/encrypted-keys/masterkey_trusted.c
> index a5da512..df87272 100644
> --- a/security/keys/encrypted-keys/masterkey_trusted.c
> +++ b/security/keys/encrypted-keys/masterkey_trusted.c
> @@ -16,6 +16,7 @@
> 
>  #include <linux/uaccess.h>
>  #include <linux/module.h>
> +#include <linux/err.h>
>  #include <keys/trusted-type.h>
> 
>  /*
> -- 
> 1.7.5.4

Thanks Stephen.  James, assuming that the patch needs to be made
available from the security tree, it's available from:

The following changes since commit 8de6ac7f58a22fdab399fbe97763e465ea49c735:

  Merge branch 'next-evm' of git://github.com/mzohar/linux-evm into next (2011-09-15 09:53:38 +1000)

are available in the git repository at:

  git://github.com/mzohar/linux-evm.git next-for-james

Stephen Rothwell (1):
      encrypted-keys: IS_ERR need include/err.h

 security/keys/encrypted-keys/masterkey_trusted.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

thanks,

Mimi

