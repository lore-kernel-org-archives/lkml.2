Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872Ab0DYVOT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Apr 2010 17:14:19 -0400
Received: from mail-yw0-f194.google.com ([209.85.211.194]:60784 "EHLO
	mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232Ab0DYVOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Apr 2010 17:14:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=YkYPVN7fTBVqie0unfWM4VKMsMHk/Y2kVts5HMw8uu2ZDQimbb1box6oC1TjZRUWYe
         Vhg4nRwiJ2aHjf/PrGWimI3dAYVuEv/3RRkrLgCqxymR/PnozveTVfXLGntVaCpq+j95
         DQDD/BNchumr2DyJS4lKwQp+ZpKIxy/1l45Uw=
MIME-Version: 1.0
Date: Sun, 25 Apr 2010 22:14:16 +0100
Message-ID: <v2k6278d2221004251414kbbcc41baw78b86120d81dce7d@mail.gmail.com>
Subject: [2.6.34-rc5] bad page state copying to/from HFS+ filesystem...
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When copying data from a HFS+ filesystem to a freshly-created one, I
experienced page state corruption [1]. I don't have access to the
filesystem anymore, but can run some other filesystem tests if anyone
is interested.

Kernel is mainline 2.6.34-rc5 on x86-64.

Thanks,
  Daniel

--- [1]

hfs: backup: 0,1953523120,244190389,3072
hfs: backup: 0,1953523120,244190389,3072
hfs: backup: 0,1953523120,244190389,3072
hfs: backup: 0,1953523120,244190389,3072
hfs: backup: 0,1953523120,244190389,3072
BUG: Bad page state in process cp  pfn:37654
page:ffffea0000c1e260 count:0 mapcount:0 mapping:(null) index:0x0
page flags: 0x100000000000004(referenced)
Pid: 3163, comm: cp Not tainted 2.6.34-020634rc5-generic #020634rc5
Call Trace:
 [<ffffffff810f6654>] ? dump_page+0x44/0x60
 [<ffffffff810f66ff>] bad_page+0x8f/0x110
 [<ffffffff8113a074>] ? try_get_mem_cgroup_from_mm+0x24/0x80
 [<ffffffff810f68b3>] prep_new_page+0x133/0x150
 [<ffffffff810f81a5>] get_page_from_freelist+0x1d5/0x460
 [<ffffffff810f8a4a>] __alloc_pages_nodemask+0xda/0x180
 [<ffffffff81127a9c>] alloc_pages_current+0x8c/0xd0
 [<ffffffff810f12bd>] __page_cache_alloc+0x6d/0x80
 [<ffffffff810f2edc>] grab_cache_page_write_begin+0x7c/0xc0
 [<ffffffff8116a61c>] block_write_begin+0x8c/0xf0
 [<ffffffff8116b89c>] cont_write_begin+0x8c/0xd0
 [<ffffffffa0398110>] ? hfsplus_get_block+0x0/0x1a0 [hfsplus]
 [<ffffffffa03964f6>] hfsplus_write_begin+0x36/0x40 [hfsplus]
 [<ffffffffa0398110>] ? hfsplus_get_block+0x0/0x1a0 [hfsplus]
 [<ffffffff810f2191>] generic_perform_write+0xc1/0x1a0
 [<ffffffff810f22d5>] generic_file_buffered_write+0x65/0xa0
 [<ffffffff810f3441>] __generic_file_aio_write+0x251/0x3f0
 [<ffffffff810f2ce9>] ? generic_file_aio_read+0xb9/0x1b0
 [<ffffffff810f363c>] generic_file_aio_write+0x5c/0xb0
 [<ffffffff81140a65>] do_sync_write+0xd5/0x120
 [<ffffffff81248aa6>] ? security_file_permission+0x16/0x20
 [<ffffffff81141c3c>] vfs_write+0xcc/0x1a0
 [<ffffffff81141e05>] sys_write+0x55/0x90
 [<ffffffff8100b072>] system_call_fastpath+0x16/0x1b
Disabling lock debugging due to kernel taint
-- 
Daniel J Blueman
