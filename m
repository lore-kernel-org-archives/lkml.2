Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097Ab3AGUQq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 15:16:46 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:52770 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615Ab3AGUQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 15:16:44 -0500
MIME-Version: 1.0
In-Reply-To: <1593084.QhbTkmoq3N@hammer82.arch.suse.de>
References: <20121127004144.3604.61708.sendpatchset@tindoh.g01.fujitsu.local>
	<50B8D571.3000000@jp.fujitsu.com>
	<CAE9FiQVaqXMfju5j7qBsk+g=RpES-adBBdrDcnkW=YQTQOfugQ@mail.gmail.com>
	<1593084.QhbTkmoq3N@hammer82.arch.suse.de>
Date: Mon, 7 Jan 2013 12:16:42 -0800
X-Google-Sender-Auth: 8HZB_pZqVWKIXiqT9PFXqmO7-JY
Message-ID: <CAE9FiQWTiFu0+ymVroK84L-LCc7FBU1trdZAcaXqMGM2My6LzQ@mail.gmail.com>
Subject: Re: [PATCH v7 0/5] Reset PCIe devices to address DMA problem on kdump
 with iommu
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Renninger <trenn@suse.de>
Cc: MUNEDA Takahiro <muneda.takahiro@jp.fujitsu.com>,
        Takao Indoh <indou.takao@jp.fujitsu.com>, linux-pci@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org, andi@firstfloor.org,
        tokunaga.keiich@jp.fujitsu.com, kexec@lists.infradead.org,
        hbabu@us.ibm.com, mingo@redhat.com, ddutile@redhat.com,
        vgoyal@redhat.com, ishii.hironobu@jp.fujitsu.com, hpa@zytor.com,
        bhelgaas@google.com, tglx@linutronix.de, khalid@gonehiking.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 7, 2013 at 11:09 AM, Thomas Renninger <trenn@suse.de> wrote:
> e820: BIOS-provided physical RAM map:
> BIOS-e820: [mem 0x0000000000000100-0x000000000009bfff] usable
> BIOS-e820: [mem 0x0000000000100000-0x00000000bd2effff] usable
> BIOS-e820: [mem 0x00000000bd2f0000-0x00000000bd31bfff] reserved
> BIOS-e820: [mem 0x00000000bd31c000-0x00000000bd35afff] ACPI data
> BIOS-e820: [mem 0x00000000bd35b000-0x00000000bfffffff] reserved
> BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] reserved
> BIOS-e820: [mem 0x00000000fe000000-0x00000000ffffffff] reserved
> BIOS-e820: [mem 0x0000000100000000-0x000000603fffffff] usable
> debug: ignoring loglevel setting.
> e820: last_pfn = 0x6040000 max_arch_pfn = 0x400000000
> NX (Execute Disable) protection: active
> e820: user-defined physical RAM map:
> user: [mem 0x0000000000000000-0x000000000009ffff] usable
> user: [mem 0x00000000070a0000-0x000000001effafff] usable
> user: [mem 0x00000000bd31c000-0x00000000bd35afff] ACPI data

can you make sure kdump kernel command line take
"memmap=256M$3584M" ?

it will make mmconf working.

> megasas: 06.504.01.00-rc1 Mon. Oct. 1 17:00:00 PDT 2012

also need to append "debug ignore_loglevel" to see why the disks are not
probed.

Thanks

Yinghai
