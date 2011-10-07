Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759975Ab1JGNYy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 09:24:54 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50697 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889Ab1JGNYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 09:24:52 -0400
MIME-Version: 1.0
In-Reply-To: <20111007124954.7089.9776.stgit@ltc219.sdl.hitachi.co.jp>
References: <20111007124925.7089.27260.stgit@ltc219.sdl.hitachi.co.jp>
	<20111007124954.7089.9776.stgit@ltc219.sdl.hitachi.co.jp>
Date: Fri, 7 Oct 2011 21:24:51 +0800
Message-ID: <CAM_iQpXZmX2GPb99tF7xMEup52o8AfeUi+0awvHr7C9LVWTjEg@mail.gmail.com>
Subject: Re: [RFC PATCH net 1/2] [BUGFIX] bonding: use local function pointer
 of bond->recv_probe in bond_handle_frame
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Cc: Jay Vosburgh <fubar@us.ibm.com>, Andy Gospodarek <andy@greyhouse.net>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 7, 2011 at 8:49 PM, Mitsuo Hayasaka
<mitsuo.hayasaka.hu@hitachi.com> wrote:
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

Hmm, I don't doubt it can fix the problem, I am wondering if
bond->recv_probe should be protected by bond->lock...
