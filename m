Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933181Ab0JZNRJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 09:17:09 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:40838 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932464Ab0JZNRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 09:17:08 -0400
Date: Tue, 26 Oct 2010 15:18:43 +0200
From: Borislav Petkov <bp@amd64.org>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: Clocksource tsc unstable (delta = -8589361717 ns) in current
 git
Message-ID: <20101026131843.GC17852@aftab>
References: <20101026112052.GA1672@arch.trippelsdorf.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101026112052.GA1672@arch.trippelsdorf.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 26, 2010 at 07:20:52AM -0400, Markus Trippelsdorf wrote:
> On my AMD system the following kernel messages are sometimes printed
> after several hours of uptime:
> Clocksource tsc unstable (delta = -8589361717 ns)
> Switching to clocksource hpet

This is strange, tsc is actually stable on your F10h revC.

> This happened several times already:
> # grep "Clocksource" kernel.*
> kernel.log:Oct 24 18:31:17 arch kernel: Clocksource tsc unstable (delta = -8591703466 ns)
> kernel.log:Oct 26 12:54:38 arch kernel: Clocksource tsc unstable (delta = -8589361717 ns)
> kernel.log.1:Oct 22 21:43:51 arch kernel: Clocksource tsc unstable (delta = -25772316650 ns)

Do you have any warnings/oopses before that, can we have the whole dmesg
with the above messages?

> The computer is nearly unusable afterwards (second long delays, that
> seem to grow larger and larger) and only a prompt reboot can fix the
> problem.
> I'm running the latest git kernel. Version 2.6.36 does not show these
> symptoms.
> 
> Dmesg and kernel config are attached.
> 
> -- 
> Markus

> Initializing cgroup subsys cpu
> Linux version 2.6.36-05618-gb18cae4-dirty (markus@arch.trippelsdorf.de) (gcc version 4.5.1 (GCC) ) #41 SMP PREEMPT Tue Oct 26 06:51:47 CEST 2010

 ...-dirty means you have some changes ontop of b18cae4. What are those?

> Command line: root=/dev/sdb2 fbcon=rotate:3 quiet kexec_jump_back_entry=0x23d64482b7e72bb7
> BIOS-provided physical RAM map:

otherwise, I don't see anything strange in your dmesg. Unless tglx has a
better idea, I'd ask you to bisect it. 5618 changesets shouldn't be that
much but I don't know, if the issue appears every several hours it could
still be tedious.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
