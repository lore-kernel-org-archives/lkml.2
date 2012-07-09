Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170Ab2GIOMu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 10:12:50 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:51495 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754139Ab2GIOMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 10:12:49 -0400
Message-ID: <4FFAE6D8.5050609@gmail.com>
Date: Mon, 09 Jul 2012 08:12:40 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi@redhat.com>,
        Gleb Natapov <gleb@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: perf with precise attribute kills all KVM based VMs
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is 100% reproducible with Fedora 17, 3.4.2-1.fc16.x86_64 kernel.

Using the precise attribute (:p or :pp) with perf-record, eg,

perf record -e cycles:p -ag -- sleep 10

All running VMs are killed. The VMs appear to be restarted but crash on 
restart.

 From one of the VMs that has the console redirected to ttyS0 and ttyS0 
of the VM mapped to stdio I was able to capture some boot logs on the 
restart of the VM:

[    0.019136] BUG: unable to handle kernel paging request at 13832f88
[    0.020252] IP: [<c0104ed0>] mcount+0x0/0xc
[    0.021000] *pdpt = 0000000000572001 *pde = 0000000000000000
[    0.021942] Oops: 0000 [#1] SMP
[    0.021996] __die: Die type Oops
[    0.021996] Modules linked in:
[    0.021996]
[    0.021996] Pid: 0, comm: swapper Not tainted (2.6.27.47 #0)
[    0.021996] EIP: 0060:[<c0104ed0>] EFLAGS: 00010296 CPU: 0
[    0.021996] EIP is at mcount+0x0/0xc
[    0.021996] EAX: f78026c0 EBX: 00000000 ECX: f78026c0 EDX: 000080d0
[    0.021996] ESI: f782c228 EDI: f780b240 EBP: c051fef0 ESP: c051fed4
[    0.021996]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[    0.021996] Process swapper (pid: 0, ti=c051e000 task=c04d0380 
task.ti=c051e000)
[    0.021996] Stack: c0193339 c0267510 c051feec c026745f 00000000 
f782c228 f780b240 c051fefc
[    0.021996]        c026c6b3 f780b240 c051ff14 c0267690 00000000 
00000000 f782c200 f780b2a0
[    0.021996]        c051ff4c c026720e 00000001 f88055af f782c228 
00000000 f782c200 00000000



David
