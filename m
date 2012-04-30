Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257Ab2D3Dn3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 23:43:29 -0400
Received: from uhura.skim.hs-owl.de ([193.174.118.81]:57332 "EHLO
	uhura.skim.hs-owl.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755082Ab2D3Dn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 23:43:27 -0400
Message-ID: <4F9E0A49.8090201@googlemail.com>
Date: Mon, 30 Apr 2012 05:43:05 +0200
From: Jan Seiffert <kaffeemonster@googlemail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120327 Firefox/11.0 SeaMonkey/2.8
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: David Miller <davem@davemloft.net>, <eric.dumazet@gmail.com>,
        <matt@ozlabs.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [REGRESSION][PATCH V4 3/3] bpf jit: Let the powerpc jit handle
 negative offsets
References: <4F75CA89.4010709@googlemail.com>  <4F75D2A5.7060407@googlemail.com>  <20120403.180302.342779808900865443.davem@davemloft.net>  <1333491102.3040.12.camel@pasglop> <1335753820.20866.27.camel@pasglop>
In-Reply-To: <1335753820.20866.27.camel@pasglop>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Skim-SendBy: exchange.hs-owl.de on Mon, 30 Apr 2012 05:43:19 +0200
X-SA-Exim-Connect-IP: 193.174.118.178
X-SA-Exim-Mail-From: kaffeemonster@googlemail.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt schrieb:
> On Wed, 2012-04-04 at 08:11 +1000, Benjamin Herrenschmidt wrote:
>> On Tue, 2012-04-03 at 18:03 -0400, David Miller wrote:
>> 
>>>> Signed-off-by: Jan Seiffert <kaffeemonster@googlemail.com>
>>>> 
>>>> I have only compile tested this, -ENOHARDWARE. Can someone with
>>>> more powerpc kung-fu review and maybe test this? Esp. powerpc
>>>> asm is not my strong point. I think i botched the stack frame
>>>> in the call setup. Help?
>>> 
>>> I'm not applying this until a powerpc person tests it.
>>> 
>>> Also, we have an ARM JIT in the tree which probably needs to be
>>> fixed similarly.
>> 
>> Matt's having a look at powerpc
> 
> Ok, he hasn't so I'll dig a bit.
> 

That would be great Benjamin!

> No obvious wrongness (but I'm not very familiar with bpf),

As long as you know PPC ASM you are my man ;-)

> though I do have a comment: sk_negative_common() and
> bpf_slow_path_common() should be made one and single macro which
> takes the fallback function as an argument.
> 

I don't know if this is possible.
The return value is different (one returns 0 on success, the other != 0,
the return value of != is needed). I didn't wanted to change to much,
because i'm not fluent in ppc.

> I'll mess around & try to test using Jan test case & will come back 
> with an updated patch.
> 

Would be great!

> Cheers, Ben.
> 

Greetings
	Jan

-- 
A UDP packet walks into a
