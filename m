Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752245Ab0CSAt4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 20:49:56 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:43836 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752091Ab0CSAtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 20:49:55 -0400
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       avillaci@ceibo.fiec.espol.edu.ec, Ingo Molnar <mingo@elte.hu>,
       bugzilla-daemon@bugzilla.kernel.org, bugme-daemon@bugzilla.kernel.org,
       linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
Subject: Re: [Bugme-new] [Bug 15494] New: BUG: key ffff88013d4f4c70 not in .data! when loading microcode.ko
References: <bug-15494-10286@http.bugzilla.kernel.org/>
	<20100318143544.33374942.akpm@linux-foundation.org>
	<1268958474.9440.451.camel@laptop>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 18 Mar 2010 17:49:43 -0700
In-Reply-To: <1268958474.9440.451.camel@laptop> (Peter Zijlstra's message of "Fri\, 19 Mar 2010 01\:27\:54 +0100")
Message-ID: <m1ljdpb0ew.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: peterz@infradead.org, greg@kroah.com, linux-kernel@vger.kernel.org, bugme-daemon@bugzilla.kernel.org, bugzilla-daemon@bugzilla.kernel.org, mingo@elte.hu, avillaci@ceibo.fiec.espol.edu.ec, akpm@linux-foundation.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:

> On Thu, 2010-03-18 at 14:35 -0700, Andrew Morton wrote:
>> (switched to email.  Please respond via emailed reply-to-all, not via the
>> bugzilla web interface).
>> 
>> On Tue, 9 Mar 2010 16:28:21 GMT
>> bugzilla-daemon@bugzilla.kernel.org wrote:
>> 
>> > http://bugzilla.kernel.org/show_bug.cgi?id=15494
>> 
>> Seems to be a post-2.6.33 regression.
>> 
>> >            Summary: BUG: key ffff88013d4f4c70 not in .data! when loading
>> >                     microcode.ko
>> >            Product: Drivers
>> >            Version: 2.5
>> >     Kernel Version: 2.6.34-rc1
>> >           Platform: All
>> >         OS/Version: Linux
>> >               Tree: Mainline
>> >             Status: NEW
>> >           Severity: normal
>> >           Priority: P1
>> >          Component: Other
>> >         AssignedTo: drivers_other@kernel-bugs.osdl.org
>> >         ReportedBy: avillaci@ceibo.fiec.espol.edu.ec
>> >         Regression: Yes
>> > 
>> > 
>> > Created an attachment (id=25426)
>> >  --> (http://bugzilla.kernel.org/attachment.cgi?id=25426)
>> > Full dmesg output for 2.6.34-rc1 on my machine
>> > 
>> > When loading the module microcode.ko on my 64-bit system, I get the following
>> > dump on the kernel log:
>> > 
>> > [   10.774690] ------------[ cut here ]------------
>> > [   10.774726] WARNING: at kernel/lockdep.c:2706 lockdep_init_map+0x114/0x130()
>> > [   10.774759] Hardware name:         
>> > [   10.774774] Modules linked in: microcode(+) kvm_intel kvm uinput
>> > snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_seq
>> > snd_seq_device snd_pcm snd_timer snd i2c_i801 soundcore iTCO_wdt snd_page_alloc
>> > iTCO_vendor_support ppdev parport_pc parport pcspkr r8169 mii dm_multipath i915
>> > drm_kms_helper drm i2c_algo_bit i2c_core video output [last unloaded:
>> > scsi_wait_scan]
>> > [   10.775026] Pid: 1939, comm: modprobe Not tainted 2.6.34-rc1 #9
>> > [   10.775048] Call Trace:
>> > [   10.775063]  [<ffffffff81048006>] warn_slowpath_common+0x76/0xb0
>> > [   10.775087]  [<ffffffff8104804f>] warn_slowpath_null+0xf/0x20
>> > [   10.775109]  [<ffffffff81073c34>] lockdep_init_map+0x114/0x130
>> > [   10.775139]  [<ffffffff8115b3aa>] sysfs_add_file_mode+0x6a/0xc0
>> > [   10.775163]  [<ffffffff8115b40c>] sysfs_add_file+0xc/0x10
>> > [   10.775185]  [<ffffffff8115d8a1>] sysfs_create_bin_file+0x21/0x30
>> > [   10.775209]  [<ffffffff812945bd>] _request_firmware+0x21d/0x4e0
>> > [   10.775232]  [<ffffffff8129490e>] request_firmware+0xe/0x10
>> > [   10.775256]  [<ffffffffa00f1bc1>] request_microcode_fw+0x61/0xa0 [microcode]
>> > [   10.775283]  [<ffffffff8115db01>] ? internal_create_group+0xc1/0x1a0
>> > [   10.775309]  [<ffffffffa00f13b8>] microcode_init_cpu+0xb8/0xd0 [microcode]
>> > [   10.775336]  [<ffffffffa00f1426>] mc_sysdev_add+0x56/0x70 [microcode]
>> > [   10.775361]  [<ffffffff8128a04e>] sysdev_driver_register+0x9e/0x130
>> > [   10.775386]  [<ffffffffa0130000>] ? microcode_init+0x0/0x12b [microcode]
>> > [   10.775412]  [<ffffffffa01300be>] microcode_init+0xbe/0x12b [microcode]
>> > [   10.775438]  [<ffffffff810001d7>] do_one_initcall+0x37/0x190
>> > [   10.775462]  [<ffffffff8107fe4b>] sys_init_module+0xdb/0x250
>> > [   10.775485]  [<ffffffff81002e6b>] system_call_fastpath+0x16/0x1b
>> > [   10.775508] ---[ end trace e0218cb5fc4c0bc8 ]---
>> > 
>> > This dump did not appear with vanilla 2.6.33.
>> > 
>> > Steps to reproduce:
>> > 1) compile 2.6.34-rc1 with attached configuration
>> > 2) run on 64-bit intel machine
>> > 3) load microcode.ko or make system configuration load it.
>> > 
>> > Actual results:
>> > kernel dump as shown above
>> > 
>> > Expected results: 
>> > no dump, microcode should load normally
>> > 
>> 
>> Methinks 6992f5334995af474c2b58d010d08bc597f0f2fe ("sysfs: Use one
>> lockdep class per sysfs attribute") is implicated.  
>
> You're right, that patch adds a key to struct attribute, and the
> firmware stuff seems to dynamically allocate these things in
> firmware_priv::bin_attribute::attr.
>
> The allocation seems to happen in fw_register_device().
>
> So yes, that patch is incompatible with the firmware usage, as struct
> lock_class_key's are required to be in static storage.

Greg already has a patch for this one queued in his tree.
Essentially it is just sysfs_attr_init.

99% of the sysfs attributes are static so it made sense to optimize
that case and only require explicit initialization on the handful
of dynamically allocated sysfs attributes.

Eric


