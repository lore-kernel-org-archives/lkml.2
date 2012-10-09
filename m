Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287Ab2JIS10 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 14:27:26 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:56738 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867Ab2JIS1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 14:27:23 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1210091316570.29539@kaball.uk.xensource.com>
References: <1349757558-10856-1-git-send-email-yinghai@kernel.org>
	<alpine.DEB.2.02.1210091316570.29539@kaball.uk.xensource.com>
Date: Tue, 9 Oct 2012 11:27:22 -0700
X-Google-Sender-Auth: IdOhbEZaOgCO-1qjtg2-NdMNeho
Message-ID: <CAE9FiQUL=0+TfUHKdcV-OGhGbtoarHU-3ch3kqz7NmqhBPWvwQ@mail.gmail.com>
Subject: Re: [PATCH -v2 00/10] x86: Use BRK to pre mapping page table to make
 xen happy
From: Yinghai Lu <yinghai@kernel.org>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 9, 2012 at 5:19 AM, Stefano Stabellini
<stefano.stabellini@eu.citrix.com> wrote:
>
> I agree with Peter that this series is going in the right direction.
> However if I give more than 4G of RAM to the VM I get a panic at boot:
>
> [    0.000000] Linux version 3.6.0-rc7+ (sstabellini@st22) (gcc version 4.4.5 (Debian 4.4.5-8) ) #532 SMP Tue Oct 9 12:15:32 UTC 2012
> [    0.000000] Command line: root=/dev/xvda1 textmode=1 xencons=xvc0 debug loglevel=9 earlyprintk=xen
> [    0.000000] ACPI in unprivileged domain disabled
> [    0.000000] e820: BIOS-provided physical RAM map:
> [    0.000000] Xen: [mem 0x0000000000000000-0x000000000009ffff] usable
> [    0.000000] Xen: [mem 0x00000000000a0000-0x00000000000fffff] reserved
> [    0.000000] Xen: [mem 0x0000000000100000-0x00000001387fffff] usable
> [    0.000000] bootconsole [xenboot0] enabled
> [    0.000000] NX (Execute Disable) protection: active
> [    0.000000] DMI not present or invalid.
> [    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
> [    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
> [    0.000000] No AGP bridge found
> [    0.000000] e820: last_pfn = 0x138800 max_arch_pfn = 0x400000000
> [    0.000000] e820: last_pfn = 0x100000 max_arch_pfn = 0x400000000
> [    0.000000] initial memory mapped: [mem 0x00000000-0x02781fff]
> [    0.000000] Base memory trampoline at [ffff88000009a000] 9a000 size 24576
> [    0.000000] calculate_table_space_size: [mem 0x00000000-0x000fffff]
> [    0.000000]  [mem 0x00000000-0x000fffff] page 4k
> [    0.000000] calculate_table_space_size: [mem 0x00100000-0x1387fffff]
> [    0.000000]  [mem 0x00100000-0x1387fffff] page 4k
> [    0.000000] init_memory_mapping: [mem 0x137e33000-0x1387fffff]
> [    0.000000]  [mem 0x137e33000-0x1387fffff] page 4k

great, thank for testing it.

will come out new version that  willget rid of find_table size and
cal_table ...stuff.

Thanks

Yinghai
