Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753756Ab1JSEPz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 00:15:55 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:35112 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227Ab1JSEPy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 00:15:54 -0400
Date: Wed, 19 Oct 2011 00:14:47 -0400 (EDT)
Message-Id: <20111019.001447.91777553130308365.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: mitsuo.hayasaka.hu@hitachi.com, fubar@us.ibm.com, andy@greyhouse.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com, xiyou.wangcong@gmail.com
Subject: Re: [PATCH net -v2] [BUGFIX] bonding: use local function pointer
 of bond->recv_probe in bond_handle_frame
From: David Miller <davem@davemloft.net>
In-Reply-To: <1318997127.19139.14.camel@edumazet-laptop>
References: <20111013020429.3554.78679.stgit@ltc219.sdl.hitachi.co.jp>
	<1318997127.19139.14.camel@edumazet-laptop>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 18 Oct 2011 21:14:49 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Wed, 19 Oct 2011 06:05:27 +0200

> Le jeudi 13 octobre 2011 à 11:04 +0900, Mitsuo Hayasaka a écrit :
>> The bond->recv_probe is called in bond_handle_frame() when
>> a packet is received, but bond_close() sets it to NULL. So,
>> a panic occurs when both functions work in parallel.
>> 
>> Why this happen:
>> After null pointer check of bond->recv_probe, an sk_buff is
>> duplicated and bond->recv_probe is called in bond_handle_frame.
>> So, a panic occurs when bond_close() is called between the
>> check and call of bond->recv_probe.
>> 
>> Patch:
>> This patch uses a local function pointer of bond->recv_probe
>> in bond_handle_frame(). So, it can avoid the null pointer
>> dereference.
>> 
>> 
>> Signed-off-by: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
 ...
> Sorry, I forgot to add my official ack. Even if not a perfect patch, its
> a step into right direction.
> 
> Acked-by: Eric Dumazet <eric.dumazet@gmail.com>

Thanks for reviewing Eric, applied.
