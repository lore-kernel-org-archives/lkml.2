Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759314Ab2AMWHW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 17:07:22 -0500
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:38992 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755782Ab2AMWHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 17:07:19 -0500
Message-ID: <4F10AB02.1010305@linux.vnet.ibm.com>
Date: Sat, 14 Jan 2012 03:36:58 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: "Justin P. Mattock" <justinmattock@gmail.com>
CC: Andi Kleen <ak@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ming Lei <tom.leiming@gmail.com>, Djalal Harouni <tixxdz@opendz.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Tony Luck <tony.luck@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Kay Sievers <kay.sievers@vrfy.org>,
        gouders@et.bocholt.fh-gelsenkirchen.de,
        Marcos Souza <marcos.mage@gmail.com>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "tglx@linutronix.de" <tglx@linutronix.de>, prasad@linux.vnet.ibm.com,
        Jeff Chua <jeff.chua.linux@gmail.com>
Subject: Re: x86/mce: machine check warning during poweroff
References: <20120111000051.GA28874@dztty> <CACVXFVMZhVFZajbZxng9dJqicy1XCK5n_QZLoefvkLkXvMsSZg@mail.gmail.com> <4F10929E.8070007@linux.vnet.ibm.com> <CA+55aFwcOgEbnYhs7z+jc-Jq+fWxV3vfSRdfLXBEUC_40BRK0w@mail.gmail.com> <4F1099CA.7090209@linux.vnet.ibm.com> <CA+55aFw9SkNPoMmad6sOAsY-jtJtes12pBFGr9sipGadS8+VJg@mail.gmail.com> <4F10A0FD.9040504@linux.intel.com> <4F10A464.8080603@gmail.com>
In-Reply-To: <4F10A464.8080603@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12011311-9264-0000-0000-0000009E982C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2012 03:08 AM, Justin P. Mattock wrote:

>>
> 
> this showed up using no_console_suspend
> 
> 
>   131.875143] usb 5-1: device descriptor read/64, error -110
> [  140.599340] PM: Syncing filesystems ... done.
> [  140.815981] PM: Preparing system for mem sleep
> [  140.829117] Freezing user space processes ... (elapsed 0.01 seconds)
> done.
> [  140.840150] Freezing remaining freezable tasks ...
> [  147.079160] usb 5-1: device descriptor read/64, error -110
> [  147.282166] usb 5-1: new full-speed USB device number 6 using uhci_hcd
> [  157.686165] usb 5-1: device not accepting address 6, error -110
> [  157.788183] usb 5-1: new full-speed USB device number 7 using uhci_hcd
> [  160.849310]
> [  160.849320] Freezing of tasks failed after 20.00 seconds (1 tasks
> refusing to freeze, wq_busy=0):

> [  160.849460] khubd           D f5d90020     0    20      2 0x00000000
> [  160.849471]  f5d95d50 00000046 f5d095d0 f5d90020 00000000 c16ec3c0
> bce8e78a 00000024
> [  160.849488]  c16ec3c0 bce7b7f6 00000024 f60063c0 f5d09170 f5d95d20
> c120490b c1039aa6
> [  160.849505]  00000000 00000046 c1721180 00000296 f5d95d70 f5d95d40
> c1465208 00000000
> [  160.849521] Call Trace:
> [  160.849538]  [<c120490b>] ? do_raw_spin_lock+0x3b/0xf0
> [  160.849548]  [<c1039aa6>] ? lock_timer_base.isra.24+0x26/0x50
> [  160.849558]  [<c1465208>] ? _raw_spin_lock_irqsave+0x58/0x70
> [  160.849567]  [<c1204a4e>] ? do_raw_spin_unlock+0x4e/0x90
> [  160.849574]  [<c1463c30>] schedule+0x30/0x50
> [  160.849582]  [<c1461b7f>] schedule_timeout+0x10f/0x1f0
> [  160.849589]  [<c10396f0>] ? usleep_range+0x40/0x40
> [  160.849597]  [<c1463ae0>] wait_for_common+0xb0/0x120
> [  160.849605]  [<c1053bb0>] ? try_to_wake_up+0x260/0x260
> [  160.849614]  [<c1463bdd>] wait_for_completion_timeout+0xd/0x10
> [  160.849624]  [<c13250e1>] usb_start_wait_urb+0xb1/0xe0
> [  160.849632]  [<c10e0101>] ? sys_swapon+0xab1/0xc50
> [  160.849640]  [<c1325308>] usb_control_msg+0xb8/0xf0
> [  160.849648]  [<c12ad1e8>] ? _dev_info+0x28/0x30
> [  160.849656]  [<c131e627>] hub_port_init+0x627/0x710
> [  160.849664]  [<c131d396>] ? usb_set_device_state+0x76/0x130
> [  160.849672]  [<c1320906>] hub_thread+0x626/0x1080
> [  160.849681]  [<c10515a1>] ? finish_task_switch+0x31/0xf0
> [  160.849688]  [<c14635c0>] ? __schedule+0x3b0/0x7b0
> [  160.849698]  [<c10490c0>] ? __init_waitqueue_head+0x50/0x50
> [  160.849705]  [<c1050ef9>] ? complete+0x49/0x60
> [  160.849713]  [<c13202e0>] ? usb_remote_wakeup+0x40/0x40
> [  160.849720]  [<c1048928>] kthread+0x78/0x80
> [  160.849728]  [<c10488b0>] ? __init_kthread_worker+0x60/0x60
> [  160.849736]  [<c146b0fe>] kernel_thread_helper+0x6/0xd
> [  160.849755]
> [  160.849759] Restarting tasks ... done.
> [  160.865733] power_supply BAT0: uevent
> [  160.865737] power_supply BAT0: POWER_SUPPLY_NAME=BAT0
> [  160.886551] power_supply BAT0: prop STATUS=Full
> [  160.886562] power_supply BAT0: prop PRESENT=1
> [  160.886570] power_supply BAT0: prop TECHNOLOGY=Unknown
> [  160.886577] power_supply BAT0: prop CYCLE_COUNT=0
> 
> I can supply full dmesg if needed.
> a bisect on this should not take too long, just need the time to do so.
> 
> last good kernel I have here is: 3.2.0-06541-gf33180c
> 

Freezing failure is a totally different problem. Freezing happens much
before CPUs are taken offline and even before devices are suspended.
But yes, if freezing fails, suspend fails too (it is aborted rather).
And freezing failures are typically a bit harder to trigger since they
occur due to some race conditions. But the suspend failure problem
discussed earlier in this thread (while discussing the MCE warnings) is a
deterministic thing and very easily reproducible.

Regards,
Srivatsa S. Bhat
IBM Linux Technology Center

