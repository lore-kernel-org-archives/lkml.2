Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268Ab1AUAHT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 19:07:19 -0500
Received: from tundra.namei.org ([65.99.196.166]:53583 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752356Ab1AUAHS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 19:07:18 -0500
Date: Fri, 21 Jan 2011 11:07:13 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Davidlohr Bueso <dave@gnu.org>
cc: Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>,
        LKML <linux-kernel@vger.kernel.org>, selinux@tycho.nsa.gov
Subject: Re: [PATCH 1/3] selinux: return -ENOMEM when memory allocation
 fails
In-Reply-To: <1295548318.2089.11.camel@offworld>
Message-ID: <alpine.LRH.2.00.1101211101150.14355@tundra.namei.org>
References: <1295548318.2089.11.camel@offworld>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Jan 2011, Davidlohr Bueso wrote:

> From: Davidlohr Bueso <dave@gnu.org>
> 
> Signed-off-by: Davidlohr Bueso <dave@gnu.org>
> ---
>  security/selinux/ss/conditional.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/security/selinux/ss/conditional.c b/security/selinux/ss/conditional.c
> index c3f845c..a533732 100644
> --- a/security/selinux/ss/conditional.c
> +++ b/security/selinux/ss/conditional.c
> @@ -178,7 +178,7 @@ int cond_init_bool_indexes(struct policydb *p)
>  	p->bool_val_to_struct = (struct cond_bool_datum **)
>  		kmalloc(p->p_bools.nprim * sizeof(struct cond_bool_datum *), GFP_KERNEL);
>  	if (!p->bool_val_to_struct)
> -		return -1;
> +		return -ENOMEM;
>  	return 0;

The caller has already set -ENOMEM, so the code should probably be updated 
there, too, e.g.

	rc = cond_init_bool_indexes();
	if (rc)
		goto out;



-- 
James Morris
<jmorris@namei.org>
