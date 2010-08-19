Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847Ab0HSPEc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 11:04:32 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44150 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752704Ab0HSPE2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 11:04:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=mJSjheUjtY/TYF5EHcPY1goOqHaqNS1oIPpcBW5eL3DNn/fG/j+4jWbZjJdQTdE/gk
         4wrCT8pq5qKmiq/ZQ/f0keWsUvdgCKCQ1kVQWaeW3wSvgO5bnlALNLYiQgBmX1ODfQGO
         O9dNfwrn00GuOlIwbEgZAl0Qy57e9JGBOCSLo=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: Re: fix BUG: using smp_processor_id() in preemptible code (resend)
Date: Thu, 19 Aug 2010 17:04:18 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc1; KDE/4.4.5; i686; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Joerg Roedel <joerg.roedel@amd.com>, linux-kernel@vger.kernel.org
References: <20100818091157.GA5238@swordfish.minsk.epam.com>
In-Reply-To: <20100818091157.GA5238@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201008191704.19292.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On środa, 18 sierpnia 2010 o 11:11:58 Sergey Senozhatsky wrote:
> fix BUG: using smp_processor_id() in preemptible code (resend)

I got similar bug (during suspend to disk) on 2.6.36-rc1+ patch from:
https://bugzilla.kernel.org/show_bug.cgi?id=16615

[   89.141370] Enabling non-boot CPUs ...
[   89.142033] BUG: using smp_processor_id() in preemptible [00000000] code: 
pm-hibernate/2584
[   89.142147] caller is thermal_throttle_add_dev+0x10/0x7c
[   89.142200] Pid: 2584, comm: pm-hibernate Not tainted 2.6.36-rc1 #1
[   89.142248] Call Trace:
[   89.142274]  [<c03706ad>] ? printk+0xf/0x12
[   89.142312]  [<c02181d1>] debug_smp_processor_id+0xa5/0xbc
[   89.142357]  [<c036d13d>] thermal_throttle_add_dev+0x10/0x7c
[   89.142403]  [<c036d1f2>] thermal_throttle_cpu_callback+0x49/0x9c
[   89.142454]  [<c0141842>] notifier_call_chain+0x26/0x50
[   89.142496]  [<c01418c3>] __raw_notifier_call_chain+0xe/0x10
[   89.142544]  [<c012be4a>] __cpu_notify+0x15/0x29
[   89.142581]  [<c036ead6>] _cpu_up+0x59/0xdc
[   89.142617]  [<c0364953>] enable_nonboot_cpus+0x3d/0x94
[   89.142660]  [<c0151f94>] hibernation_snapshot+0x11d/0x1b9
[   89.142704]  [<c01520d5>] hibernate+0xa5/0x13f
[   89.142740]  [<c0151035>] ? state_store+0x0/0xa7
[   89.142778]  [<c0151089>] state_store+0x54/0xa7
[   89.142815]  [<c0151035>] ? state_store+0x0/0xa7
[   89.142854]  [<c020ee89>] kobj_attr_store+0x16/0x22
[   89.142894]  [<c01c9a9a>] sysfs_write_file+0xbc/0xe7
[   89.142936]  [<c018e5d3>] vfs_write+0x8a/0xfd
[   89.142972]  [<c01c99de>] ? sysfs_write_file+0x0/0xe7
[   89.143018]  [<c018e6dd>] sys_write+0x3b/0x60
[   89.143055]  [<c01026ec>] sysenter_do_call+0x12/0x22
[   89.143112] SMP alternatives: switching to SMP code

PS. Sorry for overlook previosus mail, already I created bug entry (because 
it's regression):
https://bugzilla.kernel.org/show_bug.cgi?id=16629

Regards
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
