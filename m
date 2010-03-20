Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406Ab0CTSWn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 14:22:43 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:64566 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154Ab0CTSWl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 14:22:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=EdJNBwEFlBAjQMq8qav3+vQC4cbsxxElKsl1a1AvlfgXwoDR5c9fcvnE6La81qsJTs
         incg0WLcaqi28vRjQM6yfzQvkd5yDJhwGYC3mr+9/OsZS02xhoEXOz5CZlaRidiToIaH
         EEbtQjKQ5WLboPYmGMp5EWE3ju5bDAbB8U+iA=
MIME-Version: 1.0
In-Reply-To: <86802c441003201052taa660c0n2098e3ced56d2f1d@mail.gmail.com>
References: <20100308172429.GA20953@ldl.fc.hp.com>
	 <20100319144625.4247b7e6@jbarnes-piketon>
	 <86802c441003201052taa660c0n2098e3ced56d2f1d@mail.gmail.com>
Date: Sat, 20 Mar 2010 11:22:40 -0700
X-Google-Sender-Auth: c97457d43ca0e545
Message-ID: <86802c441003201122m3cf6d2d6p3251ab8e9458b641@mail.gmail.com>
Subject: Re: [PATCH] PCI: create function symlinks in /sys/bus/pci/slots/N/
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Alex Chiang <achiang@hp.com>, linux-pci <linux-pci@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, willy@linux.intel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 20, 2010 at 10:52 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Fri, Mar 19, 2010 at 2:46 PM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
>> On Mon, 8 Mar 2010 10:24:29 -0700
>> Alex Chiang <achiang@hp.com> wrote:
>>
>>> Create convenience symlinks in sysfs, linking slots to device
>>> functions, and vice versa. These links make it easier for users to
>>> figure out which devices actually live in what slots.
>>>
>>> For example:
>>
>> Applied to linux-next, thanks.
>
> looks this one cause
>
> [  225.210695] calling  pci_sysfs_init+0x0/0x51 @ 1
> [  225.224774] ------------[ cut here ]------------
> [  225.228913] WARNING: at fs/sysfs/dir.c:451 sysfs_add_one+0xd9/0xf3()
> [  225.245349] Hardware name: Sun Fire x4800
> [  225.247894] sysfs: cannot create duplicate filename
> '/devices/pci0000:00/0000:00:03.0/0000:02:00.0/slot'
> [  225.268122] Modules linked in:
> [  225.270966] Pid: 1, comm: swapper Not tainted
> 2.6.34-rc2-tip-yh-03489-gae232d1-dirty #684
> [  225.286652] Call Trace:
> [  225.288878]  [<ffffffff81079c04>] warn_slowpath_common+0x7c/0x94
> [  225.306239]  [<ffffffff81079c73>] warn_slowpath_fmt+0x41/0x43
> [  225.310655]  [<ffffffff811868ff>] sysfs_add_one+0xd9/0xf3
> [  225.326012]  [<ffffffff8118753a>] sysfs_do_create_link+0xce/0x13c
> [  225.330730]  [<ffffffff81186114>] ? sysfs_create_file+0x2a/0x2c
> [  225.346429]  [<ffffffff811875cd>] sysfs_create_link+0x13/0x16
> [  225.350303]  [<ffffffff813ee209>] pci_create_sysfs_dev_files+0x28e/0x3a1
> [  225.367131]  [<ffffffff826c4c1a>] pci_sysfs_init+0x1f/0x51
> [  225.382825]  [<ffffffff826c4bfb>] ? pci_sysfs_init+0x0/0x51
> [  225.388122]  [<ffffffff826c4bfb>] ? pci_sysfs_init+0x0/0x51
> [  225.403175]  [<ffffffff826c4bfb>] ? pci_sysfs_init+0x0/0x51
> [  225.407330]  [<ffffffff8100020d>] do_one_initcall+0x72/0x17f
> [  225.423173]  [<ffffffff8269b6d6>] do_basic_setup+0x54/0x66
> [  225.428494]  [<ffffffff8269b782>] kernel_init+0x9a/0x111
> [  225.443106]  [<ffffffff81bfa7ae>] ? trace_hardirqs_on_thunk+0x3a/0x3f
> [  225.447205]  [<ffffffff810349d4>] kernel_thread_helper+0x4/0x10
> [  225.464053]  [<ffffffff81bfb63c>] ? restore_args+0x0/0x30
> [  225.467298]  [<ffffffff8269b6e8>] ? kernel_init+0x0/0x111
> [  225.483514]  [<ffffffff810349d0>] ? kernel_thread_helper+0x0/0x10
> [  225.487928] ---[ end trace c9d3fb1a8a3caa22 ]---
>
> the system has pcie hotplug support.

revert that patch, make the warning go away.

YH
