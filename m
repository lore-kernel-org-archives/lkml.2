Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754442Ab0J3PAV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 11:00:21 -0400
Received: from mx1.vsecurity.com ([209.67.252.12]:52207 "EHLO
	mx1.vsecurity.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752794Ab0J3PAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 11:00:19 -0400
Subject: Re: [PATCH] ipc: shm: fix information leak to userland
From: Dan Rosenberg <drosenberg@vsecurity.com>
To: segooon@gmail.com
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1288450677.3964.1.camel@dan>
References: <1288450677.3964.1.camel@dan>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 30 Oct 2010 11:00:14 -0400
Message-ID: <1288450814.3964.3.camel@dan>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This one already got taken care of by Kees Cook:

http://lkml.org/lkml/2010/10/6/486

Thanks,
Dan

> Structure shmid_ds is copied to userland with shm_unused{,2,3}
> fields unitialized.  It leads to leaking of contents of kernel stack
> memory.
> Cc: stable@kernel.org
> Acked-by: Al Viro <viro@ZenIV.linux.org.uk>
> Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
> ---
>  Compile tested.
>  ipc/shm.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> diff --git a/ipc/shm.c b/ipc/shm.c
> index fd658a1..7d3bb22 100644
> --- a/ipc/shm.c
> +++ b/ipc/shm.c
> @@ -479,6 +479,7 @@ static inline unsigned long copy_shmid_to_user(void __user *buf, struct shmid64_
>  	    {
>  		struct shmid_ds out;
>  
> +		memset(&out, 0, sizeof(out));
>  		ipc64_perm_to_ipc_perm(&in->shm_perm, &out.shm_perm);
>  		out.shm_segsz	= in->shm_segsz;
>  		out.shm_atime	= in->shm_atime;


