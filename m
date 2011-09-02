Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933176Ab1IBFye (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 01:54:34 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52949 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758148Ab1IBFyc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 01:54:32 -0400
MIME-Version: 1.0
In-Reply-To: <5187.1314890079@turing-police.cc.vt.edu>
References: <5187.1314890079@turing-police.cc.vt.edu>
Date: Fri, 2 Sep 2011 13:54:32 +0800
Message-ID: <CAM_iQpUVVr70xU1uQBDNvCkewCeWwXmdr8dEZ4Z1-SdSfj03Lg@mail.gmail.com>
Subject: Re: linux-next 20110831 - netconsole startup issue
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Valdis.Kletnieks@vt.edu
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 1, 2011 at 11:14 PM,  <Valdis.Kletnieks@vt.edu> wrote:
> Chasing a kernel panic in linux-next, and hit an unrelated issue
> starting up netconsole that's bogging me down.
>
> On linux-next-20110823, I had this:
>
> [    7.078099] e1000e: Intel(R) PRO/1000 Network Driver - 1.5.1-k
> [    7.078102] e1000e: Copyright(c) 1999 - 2011 Intel Corporation.
> [    7.078158] e1000e 0000:00:19.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
> [    7.078171] e1000e 0000:00:19.0: setting latency timer to 64
> [    7.078354] e1000e 0000:00:19.0: irq 46 for MSI/MSI-X
> [    7.269439] e1000e 0000:00:19.0: eth0: (PCI Express:2.5GT/s:Width x1) 00:21:70:de:b6:fd
> [    7.269443] e1000e 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
> [    7.269469] e1000e 0000:00:19.0: eth0: MAC: 7, PHY: 8, PBA No: 4003FF-0FF
> [    7.293569] netconsole: network logging started
>
> Bring up the ethernet, then the console. Works great,
>
> However, on -20110831, I get this:
>
> [    0.983149] netconsole: local port 9909
> [    0.983254] netconsole: local IP 128.173.14.107
> [    0.983358] netconsole: interface 'eth0'
> [    0.983461] netconsole: remote port 9909
> [    0.983564] netconsole: remote IP 128.173.14.108
> [    0.983668] netconsole: remote ethernet address 00:14:22:5a:79:d3
> [    0.983776] netconsole: eth0 doesn't exist, aborting.
> [    0.983897] netconsole: cleaning up
> [    1.176429] e1000e 0000:00:19.0: eth0: (PCI Express:2.5GT/s:Width x1) 00:21:70:de:b6:fd
> [    1.176557] e1000e 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
> [    1.176688] e1000e 0000:00:19.0: eth0: MAC: 7, PHY: 8, PBA No: 4003FF-0FF
>
> Whoops. No netconsole.

This is because your eth0 came up after netconsole, I guess
you need to wait for some seconds to let eth0 come up before
activating netconsole.

But I don't see any changes of netconsole between 20110823
and 20110831...
