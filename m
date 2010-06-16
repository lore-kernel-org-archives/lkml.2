Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758782Ab0FPK3y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 06:29:54 -0400
Received: from ns.store20.com ([212.7.7.16]:32867 "EHLO store20.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753147Ab0FPK3x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 06:29:53 -0400
X-Greylist: delayed 342 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Jun 2010 06:29:52 EDT
Subject: IMAP through SSH tunnels stopped working in 2.6.35
From: Priit Laes <plaes@plaes.org>
To: linux-netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 16 Jun 2010 13:24:07 +0300
Message-ID: <1276683847.3874.25.camel@chi>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I recently tried out 2.6.35-rc3 kernel (latest Linus's tree), where I
noticed that I couldn't access my IMAP accounts through ssh tunnel
anymore because connection timeouts. Things used to work in 2.6.34-rc7+.

I also tested with two wireless card: b43 and iwl3945, so it isn't
driver related issue.

I'm creating tunnel using: `ssh -L 10443:server:993 server`, and then
use imap client to connect localhost:10443.

Strace log of failing ssh tunnel:

[snip]
accept(5, {sa_family=AF_INET, sin_port=htons(50055), sin_addr=inet_addr("127.0.0.1")}, [16]) = 17
getsockopt(17, SOL_TCP, TCP_NODELAY, [0], [4]) = 0
setsockopt(17, SOL_TCP, TCP_NODELAY, [1], 4) = 0
fcntl(17, F_SETFD, FD_CLOEXEC)          = 0
ioctl(17, SNDCTL_TMR_TIMEBASE or TCGETS, 0x7fff50ed3c30) = -1 EINVAL (Invalid argument)
fcntl(17, F_GETFL)                      = 0x2 (flags O_RDWR)
fcntl(17, F_SETFL, O_RDWR|O_NONBLOCK)   = 0
fcntl(17, F_GETFL)                      = 0x802 (flags O_RDWR|O_NONBLOCK)
getpeername(17, {sa_family=AF_INET, sin_port=htons(50055), sin_addr=inet_addr("127.0.0.1")}, [16]) = 0
getpeername(17, {sa_family=AF_INET, sin_port=htons(50055), sin_addr=inet_addr("127.0.0.1")}, [16]) = 0
...lots of write, select...
-------- Here  i tried to exit evolution -----------
select(18, [3 4 5 6 9 11 13 14 15 16 17], [10 12], NULL, NULL) = 1 (in [17])
read(17, "", 16384)                     = 0
shutdown(17, 0 /* receive */)           = 0
select(18, [3 4 5 6 9 11 13 14 15 16], [3 10 12], NULL, NULL) = 1 (out [3])
write(3, "\277H\201\2f.L*$\322\367&C\346\"\246T\267\33 \10`\377\23\211\r\316hp]\303h", 32) = 32
select(18, [3 4 5 6 9 11 13 14 15 16], [10 12], NULL, NULL) = 1 (in [3])
read(3, "v<L\323nr\255\237\374\320\261q\242==}\244\330Lt\355h\305dP\331x\2630;z\377"..., 8192) = 240
shutdown(17, 1 /* send */)              = 0
shutdown(17, 2 /* send and receive */)  = -1 ENOTCONN (Transport endpoint is not connected)
[/snip]
