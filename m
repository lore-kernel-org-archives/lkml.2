Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752497Ab0DYOpp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Apr 2010 10:45:45 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:11471 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617Ab0DYOpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Apr 2010 10:45:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=hsD+/4lLwpAd4Bog0qrl/MFQRlhymbelY1EIiaa3jorccXxojm5deiV5rfTJi9nsbD
         BEwQIkjHc7IaoeP0YjBzxq/r4rhgMOu3MZ/8EC1aeeCpc0cXDK33FJ3KZ0PdBx1HdLKw
         Jej7s1UfbR6T43cZXjuq5GKBdOuV4ZWO9SJWM=
MIME-Version: 1.0
Date: Sun, 25 Apr 2010 16:45:41 +0200
Message-ID: <z2if861ec6f1004250745u94892bdbw9b17db4be57b131b@mail.gmail.com>
Subject: 2.6.34-rc5+: oops in IPv6
From: Manuel Lauss <manuel.lauss@googlemail.com>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-rc5-00204-gddc9b34  dies when sshd (openssh 5.5) is started
Last pull I made on April 23 was fine.

(transcribed from a photo):

BUG: unable to handle kernel NULL pointer dereference at 00000004
IP: [<b1535b72>] inet6_csk_bind_conflict+0x6e/0xb0

EIP: 0060:[<b1535b72>] EFLAGS: 00010293 CPU: 0
EAX: 0000 EBX: ed49c8c0 ECX: 00000000 EDX: 00000000
ESI: ed49c8dc EDI: ee223040 EBP: ef940058 ESP: ed7e9e84
 DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068

Stack:
 ee223040 eebf12e0 b1927198 b14dee45 00000016 ffffffff 00000016 00000005
<0> e8dd766c c8dd75d0 ed7e9ee0 ee223040 ed7e9f04 ee22346c b1517846
<0> ed7e9ef4 00000000 00000016 0000001c 00000000 b166ae1c ef422800 affdb8ab
Call Trace:
b144dee45  inet_csk_get_port+0x1a5/0x27c
b1517846 inet6_bind+0x1b5/0x293
b14aec6c sys_bind+0x63
b1524fdc ipv6_setsockopt+0x38/0x88
b14e0cd7 tcp_setsockopt+0x1b/0x36
b14afa68 sock_common_setsockopt+0x12
b14ae653 sys_setsockopt+0x5e
sys_socketcall
...

GDB says:

0xb1535b72 is in inet6_csk_bind_conflict
(/usr/src/linux-2.6.git/include/net/ipv6.h:376).
371     void ip6_frag_init(struct inet_frag_queue *q, void *a);
372     int ip6_frag_match(struct inet_frag_queue *q, void *a);
373
374     static inline int ipv6_addr_any(const struct in6_addr *a)
375     {
376             return ((a->s6_addr32[0] | a->s6_addr32[1] |
377                      a->s6_addr32[2] | a->s6_addr32[3] ) == 0);
378     }
379
380     static inline int ipv6_addr_loopback(const struct in6_addr *a)


Thanks,
      Manuel Lauss
