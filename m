Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198Ab2LNCP5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 21:15:57 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:50570 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754383Ab2LNCPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 21:15:55 -0500
MIME-Version: 1.0
In-Reply-To: <50CA6478.20008@zytor.com>
References: <1355436141-8668-1-git-send-email-yinghai@kernel.org>
	<1355436141-8668-20-git-send-email-yinghai@kernel.org>
	<50CA6478.20008@zytor.com>
Date: Thu, 13 Dec 2012 18:15:54 -0800
X-Google-Sender-Auth: 1NbjDGmK5nQ7VsRJ_w6NhIDc0GI
Message-ID: <CAE9FiQVwse9Un5wE1Qxc867dxLuX0RNptuHzd1xJjK_OiN7QxQ@mail.gmail.com>
Subject: Re: [PATCH v6 19/27] x86, boot: update comments about entries for
 64bit image
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2012 at 3:27 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> if we depend on other
> things we should make that explicit, not just here but in boot.txt.

please check lines for boot.txt

---

**** 64-bit BOOT PROTOCOL

For machine with 64bit cpus and 64bit kernel, we could use 64bit bootloader
We need a 64-bit boot protocol.

In 64-bit boot protocol, the first step in loading a Linux kernel
should be to setup the boot parameters (struct boot_params,
traditionally known as "zero page"). The memory for struct boot_params
should be allocated under or above 4G and initialized to all zero.
Then the setup header from offset 0x01f1 of kernel image on should be
loaded into struct boot_params and examined. The end of setup header
can be calculated as follow:

        0x0202 + byte value at offset 0x0201

In addition to read/modify/write the setup header of the struct
boot_params as that of 16-bit boot protocol, the boot loader should
also fill the additional fields of the struct boot_params as that
described in zero-page.txt.

After setting up the struct boot_params, the boot loader can load the
64-bit kernel in the same way as that of 16-bit boot protocol, but
kernel could be above 4G.

In 64-bit boot protocol, the kernel is started by jumping to the
64-bit kernel entry point, which is the start address of loaded
64-bit kernel plus 0x200.

At entry, the CPU must be in 64-bit mode with paging enabled.
The range with setup_header.init_size from start address of loaded
kernel and zero page and command line buffer get ident mapping;
a GDT must be loaded with the descriptors for selectors
__BOOT_CS(0x10) and __BOOT_DS(0x18); both descriptors must be 4G flat
segment; __BOOT_CS must have execute/read permission, and __BOOT_DS
must have read/write permission; CS must be __BOOT_CS and DS, ES, SS
must be __BOOT_DS; interrupt must be disabled; %rsi must hold the base
address of the struct boot_params.
---
