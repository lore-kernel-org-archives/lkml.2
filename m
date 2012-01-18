Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757149Ab2AREv2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 23:51:28 -0500
Received: from pl1.haspere.com ([208.111.35.220]:37780 "EHLO pl1.haspere.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755257Ab2AREv0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 23:51:26 -0500
X-Greylist: delayed 628 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Jan 2012 23:51:26 EST
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Tue, 17 Jan 2012 22:40:58 -0600
From: Dyweni - KVM <n2CpHSJnr4MP@dyweni.com>
To: KVM <kvm@vger.kernel.org>, Qemu Devel <qemu-devel@nongnu.org>,
        Oprofile-List <oprofile-list@lists.sourceforge.net>,
        Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: general protection fault
Reply-To: <n2CpHSJnr4MP@dyweni.com>
Mail-Reply-To: <n2CpHSJnr4MP@dyweni.com>
Message-ID: <3c9160646ba439b51b505543c0ac8275@pl1.haspere.com>
User-Agent: Roundcube Webmail/0.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Hi All,

 I'm not sure who this falls to, so I've included all all parties that I 
 thought may be relevant.

 I'm getting the following error from my guest kernel when running 
 oprofile within qemu-kvm:

 general protection fault: 0000 [#1]
 Modules linked in:

 Pid: 896, comm: oprofiled Not tainted 3.2.0-rc7-20120117-0605 #1 Bochs 
 Bochs
 EIP: 0060:[<c14069ae>] EFLAGS: 00010086 CPU: 0
 EIP is at nmi_cpu_setup.clone.6+0x2e/0xb0
 EAX: 00000000 EBX: df89894c ECX: c0010005 EDX: 00000000
 ESI: 00000001 EDI: c168e5c0 EBP: df8addf4 ESP: df8adde4
  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
 Process oprofiled (pid: 896, ti=df8ac000 task=df82f780 
 task.ti=df8ac000)
 Stack:
  df898980 00000004 fffffff0 d4520880 df8ade08 c1406d4b c1618dfa 
 00000000
  00000000 df8ade14 c140464f dc792de0 df8ade28 c1405963 d4520880 
 dc792de0
  00000000 df8ade4c c1111bfa c111c7fe df84c000 df8ade44 dc77ef80 
 df8adeec
 Call Trace:
  [<c1406d4b>] nmi_setup+0xab/0xd0
  [<c140464f>] oprofile_setup+0x2f/0xb0
  [<c1405963>] event_buffer_open+0x63/0x90
  [<c1111bfa>] __dentry_open.clone.17+0x1aa/0x2d0
  [<c111c7fe>] ? do_lookup+0x3e/0x370
  [<c1112c82>] nameidata_to_filp+0x52/0x70
  [<c1405900>] ? event_buffer_release+0x40/0x40
  [<c111f1b6>] do_last+0x1e6/0x740
  [<c111f7ea>] path_openat+0x9a/0x320
  [<c10fd854>] ? page_add_new_anon_rmap+0x74/0x80
  [<c111fb60>] do_filp_open+0x30/0x80
  [<c112904c>] ? alloc_fd+0x2c/0xd0
  [<c1112d8b>] do_sys_open+0xeb/0x1c0
  [<c1112e89>] sys_open+0x29/0x40
  [<c14b0f8c>] sysenter_do_call+0x12/0x22
 Code: 57 56 53 83 ec 04 a1 90 e5 68 c1 8b 3d 44 a5 78 c1 8b 1d 8c e5 68 
 c1 89 45 f0 8b 07 85 c0 74 1d 31 f6 8d 76 00 8b 0b 85 c9 74 08 <0f> 32 
 89 43 04 89 53 08 83 c6 01 83 c3 0c 3b 37 72 e8 8b 77 04
 EIP: [<c14069ae>] nmi_cpu_setup.clone.6+0x2e/0xb0 SS:ESP 0068:df8adde4
 ---[ end trace e22f1adcb9f592c1 ]---




 My setup is:

 QEMU-KVM = 0.14.1-r2
 Host Linux Kernel = 3.1.6
 Guest Linux Kernel = 3.2-rc7
 OProfile = 0.9.6-r1



-- 
 Thanks,
 Dyweni

