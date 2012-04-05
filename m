Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756541Ab2DECaf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 22:30:35 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:43604 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740Ab2DECad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 22:30:33 -0400
MIME-Version: 1.0
Date: Thu, 5 Apr 2012 10:30:33 +0800
Message-ID: <CAFgQCTuDNAGx+NTzUzkYJcsppL6JwghZMuThRre-m6Te=sYAcg@mail.gmail.com>
Subject: Despite of traffic control on host netdevice, is it worth to impose a
 limit control on qemu emulated net device?
From: Liu ping fan <kernelfans@gmail.com>
To: qemu-devel@nongnu.org, netdev@vger.kernel.org
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Stefan Hajnoczi <stefanha@gmail.com>,
        Anthony Liguori <anthony@codemonkey.ws>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

As we know, in order to control the guest OS's TX rate limit, we can
apply rate limit on ingress Qdisc of host's tap device.
But I think skb will be dropped on host's tap ingress Qdisc, which
means that for those protocol lacking of congestion control such as
UDP, it will cost a lot of meaningless time to produce dropped packet
.

What about introducing rate limit on qemu's emulated net device?  I
think guest's UDP transaction will be  blocked at wait_for_wmem.

Thanks and regards,
pingfan
