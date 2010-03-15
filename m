Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936568Ab0CORxa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 13:53:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:49257 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752707Ab0CORx1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 13:53:27 -0400
Message-ID: <4B9E73D9.7020101@kernel.org>
Date: Mon, 15 Mar 2010 10:52:25 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Re: CONFIG_NO_BOOTMEM woes, 2.6.34-rc1
References: <4B9E5211.9000204@redhat.com>
In-Reply-To: <4B9E5211.9000204@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/15/2010 08:28 AM, Avi Kivity wrote:
> With CONFIG_NO_BOOTMEM=y, I get:
> 
> kobject '' (c252bfdc): tried to add an uninitialized object, something
> is seriously wrong.
> Pid: 1, comm: swapper Not tainted 2.6.34-rc1 #121
> Call Trace:
>  [<c07803f5>] ? printk+0x14/0x17
>  [<c05a4cea>] kobject_add+0x28/0x49
>  [<c06e65c1>] add_sysfs_fw_map_entry+0x5b/0x74
>  [<c09fa56f>] memmap_init+0x13/0x2d
>  [<c040305b>] do_one_initcall+0x51/0x13f
>  [<c09ca376>] kernel_init+0x122/0x1a3
>  [<c09ca254>] ? kernel_init+0x0/0x1a3
>  [<c0408ffe>] kernel_thread_helper+0x6/0x10
> ------------[ cut here ]------------
> WARNING: at lib/kobject.c:595 kobject_put+0x27/0x3c()
> 
> a bit after which the kernel dies.  Inspection of memmap_init() and
> related code appears to call kobject_init() correctly.
> 
> With CONFIG_NO_BOOTMEM, the kernel hangs in early boot before displaying
> anything.
> 
> 2.6.34-rc1, i386 (x86_64 works fine).
> 

can you send out
.config and boot log for old kernel ...

Thanks

Yinghai
