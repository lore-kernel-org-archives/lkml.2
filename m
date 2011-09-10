Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932385Ab1IJNuk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Sep 2011 09:50:40 -0400
Received: from christianhoffmann.info ([88.175.101.52]:37289 "EHLO
	christianhoffmann.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753319Ab1IJNuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Sep 2011 09:50:39 -0400
X-Greylist: delayed 1288 seconds by postgrey-1.27 at vger.kernel.org; Sat, 10 Sep 2011 09:50:39 EDT
Message-ID: <4E6B6624.1000406@christianhoffmann.info>
Date: Sat, 10 Sep 2011 15:29:08 +0200
From: Christian Hoffmann <email@christianhoffmann.info>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: scheduling while atomic: swapper/0/0x10000002
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I can see the following bug report in the kernel 3.1 rc5 dmesg:

[    0.000008] BUG: scheduling while atomic: swapper/0/0x10000002
[    0.000012] Modules linked in:
[    0.000015] Pid: 0, comm: swapper Not tainted 3.1.0-rc5-ch+ #2
[    0.000017] Call Trace:
[    0.000024]  [<ffffffff81052cb6>] __schedule_bug+0x66/0x70
[    0.000028]  [<ffffffff8160329d>] schedule+0x99d/0x9b0
[    0.000032]  [<ffffffff81cf22b5>] ? pidmap_init+0x9f/0xdf
[    0.000035]  [<ffffffff8105cc7a>] __cond_resched+0x2a/0x40
[    0.000038]  [<ffffffff81603541>] _cond_resched+0x31/0x40
[    0.000041]  [<ffffffff8115fb63>] kmem_cache_alloc_trace+0x53/0x160
[    0.000043]  [<ffffffff81cf22b5>] pidmap_init+0x9f/0xdf
[    0.000046]  [<ffffffff81cd9b8a>] start_kernel+0x333/0x3c8
[    0.000049]  [<ffffffff81cd9347>] x86_64_start_reservations+0x132/0x136
[    0.000051]  [<ffffffff81cd944c>] x86_64_start_kernel+0x101/0x110


Full dmesg output:
http://dl.dropbox.com/u/21820416/dmsg.log

Can I provide additional input?

Kind regards,
Chris
