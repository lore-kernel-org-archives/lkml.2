Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062Ab3ACUuv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 15:50:51 -0500
Received: from server505f.appriver.com ([98.129.35.10]:2525 "EHLO
	server505.appriver.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753708Ab3ACUut convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 15:50:49 -0500
X-Note-AR-ScanTimeLocal: 1/3/2013 2:50:48 PM
X-Policy: GLOBAL - coraid.com
X-Policy: GLOBAL - coraid.com
X-Policy: GLOBAL - coraid.com
X-Policy: GLOBAL - coraid.com
X-Policy: GLOBAL - coraid.com
X-Policy: Too many policies to list
X-Primary: ecashin@coraid.com
X-Note: This Email was scanned by AppRiver SecureTide
X-ALLOW: @coraid.com ALLOWED
X-Virus-Scan: V-
X-Note: Spam Tests Failed: 
X-Country-Path: UNKNOWN->UNITED STATES->UNITED STATES
X-Note-Sending-IP: 98.129.35.1
X-Note-Reverse-DNS: smtp.exg5.exghost.com
X-Note-Return-Path: ecashin@coraid.com
X-Note: User Rule Hits: 
X-Note: Global Rule Hits: G328 G329 G330 G331 G335 G336 G347 G443 
X-Note: Encrypt Rule Hits: 
X-Note: Mail Class: ALLOWEDSENDER
X-Note: Headers Injected
From: Ed Cashin <ecashin@coraid.com>
To: Jens Axboe <axboe@kernel.dk>
CC: Josh Boyer <jwboyer@redhat.com>,
        "mitko@banksoft-bg.com" <mitko@banksoft-bg.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-team@fedoraproject.org" <kernel-team@fedoraproject.org>,
        Peter Zijlstra <peterz@infradead.org>
Date: Thu, 3 Jan 2013 14:50:46 -0600
Subject: Re: Oops on aoe module removal
Thread-Topic: Oops on aoe module removal
Thread-Index: Ac3p9AFwP11ddFP7R4eKRS5YEq27BQ==
Message-ID: <6333449B-1F90-4772-A04A-79E123A8A20D@coraid.com>
References: <20130103132556.GA13290@hansolo.jdub.homelinux.org>
 <587E85C3-7395-4BC1-B31B-426572B5080C@coraid.com>
 <50E5910E.7060606@kernel.dk> <50E591CD.40802@kernel.dk>
 <D2D8353E-8DE1-44A2-BB7F-3FE1E2E794FB@coraid.com>
 <50E5A51C.3030800@kernel.dk>
 <32456405-00CA-43EC-A17A-28452C217A7F@coraid.com>
 <ffc5cf0d1e3273770b65bc7de4a4851e@coraid.com> <50E5DFE4.5020007@kernel.dk>
 <EE162567-A6C8-4C4E-B96F-5366C8DDDCB1@coraid.com>
In-Reply-To: <EE162567-A6C8-4C4E-B96F-5366C8DDDCB1@coraid.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 3, 2013, at 2:57 PM, Ed Cashin wrote:

> On Jan 3, 2013, at 2:45 PM, Jens Axboe wrote:
> 
>> On 2013-01-03 20:28, Ed Cashin wrote:
>>> Lines: 75
>>> 
>>> On Thu, Jan 03, 2013 at 12:15:35PM -0600, Ed Cashin wrote:
>>> ...
>>>>>>>>> On Jan 3, 2013, at 8:25 AM, Josh Boyer wrote:
>>> ...
>>>>>>>>>> [699170.611997] aoe: AoE v47 initialised.
>>> ...
>>>>>>>>>> [699231.308319] WARNING: at lib/list_debug.c:62 __list_del_entry+0x82/0xd0()
>>>>>>>>>> [699231.312031] Hardware name: S5000VSA
>>>>>>>>>> [699231.315658] list_del corruption. next->prev should be ffff880009fa37e8, but was ffffffff81c79c00
>>>>>>>>>> [699231.319352] Modules linked in: aoe(-) ip6table_filter ip6_tables ebtable_nat ebtables lockd sunrpc bridge 8021q garp stp llc vfat fat binfmt_misc iTCO_wdt iTCO_vendor_support vhost_net lpc_ich radeon tun macvtap mfd_core serio_raw coretemp i2c_algo_bit ttm i5000_edac macvlan drm_kms_helper e1000e edac_core microcode i5k_amb shpchp i2c_i801 drm kvm_intel i2c_core kvm ioatdma dca raid1
>>>>>>>>>> [699231.336259] Pid: 8584, comm: modprobe Not tainted 3.6.11-1.fc17.x86_64 #1
>>>>>>>>>> [699231.340561] Call Trace:
>>>>>>>>>> [699231.344865]  [<ffffffff8105c8ef>] warn_slowpath_common+0x7f/0xc0
>>>>>>>>>> [699231.349212]  [<ffffffff8105c9e6>] warn_slowpath_fmt+0x46/0x50
>>>>>>>>>> [699231.353595]  [<ffffffff812eee52>] __list_del_entry+0x82/0xd0
>>>>>>>>>> [699231.357954]  [<ffffffff812eeeb1>] list_del+0x11/0x40
>>>>>>>>>> [699231.362319]  [<ffffffff812f6458>] percpu_counter_destroy+0x28/0x50
>>>>>>>>>> [699231.366712]  [<ffffffff8114c513>] bdi_destroy+0x43/0x140
>>>>>>>>>> [699231.371127]  [<ffffffff812be20c>] blk_release_queue+0x8c/0xc0
>>>>>>>>>> [699231.375454]  [<ffffffff812dc322>] kobject_cleanup+0x82/0x1b0
>>>>>>>>>> [699231.379675]  [<ffffffff812dc1ab>] kobject_put+0x2b/0x60
>>>>>>>>>> [699231.383851]  [<ffffffff812b80a5>] blk_put_queue+0x15/0x20
>>>>>>>>>> [699231.387899]  [<ffffffff812bc659>] blk_cleanup_queue+0xc9/0xe0
>>>>>>>>>> [699231.391794]  [<ffffffffa01f53f5>] aoedev_freedev+0x135/0x150 [aoe]
>>>>>>>>>> [699231.395668]  [<ffffffffa01f59a5>] aoedev_exit+0x65/0x80 [aoe]
>>>>>>>>>> [699231.399493]  [<ffffffffa01f5afe>] aoe_exit+0x2e/0x40 [aoe]
>>>>>>>>>> [699231.403273]  [<ffffffff810bdefe>] sys_delete_module+0x16e/0x2d0
>>>>>>>>>> [699231.407119]  [<ffffffff8161db56>] ? __schedule+0x3c6/0x7a0
>>>>>>>>>> [699231.411050]  [<ffffffff8119054a>] ? sys_write+0x4a/0x90
>>>>>>>>>> [699231.415033]  [<ffffffff81627329>] system_call_fastpath+0x16/0x1b
>>>>>>>>>> [699231.419117] ---[ end trace 9e1558af1964b569 ]---
>>>>>>>>>> [699231.423248] ------------[ cut here ]------------
>>> 
>>> The blk_alloc_queue has already done a bdi_init, so do not bdi_init again in
>>> aoeblk_gdalloc.
>>> 
>>> The patch below applies to v3.5.6, with its v47 aoe driver.  On my system it
>>> eliminates the list_del corruption messages.
>> 
>> Since the patch doesn't apply to current -git, does the problem not
>> exist there?
> 
> The original post is about an older kernel with the v47 aoe driver.  The current mainline has a v81 aoe driver, so the patch for v3.5.6 isn't expected to apply to the mainline.
> 
> I'm currently investigating the state of the mainline with relation to this issue.

I don't see the extra call to bdi_init in aoe driver v81 in the mainline git tree, and
I don't see the symptoms under discussion, either, when performing the same 
test steps.

Kernels with aoe v47 can use the patch I just posted.

I'm going to go through the stable kernels and check, but I believe kernels after
v47 but before commit 0a41409c5180 should apply the fix in 0a41409c5180:

  commit 0a41409c518083133e79015092585d68915865be
  Author: Ed Cashin <ecashin@coraid.com>
  Date:   Mon Dec 17 16:03:58 2012 -0800
  
      aoe: remove vestigial request queue allocation

Josh, can you confirm that the patch I posted in this thread today works for 
your customer?

-- 
  Ed Cashin
  ecashin@coraid.com


