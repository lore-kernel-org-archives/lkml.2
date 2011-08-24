Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756660Ab1HXMBI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 08:01:08 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33710 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751657Ab1HXMBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 08:01:06 -0400
MIME-Version: 1.0
Date: Wed, 24 Aug 2011 20:01:05 +0800
Message-ID: <CACPU8qJEjcrjdyp5f0_a+f48r9P8vNUav97zEfxQM58kD76Bug@mail.gmail.com>
Subject: QoS:tcphdr:using tcp_hdr() unabled network
From: gengjia ding <gengjia.ding@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

trying to modify source file net/sched/sch_generic.c in Linux Kernel
2.6.37.6, added code:
+ #include <linux/tcp.h>
+ #include <net/tcp.h>
static int pfifo_fast_enqueue(struct sk_buff *skb, struct Qdisc* qdisc){
    + struct tcphdr *th = tcp_hdr(skb);
    + __be16 dport = th->dest;
}
I just want to get destination port of the transport header in the
socket buffer.
After recompiled the kernel and reboot, the network is unable to startup.

But when i exchange the code:
- #include <linux/tcp.h>
- #include <net/tcp.h>
static int pfifo_fast_enqueue(struct sk_buff *skb, struct Qdisc* qdisc){
    - struct tcphdr *th = tcp_hdr(skb);
    - __be16 dport = th->dest;
    + __be16 dport = *(__be16 *)((unsigned char*)(skb->transport_header + 2));
}
after recompile, the network is up.

Where did i make mistake when using the function tcp_hdr()?

Thanks,
--
Gavin Ding
