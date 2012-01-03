Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736Ab2ACT2Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 14:28:25 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:44553 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961Ab2ACT2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 14:28:22 -0500
MIME-Version: 1.0
Date: Tue, 3 Jan 2012 14:28:21 -0500
Message-ID: <CAA8E7hFwvhATa+LAsW4csnUh1gL-tFZVQMO7LN0iQBa6NFj3KQ@mail.gmail.com>
Subject: APIC seems not working under high network load
From: Jia Rao <rickenrao@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I had scalability issues when running memcached-like workloads in a
Intel 8-core system. It turned out that under high network load only
one core handled the interrupts from NIC. In the output of mpstat, one
of the core was overloaded with 100% %soft time. I tried to echo
different core ids to /proc/irq/irq#/smp_affinity, it did not take
effect until I stopped the incoming network traffic. It seems that
APIC is not distributing interrupts to different cores.

The below are the details of the testing system:
OS: Linux 3.1.4 X86_64
CPU: Intel L5450, quad-core
NIC: Intel e1000e

Thanks !
