Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219Ab2CaVfR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 17:35:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52464 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752927Ab2CaVfO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 17:35:14 -0400
Date: Sat, 31 Mar 2012 23:34:23 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Sasha Levin <levinsasha928@gmail.com>, davem@davemloft.net,
        kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: Re: ipv6: tunnel: hang when destroying ipv6 tunnel
Message-ID: <20120331213423.GA21219@redhat.com>
References: <CA+1xoqfA9FMowOmAXYHtkXB+D6FqgjCRREKPOk_m2c9ZCyaN4A@mail.gmail.com> <1333227549.2325.4051.camel@edumazet-glaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1333227549.2325.4051.camel@edumazet-glaptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31, Eric Dumazet wrote:
>
> On Sat, 2012-03-31 at 19:51 +0200, Sasha Levin wrote:
> > Hi all,
> >
> > It appears that a hang may occur when destroying an ipv6 tunnel, which
> > I've reproduced several times in a KVM vm.

kernel version?

> > [ 1561.564172] INFO: task kworker/u:2:3140 blocked for more than 120 seconds.

And nobody else?

It would be nice to know what sysrq-t says, in particular the trace
of khelper thread is interesting.

> Something is wrong here, call_usermodehelper_exec ( ... UMH_WAIT_EXEC)
> should not block forever.

Yes, unless it triggers another request_module()...

Tetsuo, could you please take a look? Unlikely, but may be this
is fixed by your kmod-avoid-deadlock-by-recursive-kmod-call.patch
in -mm ?

Oleg.

