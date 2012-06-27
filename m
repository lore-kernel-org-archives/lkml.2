Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757823Ab2F0Rqr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 13:46:47 -0400
Received: from mail.skyhub.de ([78.46.96.112]:55427 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753418Ab2F0Rqp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 13:46:45 -0400
Date: Wed, 27 Jun 2012 19:46:49 +0200
From: Borislav Petkov <bp@alien8.de>
To: Thomas Sattler <sattler@med.uni-frankfurt.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: BUG: scheduling while atomic: chcpu/6197/0x00000002
Message-ID: <20120627174649.GA28137@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Thomas Sattler <sattler@med.uni-frankfurt.de>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>
References: <4FDF00CB.7090703@med.uni-frankfurt.de>
 <4FDF201E.2090408@med.uni-frankfurt.de>
 <4FE19494.6000303@med.uni-frankfurt.de>
 <4FE86067.9010408@med.uni-frankfurt.de>
 <4FEAF165.9090008@med.uni-frankfurt.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4FEAF165.9090008@med.uni-frankfurt.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 27, 2012 at 01:41:25PM +0200, Thomas Sattler wrote:
> Linux dragon 3.4.4-rt13 #2 SMP PREEMPT Tue Jun 26 12:22:23 CEST 2012
> i686 Intel(R) Core(TM)2 CPU 6300 @ 1.86GHz GenuineIntel GNU/Linux
> 
> still BUG message in dmesg:
> 
> [  105.585086] BUG: scheduling while atomic: chcpu/2817/0x00000002
> [  105.585090] Modules linked in: loop rfcomm bnep btusb hid_microsoft
> usbhid hid uhci_hcd ehci_hcd 3c59x usbcore e1000e mii usb_common sg
> [  105.585109] Pid: 2817, comm: chcpu Not tainted 3.4.4-rt13 #2
> [  105.585111] Call Trace:
> [  105.585119]  [<c103df4d>] __schedule_bug+0x3d/0x42
> [  105.585124]  [<c1355474>] __schedule+0x68/0x571
> [  105.585130]  [<c1045840>] ? enqueue_entity+0x313/0x3d8
> [  105.585134]  [<c1355a22>] schedule+0x60/0x70
> [  105.585138]  [<c1354a42>] schedule_timeout+0x17/0x160
> [  105.585142]  [<c103ed57>] ? check_preempt_curr+0x29/0x64
> [  105.585146]  [<c135532d>] wait_for_common+0xa3/0xff
> [  105.585150]  [<c10412e2>] ? try_to_wake_up+0x391/0x391
> [  105.585154]  [<c135540a>] wait_for_completion+0x12/0x14
> [  105.585158]  [<c103781c>] kthread_create_on_node+0x71/0xb5
> [  105.585162]  [<c102542c>] ? put_online_cpus+0x44/0x44
> [  105.585167]  [<c1350101>] ? init_amd+0x42f/0x64f
				 ^^^^^^^^

AFAICT, this shouldn't run on Intel hw. Can you send your .config. Also,
can you try latest mainline linux from Linus' git?

Thanks.

-- 
Regards/Gruss,
Boris.
