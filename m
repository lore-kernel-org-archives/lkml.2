Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508Ab1JTFIM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 01:08:12 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64636 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869Ab1JTFIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 01:08:10 -0400
Message-ID: <1319087281.8416.45.camel@edumazet-laptop>
Subject: Re: [PATCH] Code clean up for percpu_xxx() functions
From: Eric Dumazet <eric.dumazet@gmail.com>
To: "Alex,Shi" <alex.shi@intel.com>
Cc: Christoph Lameter <cl@gentwo.org>, "tj@kernel.org" <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "avi@redhat.com" <avi@redhat.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        "kaber@trash.net" <kaber@trash.net>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jeremy@xensource.com" <jeremy@xensource.com>
Date: Thu, 20 Oct 2011 07:08:01 +0200
In-Reply-To: <1319078687.23426.146.camel@debian>
References: <1318237851.27949.190.camel@debian>
	 <alpine.DEB.2.00.1110101026080.16264@router.home>
	 <1318324774.27949.693.camel@debian>
	 <alpine.DEB.2.00.1110110910480.3388@router.home>
	 <1318382964.27949.782.camel@debian> <1318428673.29699.13.camel@debian>
	 <alpine.DEB.2.00.1110120910540.26610@router.home>
	 <1318908091.23426.52.camel@debian>
	 <alpine.DEB.2.00.1110180932330.687@router.home>
	 <1319016218.23426.104.camel@debian>
	 <alpine.DEB.2.00.1110191033480.24001@router.home>
	 <1319078687.23426.146.camel@debian>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 20 octobre 2011 à 10:44 +0800, Alex,Shi a écrit :
> > Acked-by: Christoph Lameter <cl@gentwo.org>
> 
> Thanks, Christoph! 
> and resend for code style problem correction. 
> 

Sorry this huge patch brings too many potential bugs.

I ask you a separate patch for the networking part, because I dont want
to Ack all the other parts.

> diff --git a/net/socket.c b/net/socket.c
> index ffe92ca..2845d38 100644
> --- a/net/socket.c
> +++ b/net/socket.c
> @@ -479,7 +479,7 @@ static struct socket *sock_alloc(void)
>  	inode->i_uid = current_fsuid();
>  	inode->i_gid = current_fsgid();
>  
> -	percpu_add(sockets_in_use, 1);
> +	__this_cpu_add(sockets_in_use, 1);

No, we are in process context, you need

	this_cpu_add(sockets_in_use, 1);

>  	return sock;
>  }
>  
> @@ -522,7 +522,7 @@ void sock_release(struct socket *sock)
>  	if (rcu_dereference_protected(sock->wq, 1)->fasync_list)
>  		printk(KERN_ERR "sock_release: fasync list not empty!\n");
>  
> -	percpu_sub(sockets_in_use, 1);
> +	__this_cpu_sub(sockets_in_use, 1);

	this_cpu_sub();

>  	if (!sock->file) {
>  		iput(SOCK_INODE(sock));
>  		return;



