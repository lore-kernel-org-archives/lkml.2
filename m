Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607Ab2CaVnm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 17:43:42 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48728 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753063Ab2CaVnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 17:43:40 -0400
MIME-Version: 1.0
In-Reply-To: <20120331213423.GA21219@redhat.com>
References: <CA+1xoqfA9FMowOmAXYHtkXB+D6FqgjCRREKPOk_m2c9ZCyaN4A@mail.gmail.com>
 <1333227549.2325.4051.camel@edumazet-glaptop> <20120331213423.GA21219@redhat.com>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Sat, 31 Mar 2012 23:43:19 +0200
Message-ID: <CA+1xoqcAXyh306=2=QKWyM3BE44=MT+nsuRQn5YLOLgbtZqicA@mail.gmail.com>
Subject: Re: ipv6: tunnel: hang when destroying ipv6 tunnel
To: Oleg Nesterov <oleg@redhat.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, davem@davemloft.net,
        kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 31, 2012 at 11:34 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 03/31, Eric Dumazet wrote:
>>
>> On Sat, 2012-03-31 at 19:51 +0200, Sasha Levin wrote:
>> > Hi all,
>> >
>> > It appears that a hang may occur when destroying an ipv6 tunnel, which
>> > I've reproduced several times in a KVM vm.
>
> kernel version?

latest linux-next

>> > [ 1561.564172] INFO: task kworker/u:2:3140 blocked for more than 120 seconds.
>
> And nobody else?

Some more messages follow a bit later which get stuck in vfs related code.

> It would be nice to know what sysrq-t says, in particular the trace
> of khelper thread is interesting.

Sure, I'll get one when it happens again.

>> Something is wrong here, call_usermodehelper_exec ( ... UMH_WAIT_EXEC)
>> should not block forever.
>
> Yes, unless it triggers another request_module()...
>
> Tetsuo, could you please take a look? Unlikely, but may be this
> is fixed by your kmod-avoid-deadlock-by-recursive-kmod-call.patch
> in -mm ?
>
> Oleg.
>
