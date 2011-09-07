Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838Ab1IGCjB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 22:39:01 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64291 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754462Ab1IGCiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 22:38:54 -0400
Subject: Re: [PATCH] per-cgroup tcp buffer limitation
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Greg Thelen <gthelen@google.com>
Cc: Glauber Costa <glommer@parallels.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, containers@lists.osdl.org, netdev@vger.kernel.org,
        xemul@parallels.com, "David S. Miller" <davem@davemloft.net>,
        Hiroyouki Kamezawa <kamezawa.hiroyu@jp.fujitsu.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
In-Reply-To: <CAHH2K0YJA7vZZ3QNAf63TZOnWhsRUwfuZYfntBL4muZ0G_Vt2w@mail.gmail.com>
References: <1315276556-10970-1-git-send-email-glommer@parallels.com>
	 <CAHH2K0aJxjinSu0Ek6jzsZ5dBmm5mEU-typuwYWYWEudF2F3Qg@mail.gmail.com>
	 <4E664766.40200@parallels.com>
	 <CAHH2K0YJA7vZZ3QNAf63TZOnWhsRUwfuZYfntBL4muZ0G_Vt2w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 07 Sep 2011 04:38:40 +0200
Message-ID: <1315363120.3400.54.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 06 septembre 2011 à 15:12 -0700, Greg Thelen a écrit :

> >>> +#define sk_sockets_allocated(sk)                               \
> >>> +({                                                             \
> >>> +       struct percpu_counter *__p;                             \
> >>> +       __p = (sk)->sk_prot->sockets_allocated(sk->sk_cgrp);    \
> >>> +       __p;                                                    \
> >>> +})
> 
> Could this be simplified as (same applies to following few macros):
> 
> static inline struct percpu_counter *sk_sockets_allocated(struct sock *sk)
> {
>         return sk->sk_prot->sockets_allocated(sk->sk_cgrp);
> }
> 

Please Greg, dont copy/paste huge sequence of code if you dont have
anymore comments.

Right before sending your mail, remove all parts that we already got in
previous mails.

Thanks


