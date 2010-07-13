Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756766Ab0GMN3D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 09:29:03 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:35387 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756741Ab0GMN3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 09:29:00 -0400
X-Auth-Info: KD5gAFr4G/nLpuYFc3z/iVVyvyxS+uMutq7EIz1ynEs=
Message-ID: <4C3C6A24.3000906@grandegger.com>
Date: Tue, 13 Jul 2010 15:29:08 +0200
From: Wolfgang Grandegger <wg@grandegger.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Netdev@vger.kernel.org
CC: "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: High process latencies due to MPC5200 FEC hard- soft-irq processing
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

we realized, that multiple ping floods (ping -f) can cause very large
high-priority process latencies (up to a many seconds) on a MPC5200
PowerPC system with FEC NAPI support. The latencies are measured with

  # cyclictest -p 80 -n

The problem is that processing of the ICMP pakets in the Hard-Irq and
Soft-IRQ context can last for a long time without returning to the
scheduler. Reducing MAX_SOFTIRQ_RESTART from 10 to 2 helps - the latency
goes down to 35 ms with 2 "ping -f" - but it's not a configurable
parameter, even if it somehow depends on the CPU power. And using the
-rt patches seems overkill to me. Any other ideas or comments on how to
get rid of such high process latencies?

Wolfgang.
