Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756691Ab1DHNA3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 09:00:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5722 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756419Ab1DHNA2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 09:00:28 -0400
Subject: Re: [PATCH] selinux: downgrade two printks to KERN_DEBUG
From: Eric Paris <eparis@redhat.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Stephen Smalley <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
        Eric Paris <eparis@parisplace.org>, linux-kernel@vger.kernel.org
Date: Fri, 08 Apr 2011 09:00:20 -0400
In-Reply-To: <1302253422.7787.2.camel@t41.thuisdomein>
References: <1302253422.7787.2.camel@t41.thuisdomein>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1302267622.3937.3.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

They shouldn't be there at all and it was a big screw up on my part that
they were left in the committed code.  I already applied but haven't
sent or pushed a patch to remove these.  Thanks Paul!

-Eric

On Fri, 2011-04-08 at 11:03 +0200, Paul Bolle wrote:
> A recent (Fedora Rawhide) selinux policy update triggers this error:
>     filename_trans_read: nel=0
> 
> But there seems to be no reason why filename_trans_read() prints this
> message (and a similar message) at KERN_ERR level. So downgrade it to
> KERN_DEBUG level.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> Compile tested only.
> 
>  security/selinux/ss/policydb.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/security/selinux/ss/policydb.c b/security/selinux/ss/policydb.c
> index e7b850a..8e9cc8d10 100644
> --- a/security/selinux/ss/policydb.c
> +++ b/security/selinux/ss/policydb.c
> @@ -1819,7 +1819,7 @@ static int filename_trans_read(struct policydb *p, void *fp)
>  		goto out;
>  	nel = le32_to_cpu(buf[0]);
>  
> -	printk(KERN_ERR "%s: nel=%d\n", __func__, nel);
> +	printk(KERN_DEBUG "%s: nel=%d\n", __func__, nel);
>  
>  	last = p->filename_trans;
>  	while (last && last->next)
> @@ -1857,7 +1857,7 @@ static int filename_trans_read(struct policydb *p, void *fp)
>  			goto out;
>  		name[len] = 0;
>  
> -		printk(KERN_ERR "%s: ft=%p ft->name=%p ft->name=%s\n", __func__, ft, ft->name, ft->name);
> +		printk(KERN_DEBUG "%s: ft=%p ft->name=%p ft->name=%s\n", __func__, ft, ft->name, ft->name);
>  
>  		rc = next_entry(buf, fp, sizeof(u32) * 4);
>  		if (rc)


