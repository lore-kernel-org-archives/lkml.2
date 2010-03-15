Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965252Ab0COP2Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 11:28:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35000 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965193Ab0COP2V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 11:28:21 -0400
Message-ID: <4B9E5211.9000204@redhat.com>
Date: Mon, 15 Mar 2010 17:28:17 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>
Subject: CONFIG_NO_BOOTMEM woes, 2.6.34-rc1
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With CONFIG_NO_BOOTMEM=y, I get:

kobject '' (c252bfdc): tried to add an uninitialized object, something 
is seriously wrong.
Pid: 1, comm: swapper Not tainted 2.6.34-rc1 #121
Call Trace:
  [<c07803f5>] ? printk+0x14/0x17
  [<c05a4cea>] kobject_add+0x28/0x49
  [<c06e65c1>] add_sysfs_fw_map_entry+0x5b/0x74
  [<c09fa56f>] memmap_init+0x13/0x2d
  [<c040305b>] do_one_initcall+0x51/0x13f
  [<c09ca376>] kernel_init+0x122/0x1a3
  [<c09ca254>] ? kernel_init+0x0/0x1a3
  [<c0408ffe>] kernel_thread_helper+0x6/0x10
------------[ cut here ]------------
WARNING: at lib/kobject.c:595 kobject_put+0x27/0x3c()

a bit after which the kernel dies.  Inspection of memmap_init() and 
related code appears to call kobject_init() correctly.

With CONFIG_NO_BOOTMEM, the kernel hangs in early boot before displaying 
anything.

2.6.34-rc1, i386 (x86_64 works fine).

-- 
error compiling committee.c: too many arguments to function

