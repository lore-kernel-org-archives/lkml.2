Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753065Ab1FSROl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 13:14:41 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:62876 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198Ab1FSROk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 13:14:40 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jonas Bonn <jonas@southpole.se>
Subject: Re: [PATCH 01/19] OpenRISC: Boot code
Date: Sun, 19 Jun 2011 19:14:20 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc1nosema+; KDE/4.6.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <1308483825-6023-1-git-send-email-jonas@southpole.se> <1308483825-6023-2-git-send-email-jonas@southpole.se>
In-Reply-To: <1308483825-6023-2-git-send-email-jonas@southpole.se>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201106191914.20242.arnd@arndb.de>
X-Provags-ID: V02:K0:vv5ZqRfzEHRje7qoyj7mkNz7sMhepQZLNF14D/qt0TK
 GT4N+etT7zk/FDI+1nMqBoVKMWU5Vcu7bJtgkR5DxcI5gbxAiO
 SuX2SoiC44ek/LeNa1/be1rvT1RSRtOgZZOJ2hriH7QfZIHSQ0
 MbpgxT9IUnsxeuVK/4Nc2j25IDR6CmQpSVmwtyNf1p4rMmLnKt
 KD89DRauXRrmZpHzMEORw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 19 June 2011 13:43:27 Jonas Bonn wrote:
>
> +
> +/*
> + * Setup options
> + */
> +
> +extern int root_mountflags;
> +extern char _stext, _etext, _edata, _end;
> +extern int __init setup_early_serial8250_console(char *cmdline);
> +#ifdef CONFIG_BLK_DEV_INITRD
> +extern char __initrd_start, __initrd_end;
> +extern char __initramfs_start;
> +#endif
> +
> +extern u32 __dtb_start[];
> ...
> +extern const unsigned long text_start, edata; /* set by the linker script */
> +
> ...
> +
> +extern void __ic_enable(u32 icache_size, u32 icache_block_size);
> +extern void __dc_enable(u32 dcache_size, u32 dcache_block_size);
> +

Better move these all to a header file.

> +unsigned long or32_mem_size = 0;

This seems to be unused.

> +#ifdef CONFIG_CMDLINE
> +char __initdata cmd_line[COMMAND_LINE_SIZE] = CONFIG_CMDLINE;
> +#else
> +char __initdata cmd_line[COMMAND_LINE_SIZE] = "console=uart,mmio,0x90000000,115200";
> +#endif

You can set the Kconfig default to "console=uart,mmio,0x90000000,115200" and get
rid of the #ifdef here.

> +       printk("OpenRISC Linux -- http://openrisc.net\n");

Missing KERN_* level.

> +struct seq_operations cpuinfo_op = {
> +       start:  c_start,
> +       next:   c_next,
> +       stop:   c_stop,
> +       show:   show_cpuinfo,
> +};

Structures should be initialized with modern named field initializers, like

	.start = c_start,

> +/*RGD this awful hack is because our compiler does
> + *support the "weak" attribute correctly at this time
> + *once we do (support weak) this should be removed!!
> + */
> +void __start_notes(void){}
> +void __stop_notes(void){}

Does that comment still apply, or can you remove this now?

	Arnd
