Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751782Ab0JKEuW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 00:50:22 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:57185 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791Ab0JKEuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 00:50:21 -0400
X-AuthUser: davidel@xmailserver.org
Date: Sun, 10 Oct 2010 21:49:58 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@davide-laptop
To: Robin Holt <holt@sgi.com>
cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Patch] Convert max_user_watches to long.
In-Reply-To: <20101009075002.GW14068@sgi.com>
Message-ID: <alpine.DEB.2.00.1010102148430.4151@davide-laptop>
References: <20101001200143.GR14064@sgi.com> <alpine.DEB.2.00.1010011335400.2305@ubuntu> <m1vd5ll2hl.fsf@fess.ebiederm.org> <alpine.DEB.2.00.1010020701320.1564@davide-laptop> <20101004194411.GT14068@sgi.com> <alpine.DEB.2.00.1010051841050.1941@ubuntu>
 <20101009075002.GW14068@sgi.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 Oct 2010, Robin Holt wrote:

> @@ -900,11 +902,12 @@ static int ep_insert(struct eventpoll *e
>  {
>  	int error, revents, pwake = 0;
>  	unsigned long flags;
> +	long user_watches;
>  	struct epitem *epi;
>  	struct ep_pqueue epq;
>  
> -	if (unlikely(atomic_read(&ep->user->epoll_watches) >=
> -		     max_user_watches))
> +	user_watches = atomic_long_read(&ep->user->epoll_watches);
> +	if (user_watches >= max_user_watches)
>  		return -ENOSPC;

Is there a particular reason for adding an extra, otherwise unused, 
user_watches variable?


- Davide


