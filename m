Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758699Ab0D3R23 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:28:29 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:42702 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758670Ab0D3R1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:27:40 -0400
Message-ID: <4BDB12FB.5060806@in.ibm.com>
Date: Fri, 30 Apr 2010 22:57:23 +0530
From: Sachin Sant <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: Linux/PPC Development <linuxppc-dev@ozlabs.org>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       grant.likely@secretlab.ca, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: -next Apr 30: OOPS during eHEA driver initialization
References: <4BDAF376.4030005@in.ibm.com>
In-Reply-To: <4BDAF376.4030005@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sachin Sant wrote:
> With today's next eHEA drivers fails to initialize.
If i revert the following patch eHEA network interface is initialized
properly.

commit cebfe0b6709abdab997c1a00499d67efa32ee1f0
drivercore: Add of_match_table to the common device drivers

Thanks
-Sachin

>
> IBM eHEA ethernet device driver (Release EHEA_0103)
> Unable to handle kernel paging request for data at address 0x00000000
> Faulting instruction address: 0xc0000000004e8d7c
> Oops: Kernel access of bad area, sig: 11 [#1]
> SMP NR_CPUS=1024 NUMA pSeries
> last sysfs file: /sys/devices/vio/30000007/host0/target0:0:2/0:0:2:0/type
> Modules linked in: ehea(+) sr_mod cdrom sg sd_mod crc_t10dif ibmvscsic 
> scsi_transport_srp scsi_tgt scsi_mod
> NIP: c0000000004e8d7c LR: c00000000002614c CTR: c000000000026314
> REGS: c00000000c517810 TRAP: 0300   Not tainted  
> (2.6.34-rc5-autotest-next-20100430)
> MSR: 8000000000009032 <EE,ME,IR,DR>  CR: 24222228  XER: 20000005
> DAR: 0000000000000000, DSISR: 0000000040000000
> TASK = c00000000cf3ced0[730] 'modprobe' THREAD: c00000000c514000 CPU: 0
> GPR00: c00000000002614c c00000000c517a90 c000000000c96358 
> 0000000000000000
> GPR04: c0000000ffff7858 c0000000004e973c c00000000cf3d9c8 
> 0000000000000000
> GPR08: c000000000e4f8a0 0000000000001eed 0000000000000000 
> 00000000000002e7
> GPR12: d000000001bfb0d0 c000000007440000 0000000000000000 
> 0000000000000000
> GPR16: 0000000000000000 0000000000000000 000000001002c598 
> 0000000000000000
> GPR20: 0000000000000000 0000000000000004 0000000000000000 
> 0000000010030218
> GPR24: 0000000010030160 00000fffb7b00000 0000000010030200 
> 0000000000000000
> GPR28: c0000000ffff7858 0000000000000000 c000000000bfd528 
> 0000000000000000
> NIP [c0000000004e8d7c] .of_match_node+0xc0/0x10c
> LR [c00000000002614c] .ibmebus_create_devices+0x48/0x104
> Call Trace:
> [c00000000c517a90] [c0000000004e973c] .of_get_next_child+0x74/0x98 
> (unreliable)
> [c00000000c517b20] [c00000000002614c] .ibmebus_create_devices+0x48/0x104
> [c00000000c517bc0] [c000000000026338] .ibmebus_register_driver+0x24/0x4c
> [c00000000c517c50] [d000000001bfa1bc] .ehea_module_init+0x1d4/0x22b8 
> [ehea]
> [c00000000c517ce0] [c0000000000097a4] .do_one_initcall+0x88/0x1bc
> [c00000000c517d90] [c0000000000cbdf4] .SyS_init_module+0x11c/0x2b0
> [c00000000c517e30] [c0000000000085b4] syscall_exit+0x0/0x40
> Instruction dump:
> 7c7de838 881f0040 2f800000 419e0018 7f83e378 389f0040 4bfffdbd 7c63e838
> 7c7d07b4 2fbd0000 409e0030 3bff00c8 <881f0000> 2f800000 409eff60 881f0020
> ---[ end trace cb522a034d760fb8 ]---
>
> next-20100428 was OK. Will try to bisect.
>
> Thanks
> -Sachin
>
>


-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

