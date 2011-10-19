Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751508Ab1JSSHV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 14:07:21 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:50563 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750937Ab1JSSHT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 14:07:19 -0400
From: Jay Vosburgh <fubar@us.ibm.com>
To: David Miller <davem@davemloft.net>
cc: mitsuo.hayasaka.hu@hitachi.com, andy@greyhouse.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com,
        eric.dumazet@gmail.com, xiyou.wangcong@gmail.com
Subject: Re: [PATCH net -v2] [BUGFIX] bonding: use local function pointer of bond->recv_probe in bond_handle_frame
In-reply-to: <20111019.000311.1490092497677136273.davem@davemloft.net>
References: <20111013020429.3554.78679.stgit@ltc219.sdl.hitachi.co.jp> <20111019.000311.1490092497677136273.davem@davemloft.net>
Comments: In-reply-to David Miller <davem@davemloft.net>
   message dated "Wed, 19 Oct 2011 00:03:11 -0400."
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.2.1
Date: Wed, 19 Oct 2011 10:59:07 -0700
Message-ID: <26928.1319047147@death>
x-cbid: 11101917-3534-0000-0000-000000C37DDA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> wrote:

>From: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
>Date: Thu, 13 Oct 2011 11:04:29 +0900
>
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
>> Cc: Jay Vosburgh <fubar@us.ibm.com>
>> Cc: Andy Gospodarek <andy@greyhouse.net>
>> Cc: Eric Dumazet <eric.dumazet@gmail.com>
>> Cc: WANG Cong <xiyou.wangcong@gmail.com>
>
>Bonding folks please review this, thanks.
>

	Looks reasonable.  Even if by some quirk of timing the
recv_probe function ends up being entered after bond_close has
completed, it doesn't look like there is a risk of those functions
misbehaving (because bond_close doesn't deallocate the data structures).

	-J

Signed-off-by: Jay Vosburgh <fubar@us.ibm.com>

---
	-Jay Vosburgh, IBM Linux Technology Center, fubar@us.ibm.com

