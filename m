Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757049Ab2EIHoy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 03:44:54 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:57328 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855Ab2EIHow convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 03:44:52 -0400
MIME-Version: 1.0
In-Reply-To: <CAAGB47MQoLZ1MygiHo7qZsvctk7ECF-9SppKL02Appcacg=bcw@mail.gmail.com>
References: <CAAGB47MQoLZ1MygiHo7qZsvctk7ECF-9SppKL02Appcacg=bcw@mail.gmail.com>
Date: Wed, 9 May 2012 13:14:52 +0530
Message-ID: <CAAGB47PL8YF8FGXM+t5p-Mp9g=Gi-ibORnsZckC+favg4hPf1Q@mail.gmail.com>
Subject: Enabled the interrupts in poll (warning issue)
From: Anbu Manikandan <canbumanikandan@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all,

I am facing an issue in netpoll and ethernet driver in 3.0-RT kernel.

I am running 3.0 RT kernel on ARM target board ( CortexA9 SMP Dual
core). The data transfer happens between a host (CENTOS 5.1) and this
target board through net poll interface. It uses smsc911x driver as
part of this communication.

The board boots fine, but following warning backtrace is observed on
console after some time.
{{{
------------[ cut here ]------------
WARNING: at net/core/netpoll.c:346 netpoll_send_skb_on_dev+0x178/
0x228()
netpoll_send_skb(): eth0 enabled interrupts in poll
(smsc911x_hard_start_xmit+0x0/
0x21c)

Modules linked in:
Backtrace:
 [<8001151c>] (dump_backtrace+0x0/0x114) from [<80382254>]
(dump_stack+0x20/0x24)
 r6:804848ff r5:0000015a r4:9f365da8 r3:00000000
[<80382234>] (dump_stack+0x0/0x24) from [<8002df98>]
(warn_slowpath_common+0x5c/0x74)

[<8002df3c>] (warn_slowpath_common+0x0/0x74) from [<8002e06c>]
 (warn_slowpath_fmt+0x40/0x48)
r8:000000c8 r7:80c33000 r6:9f237000 r5:9f188200 r4:9f356600
r3:00000009
[<8002e02c>] (warn_slowpath_fmt+0x0/0x48) from [<802cb5b0>]
(netpoll_send_skb_on_dev+0x178/0x228)

r3:9f237000 r2:80484912
[<802cb438>] (netpoll_send_skb_on_dev+0x0/0x228) from [<802cb8a8>]
(netpoll_send_udp+0x248/0x250)
[<802cb660>] (netpoll_send_udp+0x0/0x250) from [<801e0a80>]
 ....
}}}

I understood from the backtrace message is that driver transmit code
enables the interrupt in poll.
could anyone please guide me in identifying the root cause of this issue?

Thanks for your help in advance.

Best Regards,
Anbu
