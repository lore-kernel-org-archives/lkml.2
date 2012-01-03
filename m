Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254Ab2ACUsp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 15:48:45 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:51501 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754643Ab2ACUsl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 15:48:41 -0500
MIME-Version: 1.0
In-Reply-To: <1325622628.2611.8.camel@edumazet-laptop>
References: <CAA8E7hFwvhATa+LAsW4csnUh1gL-tFZVQMO7LN0iQBa6NFj3KQ@mail.gmail.com>
	<1325622628.2611.8.camel@edumazet-laptop>
Date: Tue, 3 Jan 2012 15:48:40 -0500
Message-ID: <CAA8E7hHttOg8jC0PPbTBgMJLG8BEhNA3LVJrhNLeUKiyhr=r-w@mail.gmail.com>
Subject: Re: APIC seems not working under high network load
From: Jia Rao <rickenrao@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> With your kernel, one way to help this cpu exit from softirq is using
> RPS (Receive Packet Steering), since packets will be spreaded on several
> cpus. Then, later hardware IRQ might be spreaded on other cpus as well.
>
> for n in `seq 0 7`
> do
>  echo ff >/sys/class/net/eth0/queues/rx-$n/rps_cpus
> done
It seems that my NIC only have one queue: rx-0. Is there a work around
for this ?
As for the softirq, is it possible migrating the softirq to other
cores through CPU load balancing ?

Thanks !
