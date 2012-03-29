Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760128Ab2C2WO2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 18:14:28 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:44455 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753978Ab2C2WOV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 18:14:21 -0400
Date: Thu, 29 Mar 2012 18:13:11 -0400 (EDT)
Message-Id: <20120329.181311.91358289912662112.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: zhuangfeiran@ict.ac.cn, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix a bug in emitting the 16-bit immediate operand of
 AND
From: David Miller <davem@davemloft.net>
In-Reply-To: <1333021525.3402.22.camel@edumazet-laptop>
References: <4F742AE4.6050006@ict.ac.cn>
	<1333021525.3402.22.camel@edumazet-laptop>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 29 Mar 2012 15:13:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Thu, 29 Mar 2012 13:45:25 +0200

> Le jeudi 29 mars 2012 à 17:27 +0800, zhuangfeiran@ict.ac.cn a écrit :
>> When K >= 0xFFFF0000, AND needs the two least significant bytes of K as
>> its operand, but EMIT2() gives it the least significant byte of K and
>> 0x2. EMIT() should be used here to replace EMIT2().
>> 
>> Signed-off-by: Feiran Zhuang  <zhuangfeiran@ict.ac.cn>
>> ---
>>  arch/x86/net/bpf_jit_comp.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>> 
>> diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
>> index 5671752..5a5b6e4 100644
>> --- a/arch/x86/net/bpf_jit_comp.c
>> +++ b/arch/x86/net/bpf_jit_comp.c
>> @@ -289,7 +289,7 @@ void bpf_jit_compile(struct sk_filter *fp)
>>  					EMIT2(0x24, K & 0xFF); /* and imm8,%al */
>>  				} else if (K >= 0xFFFF0000) {
>>  					EMIT2(0x66, 0x25);	/* and imm16,%ax */
>> -					EMIT2(K, 2);
>> +					EMIT(K, 2);
>>  				} else {
>>  					EMIT1_off32(0x25, K);	/* and imm32,%eax */
>>  				}
> 
> Good catch, thanks !
> 
> Acked-by: Eric Dumazet <eric.dumazet@gmail.com>

Applied.
