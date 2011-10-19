Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751813Ab1JSEEX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 00:04:23 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:40812 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440Ab1JSEEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 00:04:21 -0400
Date: Wed, 19 Oct 2011 00:03:11 -0400 (EDT)
Message-Id: <20111019.000311.1490092497677136273.davem@davemloft.net>
To: mitsuo.hayasaka.hu@hitachi.com
Cc: fubar@us.ibm.com, andy@greyhouse.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com,
        eric.dumazet@gmail.com, xiyou.wangcong@gmail.com
Subject: Re: [PATCH net -v2] [BUGFIX] bonding: use local function pointer
 of bond->recv_probe in bond_handle_frame
From: David Miller <davem@davemloft.net>
In-Reply-To: <20111013020429.3554.78679.stgit@ltc219.sdl.hitachi.co.jp>
References: <20111013020429.3554.78679.stgit@ltc219.sdl.hitachi.co.jp>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 18 Oct 2011 21:03:13 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Date: Thu, 13 Oct 2011 11:04:29 +0900

> The bond->recv_probe is called in bond_handle_frame() when
> a packet is received, but bond_close() sets it to NULL. So,
> a panic occurs when both functions work in parallel.
> 
> Why this happen:
> After null pointer check of bond->recv_probe, an sk_buff is
> duplicated and bond->recv_probe is called in bond_handle_frame.
> So, a panic occurs when bond_close() is called between the
> check and call of bond->recv_probe.
> 
> Patch:
> This patch uses a local function pointer of bond->recv_probe
> in bond_handle_frame(). So, it can avoid the null pointer
> dereference.
> 
> 
> Signed-off-by: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
> Cc: Jay Vosburgh <fubar@us.ibm.com>
> Cc: Andy Gospodarek <andy@greyhouse.net>
> Cc: Eric Dumazet <eric.dumazet@gmail.com>
> Cc: WANG Cong <xiyou.wangcong@gmail.com>

Bonding folks please review this, thanks.
