Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757840Ab0IUAEf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 20:04:35 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:41904 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757697Ab0IUAEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 20:04:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=AklcahnQ/+VjOsJ17aL788jkzjsgtFTY4rVRwmWa2LI16DJOAdOs3joUmzO4LG49dV
         0hXMsKeEaP772aAhhAqXlSBS63r66P7Fin5ow+RInfrLhawLLye1ld9bC5fFwjzbboKq
         7BDSa/9/2cSDHft8omFmOZEUkeQ5wDf6+a31A=
MIME-Version: 1.0
In-Reply-To: <4C979515.4060908@trash.net>
References: <1282344540-5306-1-git-send-email-xiaosuo@gmail.com>
 <4C91B6BE.8020300@trash.net> <AANLkTikZeFrS9pj6jxmOxqY6dsaAf1U+FAXe5jNwQ-nV@mail.gmail.com>
 <4C979515.4060908@trash.net>
From: Changli Gao <xiaosuo@gmail.com>
Date: Tue, 21 Sep 2010 08:02:43 +0800
Message-ID: <AANLkTi=NXj9PjYA06+UFYms8q5K3Z4DsPMcpVHpj7Gmq@mail.gmail.com>
Subject: Re: [PATCH v5 2/2] netfilter: save the hash of the tuple in the
 original direction for latter use
To: Patrick McHardy <kaber@trash.net>
Cc: "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        akpm@linux-foundation.org, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 21, 2010 at 1:08 AM, Patrick McHardy <kaber@trash.net> wrote:
>
> Sure we can, dropping unconfirmed conntracks is a rare exception,
> not a common case. Even under DoS we usually drop *unassured*
> conntracks, which have already enterered the hash. If we're unable
> to do that, we won't even allocate a new conntrack.
>

Even so, saving the hash of the reply tuple isn't a good idea.

If NAT is turned on, the current code is:

mangle the reply tuple -> compute the hash of the reply tuple ->
insert into the conntrack hash table.

the new code is

compute the hash of the reply tuple -> mangle the reply tuple ->
recompute the hash of the reply tuple -> insert into the conntrack
hash table.

As you see, the hash computing is done twice, and we use more CPU
cycles than before.

-- 
Regards,
Changli Gao(xiaosuo@gmail.com)
