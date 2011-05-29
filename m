Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755583Ab1E2Wne (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 18:43:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48857 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752306Ab1E2Wnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 18:43:32 -0400
Date: Sun, 29 May 2011 15:45:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Robert Goldner <robert@au-79.de>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Ooops with 2.6.39
Message-Id: <20110529154542.add2a308.akpm@linux-foundation.org>
In-Reply-To: <4DE1E013.6010300@au-79.de>
References: <4DE1E013.6010300@au-79.de>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc netdev)

On Sun, 29 May 2011 07:56:35 +0200 Robert Goldner <robert@au-79.de> wrote:

> Hi,
> 
> sometimes I got an Ooops while the system is starting:
> 
> [   15.824365] ------------[ cut here ]------------
> [   15.824616] WARNING: at net/sched/sch_generic.c:256
> dev_watchdog+0x1d6/0x1e0()
> [   15.824868] Hardware name:
> [   15.825098] NETDEV WATCHDOG: eth0 (sis900): transmit queue 0 timed out
> [   15.825333] Modules linked in: coretemp qt1010 af9013 dvb_pll mt2060
> dvb_usb_nova_t_usb2 dvb_usb_dibusb_common dib3000mc psmouse
> dibx000_common pcspkr dvb_usb_af9015 ohci_hcd
> [   15.829066] Pid: 1462, comm: startpar Not tainted 2.6.39-agathe #2
> [   15.829301] Call Trace:
> [   15.829534]  [<c103c79d>] warn_slowpath_common+0x6d/0xa0
> [   15.829948]  [<c13ff216>] ? dev_watchdog+0x1d6/0x1e0
> [   15.830183]  [<c13ff216>] ? dev_watchdog+0x1d6/0x1e0
> [   15.830417]  [<c103c84e>] warn_slowpath_fmt+0x2e/0x30
> [   15.830828]  [<c13ff216>] dev_watchdog+0x1d6/0x1e0
> [   15.831241]  [<c104ecc8>] ? __queue_work+0xb8/0x300
> [   15.831476]  [<c10048a8>] ? handle_irq+0x18/0x90
> [   15.831889]  [<c1041bc7>] ? irq_exit+0x37/0x80
> [   15.832127]  [<c10044f6>] ? do_IRQ+0x46/0xb0
> [   15.832541]  [<c1080189>] ? rcu_start_gp+0x149/0x1d0
> [   15.832954]  [<c1046a24>] run_timer_softirq+0xe4/0x200
> [   15.833189]  [<c1041900>] ? local_bh_enable+0x80/0x80
> [   15.833426]  [<c151ade9>] ? common_interrupt+0x29/0x30
> [   15.833838]  [<c13ff040>] ? qdisc_reset+0x40/0x40
> [   15.834250]  [<c1041978>] __do_softirq+0x78/0x100
> [   15.834841]  [<c1041900>] ? local_bh_enable+0x80/0x80
> [   15.835097]  <IRQ>  [<c1041bfe>] ? irq_exit+0x6e/0x80
> [   15.835188]  [<c1019dc6>] ? smp_apic_timer_interrupt+0x56/0x90
> [   15.835247]  [<c151a46a>] ? apic_timer_interrupt+0x2a/0x30
> [   15.835305]  [<c151a168>] ? resume_userspace+0x14/0x14
> [   15.835360] ---[ end trace 519c5412e162986a ]---
> 
> 
> The level of pain is very low, because the system is still running very
> well.
> 
> If somebody needs some more information, please let me know.
> 

Which net device driver is being used?
