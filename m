Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757724Ab1CONLp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 09:11:45 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56503 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757553Ab1CONLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 09:11:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=YYgx4QXKTtOXTJrDSu3soATpkeZlP/djs0V/zPnt8kpoqjU+Fb1D2xrnfExOYjrGaM
         e+YkdW9DTb1AU1YPSaq63pJ3ZMCUVSCGtTbJWe/mOcyyCAhi8cs66YS4RfJZLEI3Fs02
         Vb825r/F6mpD5zVGLTnq8GTLt3lghNhrexJiU=
Subject: Re: [PATCH V4 1/1] rcu: introduce kfree_rcu()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Manfred Spraul <manfred@colorfullife.com>
In-Reply-To: <4D7F356C.8020903@cn.fujitsu.com>
References: <4D7F356C.8020903@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 Mar 2011 14:11:33 +0100
Message-ID: <1300194693.10062.15.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 15 mars 2011 à 17:46 +0800, Lai Jiangshan a écrit :


> --- a/kernel/rcutiny.c
> +++ b/kernel/rcutiny.c
> @@ -167,7 +167,7 @@ static void rcu_process_callbacks(struct rcu_ctrlblk *rcp)
>  		prefetch(next);
>  		debug_rcu_head_unqueue(list);
>  		local_bh_disable();
> -		list->func(list);
> +		__rcu_reclaim(list);
>  		local_bh_enable();
>  		list = next;
>  		RCU_TRACE(cb_count++);

Paul, I am just wondering why we disable BH before calling list->func()

This should be done in callbacks that really need it ?

At least the disable/enable pair is not necessary before calling kfree()



