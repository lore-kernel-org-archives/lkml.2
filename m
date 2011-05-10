Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970Ab1EJFir (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 01:38:47 -0400
Received: from eu1sys200aog112.obsmtp.com ([207.126.144.133]:53462 "EHLO
	eu1sys200aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753053Ab1EJFip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 01:38:45 -0400
Message-ID: <4DC8CF50.4040003@st.com>
Date: Tue, 10 May 2011 11:08:24 +0530
From: Amit Virdi <amit.virdi@st.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: <linux-input@vger.kernel.org>, <samuel@sortiz.org>, <alan@linux.intel.com>
Cc: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Shiraz HASHIM <shiraz.hashim@st.com>,
        Armando VISCONTI <armando.visconti@st.com>,
        Viresh KUMAR <viresh.kumar@st.com>
Subject: BUG: sleeping function called from invalid context
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I'm testing the driver, based on Linux Kernel 2.6.37, for DICE's Fast 
IrDA controller device. I'm using IrCOMM as the upper IrDA layer and 
using PPP over it.

While testing, I'm getting the following backtrace repeatedly:

=====================================
BUG: sleeping function called from invalid context at 
/data/csd_sw/spear/drives_os/amitvi/spear/kernel/linux-2.6/kernel/mutex.c:85
in_atomic(): 1, irqs_disabled(): 0, pid: 0, name: swapper
Backtrace:
[<c0030b48>] (dump_backtrace+0x0/0x110) from [<c0030c8c>] 
(dump_stack+0x18/0x1c)
  r6:00000000 r5:c725a038 r4:c042c000
[<c0030c74>] (dump_stack+0x0/0x1c) from [<c003b8b4>] 
(__might_sleep+0xc8/0xe8)
[<c003b7ec>] (__might_sleep+0x0/0xe8) from [<c0332bec>] 
(mutex_lock+0x24/0x44)
  r4:c725a038
[<c0332bc8>] (mutex_lock+0x0/0x44) from [<c019f348>] 
(tty_unthrottle+0x1c/0x64)
  r4:c725a000
[<c019f32c>] (tty_unthrottle+0x0/0x64) from [<c0225b08>] 
(ppp_asynctty_receive+0x484/0x4a4)
  r5:c7816000 r4:c726a180
[<c0225684>] (ppp_asynctty_receive+0x0/0x4a4) from [<c030f944>] 
(ircomm_tty_data_indication+0x138/0x184)
[<c030f80c>] (ircomm_tty_data_indication+0x0/0x184) from [<c030c8e8>] 
(ircomm_data_indication+0x7c/0xb4)
  r6:c7011300 r5:c726a900 r4:c7011300
[<c030c86c>] (ircomm_data_indication+0x0/0xb4) from [<c030d31c>] 
(ircomm_process_data+0x110/0x160)
  r5:c726a900 r4:c7011300
[<c030d20c>] (ircomm_process_data+0x0/0x160) from [<c030d6e0>] 
(ircomm_state_conn+0x60/0xec)
  r7:00000000 r6:00000000 r5:c726a900 r4:c7011300
[<c030d680>] (ircomm_state_conn+0x0/0xec) from [<c030d664>] 
(ircomm_do_event+0x6c/0x88)
  r6:c726a900 r5:00000009 r4:00000003
[<c030d5f8>] (ircomm_do_event+0x0/0x88) from [<c030e850>] 
(ircomm_ttp_data_indication+0xbc/0xf4)
  r7:00000002 r6:00000000 r5:c726a900 r4:c7011300
[<c030e794>] (ircomm_ttp_data_indication+0x0/0xf4) from [<c03048c0>] 
(irttp_do_data_indication+0x44/0x8c)
  r5:c726a900 r4:c79f3200
[<c030487c>] (irttp_do_data_indication+0x0/0x8c) from [<c03049b4>] 
(irttp_run_rx_queue+0xac/0x318)
  r6:c726a900 r5:00000000 r4:c79f3200
[<c0304908>] (irttp_run_rx_queue+0x0/0x318) from [<c0306194>] 
(irttp_data_indication+0x90/0xac)
[<c0306104>] (irttp_data_indication+0x0/0xac) from [<c02f8158>] 
(irlmp_data_indication+0x5c/0x60)
  r7:c726a900 r6:c7120022 r5:c71cb300 r4:c726a900
[<c02f80fc>] (irlmp_data_indication+0x0/0x60) from [<c02fad20>] 
(irlmp_link_data_indication+0x2fc/0x35c)
  r5:c72c2280 r4:c71cb300
[<c02faa24>] (irlmp_link_data_indication+0x0/0x35c) from [<c02fc0d4>] 
(irlap_data_indication+0x38/0x3c)
[<c02fc09c>] (irlap_data_indication+0x0/0x3c) from [<c02ff434>] 
(irlap_state_nrm_s+0x208/0x7e0)
  r6:c7214400 r5:00000001 r4:00000010
[<c02ff22c>] (irlap_state_nrm_s+0x0/0x7e0) from [<c02fced8>] 
(irlap_do_event+0x84/0x17c)
[<c02fce54>] (irlap_do_event+0x0/0x17c) from [<c02ffeb0>] 
(irlap_driver_rcv+0x178/0xc34)
  r8:c7214400 r7:c726a900 r6:c78e7800 r5:00000001 r4:00000000
[<c02ffd38>] (irlap_driver_rcv+0x0/0xc34) from [<c0287a3c>] 
(__netif_receive_skb+0x348/0x39c)
  r8:00000000 r7:00001700 r6:c78e7800 r5:c05ee8c4 r4:c726a900
[<c02876f4>] (__netif_receive_skb+0x0/0x39c) from [<c028aec4>] 
(process_backlog+0x8c/0x154)
[<c028ae38>] (process_backlog+0x0/0x154) from [<c028aff8>] 
(net_rx_action+0x6c/0x188)
[<c028af8c>] (net_rx_action+0x0/0x188) from [<c0046f94>] 
(__do_softirq+0x84/0x118)
[<c0046f10>] (__do_softirq+0x0/0x118) from [<c00472a8>] (irq_exit+0x44/0x4c)
[<c0047264>] (irq_exit+0x0/0x4c) from [<c002c080>] (asm_do_IRQ+0x80/0xa0)
[<c002c000>] (asm_do_IRQ+0x0/0xa0) from [<c002cb50>] (__irq_svc+0x30/0x80)
Exception stack(0xc042df40 to 0xc042df88)
df40: 00000000 0005317f 0005217f 60000013 c042c000 c042fcdc c046418c 
c042fcd0
df60: 0002661c 41069265 00026580 c042df94 600000d3 c042df88 c002e694 
c002e6a0
df80: 60000013 ffffffff
  r5:f1100000 r4:ffffffff
[<c002e670>] (default_idle+0x0/0x34) from [<c002e458>] (cpu_idle+0x60/0xa4)
[<c002e3f8>] (cpu_idle+0x0/0xa4) from [<c032d5c4>] (rest_init+0x5c/0x74)
  r6:c0027e60 r5:c046415c r4:c0488aa4
[<c032d568>] (rest_init+0x0/0x74) from [<c0008a8c>] 
(start_kernel+0x278/0x2e0)
[<c0008814>] (start_kernel+0x0/0x2e0) from [<00008034>] (0x8034)
=====================================

On analysis, I found that this is due to the change introduced in 
tty_ioctl.c where the termios mutex is taken to protect against parallel 
throttle/unthrottle. Probably IrCOMM stack code wasn't tested before 
merging this patch.

Please suggest what should be done with the IrCOMM protocol stack code 
to resolve this problem?

Thanks
~Amit Virdi
