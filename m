Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815Ab0JaDdI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 23:33:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21637 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753764Ab0JaDdG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 23:33:06 -0400
Subject: Re: [PATCH] SELinux: Do not assign the same value twice to the
 same variable
From: Eric Paris <eparis@redhat.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, Stephen Smalley <sds@tycho.nsa.gov>,
        James Morris <jmorris@namei.org>, Eric Paris <eparis@parisplace.org>,
        Stephen Hemminger <shemminger@vyatta.com>, ulia Lawall <julia@diku.dk>,
        linux-security-module@vger.kernel.org
In-Reply-To: <alpine.LNX.2.00.1010302306230.1572@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1010302306230.1572@swampdragon.chaosbits.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 30 Oct 2010 23:32:44 -0400
Message-ID: <1288495964.3017.37.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-10-30 at 23:10 +0200, Jesper Juhl wrote:
> Hi,
> 
> It makes little sense to assign the same value to the same variable twice 
> when there is no code inbetween which could have changed the value of that 
> variable.

I don't like the patch.  The compiler will optimize it away (actually it
will optimize both of them away) and it make it clear that if a new
block is added in the middle that error codes can't be wrong....

It's just a personal preference I guess, but I like always setting the
error code before goto outs.  Is there a reason doing this is a problem?

-Eric
> 
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
> Untested patch below.
> 
>  policydb.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/security/selinux/ss/policydb.c b/security/selinux/ss/policydb.c
> index 94f630d..e5a30ff 100644
> --- a/security/selinux/ss/policydb.c
> +++ b/security/selinux/ss/policydb.c
> @@ -1866,7 +1866,6 @@ static int genfs_read(struct policydb *p, void *fp)
>  			if (!newc)
>  				goto out;
>  
> -			rc = -ENOMEM;
>  			newc->u.name = kmalloc(len + 1, GFP_KERNEL);
>  			if (!newc->u.name)
>  				goto out;
> 
> 


