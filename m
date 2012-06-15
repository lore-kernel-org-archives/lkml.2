Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254Ab2FOV2c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 17:28:32 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57394 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749Ab2FOV2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 17:28:30 -0400
Date: Fri, 15 Jun 2012 14:28:24 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Kees Cook <keescook@chromium.org>, Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, devel@driverdev.osuosl.org,
        linaro-kernel@lists.linaro.org, Arnd Bergmann <arnd@arndb.de>,
        patches@linaro.org, Marco Stornelli <marco.stornelli@gmail.com>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        arve@android.com, Jesper Juhl <jj@chaosbits.net>,
        John Stultz <john.stultz@linaro.org>, Shuah Khan <shuahkhan@gmail.com>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        WANG Cong <xiyou.wangcong@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, kernel-team@android.com,
        Thomas Meyer <thomas@m3y3r.de>
Subject: Re: [PATCH v2 0/6] Function tracing support for pstore
Message-ID: <20120615212824.GA23338@kroah.com>
References: <20120615170659.GA4060@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120615170659.GA4060@lizard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2012 at 10:07:00AM -0700, Anton Vorontsov wrote:
> Hi all,
> 
> In v2:
> - Do not introduce a separate 'persistent' tracer, but introduce an
>   option to the existing 'function' tracer.
> 
> Rationale for this patch set:
> 
> With this support kernel can save functions call chain log into a
> persistent ram buffer that can be decoded and dumped after reboot
> through pstore filesystem. It can be used to determine what function
> was last called before a hang or an unexpected reset (caused by, for
> example, a buggy driver that abuses HW).
> 
> Here's a "nano howto", to get the idea:
> 
>  # mount -t debugfs debugfs /sys/kernel/debug/
>  # cd /sys/kernel/debug/tracing
>  # echo function > current_tracer
>  # echo 1 > options/func_pstore
>  # reboot -f
>  [...]
>  # mount -t pstore pstore /mnt/
>  # tail /mnt/ftrace-ramoops
>  0 ffffffff8101ea64  ffffffff8101bcda  native_apic_mem_read <- disconnect_bsp_APIC+0x6a/0xc0
>  0 ffffffff8101ea44  ffffffff8101bcf6  native_apic_mem_write <- disconnect_bsp_APIC+0x86/0xc0
>  0 ffffffff81020084  ffffffff8101a4b5  hpet_disable <- native_machine_shutdown+0x75/0x90
>  0 ffffffff81005f94  ffffffff8101a4bb  iommu_shutdown_noop <- native_machine_shutdown+0x7b/0x90
>  0 ffffffff8101a6a1  ffffffff8101a437  native_machine_emergency_restart <- native_machine_restart+0x37/0x40
>  0 ffffffff811f9876  ffffffff8101a73a  acpi_reboot <- native_machine_emergency_restart+0xaa/0x1e0
>  0 ffffffff8101a514  ffffffff8101a772  mach_reboot_fixups <- native_machine_emergency_restart+0xe2/0x1e0
>  0 ffffffff811d9c54  ffffffff8101a7a0  __const_udelay <- native_machine_emergency_restart+0x110/0x1e0
>  0 ffffffff811d9c34  ffffffff811d9c80  __delay <- __const_udelay+0x30/0x40
>  0 ffffffff811d9d14  ffffffff811d9c3f  delay_tsc <- __delay+0xf/0x20
> 
> Mostly the code comes from trace_persistent.c driver found in the
> Android git tree, written by Colin Cross <ccross@android.com>
> (according to sign-off history). I reworked the driver a little bit,
> and ported it to pstore subsystem.


This looks fine to me, but as it touches pstore and tracing code, I
can't apply it without acks from the relevant maintainers/owners.

thanks,

greg k-h
