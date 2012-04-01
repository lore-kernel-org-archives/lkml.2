Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751855Ab2DAIor (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 04:44:47 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:50493 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113Ab2DAIoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 04:44:44 -0400
Subject: Re: net-sched: When TX over-limit happens on netdev, what does
 kernel do?
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Liu ping fan <kernelfans@gmail.com>
Cc: linux-net@vger.kernel.org, Jamal Hadi Salim <hadi@cyberus.ca>,
        linux-kernel@vger.kernel.org
In-Reply-To: <CAFgQCTtg1U7V_WbJ2uZG9unM5qV6sPfoCMbrMVdXrebwue6wzg@mail.gmail.com>
References: <CAFgQCTtg1U7V_WbJ2uZG9unM5qV6sPfoCMbrMVdXrebwue6wzg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 01 Apr 2012 10:44:39 +0200
Message-ID: <1333269879.2325.4771.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-04-01 at 16:27 +0800, Liu ping fan wrote:
> Hi,
> 
> Could anybody tell me when TX over-limit happens on netdev, what does kernel do?
> Is skb buffered in Qdisc->q and the sending process keeps running?

Are you referring to the NETDEV_TX_BUSY return code processing ?

> Or we block the sending process and make it scheduled?
> 

We never block the sender process in qdisc layer.

Only upper protocol layers can eventually block if too many packets are
in flight on the socket.

> Found some code in net/sched/sch_cbq.c
> cbq_dequeue(struct Qdisc *sch) --> qdisc_watchdog_schedule(),  so I
> guess the skb is buffered in Qdisc, but what about sending process?

sender queued its packet and doesnt care if the packet is sent or not.

Only problem is when qdisc limit (number of packets in queue) is hit,
then we can return an error to sender (packet dropped or congestion
notification)



