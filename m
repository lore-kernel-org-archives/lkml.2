Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750918Ab0HSEAH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 00:00:07 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58238 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758Ab0HSEAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 00:00:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=unCU+6SW7AF6lMK5QsqSmOfVwyH+62Hz1FXgdiaDBeklnZluaV4wEh5eMd4JIKAnHv
         zlAbQbuZHYuCI37anFGN6J+q98Wcr+1styWYoYW8G8ss+Eg6PCk3/f7YQk3m1VDkiZnq
         dkaTw80lY3nUDpNwFXrBhJ53H523rnsDeWOcE=
MIME-Version: 1.0
In-Reply-To: <1282035715.2448.24.camel@edumazet-laptop>
References: <1282029386-2952-1-git-send-email-xiaosuo@gmail.com>
 <1282033817.2448.18.camel@edumazet-laptop> <AANLkTinuUuZSqEzfQAF422x2gYsVLzFQtXZKNLhgw+9g@mail.gmail.com>
 <1282035715.2448.24.camel@edumazet-laptop>
From: Changli Gao <xiaosuo@gmail.com>
Date: Thu, 19 Aug 2010 11:59:42 +0800
Message-ID: <AANLkTinqQ9wXK9Ed3VYTWj_trYJiU+=uTV-FnCxqFvNU@mail.gmail.com>
Subject: Re: [PATCH] netfilter: save the hash of the tuple in the original
 direction for latter use
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Patrick McHardy <kaber@trash.net>, "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 17, 2010 at 5:01 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> I am not sure we must use a long (we really need 4 bytes only), and last
> time I tried to use cmpxchg(), I was being told it was not available on
> all arches.
>
> But seeing it used in kernel/pid.c, maybe its not true anymore (that is,
> __HAVE_ARCH_CMPXCHG is always defined to 1)
>
> Since its a recent change (in kernel/pid.c), I would wait a bit and see
> if an arch maintainer complains ;)
>
>

I searched the code, and found ext4, btrfs, lockdep, perf and trace
all use cmpxchg(). And after this patch serial
(http://linux.derkeiler.com/Mailing-Lists/Kernel/2007-08/msg05032.html)
was merged, maybe cmpxchg() is generic. Is there an SMP processor
doesn't support cmpxchg()?

-- 
Regards,
Changli Gao(xiaosuo@gmail.com)
