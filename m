Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751432Ab2DPGpd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 02:45:33 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:44558 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052Ab2DPGpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 02:45:31 -0400
MIME-Version: 1.0
Date: Mon, 16 Apr 2012 14:45:30 +0800
Message-ID: <CAFgQCTsXfs-QAgMp1nfEu=pzhyO763ZQ7XoY7jS9XkjZv0Vxww@mail.gmail.com>
Subject: net-sched/vhost-net: Besides Qdisc on host, is it worth to have a try
 for tranfic control on vhost-net device?
From: Liu ping fan <kernelfans@gmail.com>
To: netdev@vger.kernel.org, qemu-devel@nongnu.org
Cc: linux-kernel@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Anthony Liguori <anthony@codemonkey.ws>,
        Stefan Hajnoczi <stefanha@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

Nowadays, in order to limit the guest's TX bandwidth, we can apply tc
on tap device's ingress Qdisc on host. But I think it is based on
dropping packets in the host's Qdisc layer(Right?).
If my assumption is right, then on guest, whether the sender process
will lower its output or not, will depend on protocol layer implement.
As to protocol armed with congestion control such as tcp, the sender
process will block and save cpu. But as to udp, it seems that the
sender process just generate some unnecessary dropped packets.
In order to save cpu, we can introduce control vhost-net, then the
guest udp sender will block on sk.sk_wmem_alloc to get the same effect
as blocking on congestion like tcp.

But all of above are based on the Qdisc layer's behavior when network
over-limit on host. Is it simply drop skb or defer its transferring?
If deferring, any example code?

Any comments?

Thanks and regards,
pingfan
