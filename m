Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932545Ab2EJVm5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 17:42:57 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:64854 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932369Ab2EJVmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 17:42:51 -0400
Message-ID: <4FAC3647.8020203@landley.net>
Date: Thu, 10 May 2012 16:42:31 -0500
From: Rob Landley <rob@landley.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Alex Shi <alex.shi@intel.com>
CC: Borislav Petkov <bp@amd64.org>, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, arnd@arndb.de, rostedt@goodmis.org, fweisbec@gmail.com,
        jeremy@goop.org, gregkh@linuxfoundation.org, riel@redhat.com,
        luto@mit.edu, avi@redhat.com, len.brown@intel.com, dhowells@redhat.com,
        fenghua.yu@intel.com, ak@linux.intel.com, cpw@sgi.com, steiner@sgi.com,
        akpm@linux-foundation.org, penberg@kernel.org, hughd@google.com,
        rientjes@google.com, kosaki.motohiro@jp.fujitsu.com,
        n-horiguchi@ah.jp.nec.com, paul.gortmaker@windriver.com, trenn@suse.de,
        tj@kernel.org, oleg@redhat.com, axboe@kernel.dk,
        a.p.zijlstra@chello.nl, kamezawa.hiroyu@jp.fujitsu.com,
        viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 3/7] x86/flush_tlb: try flush_tlb_single one by one
 in flush_tlb_range
References: <1336626013-28413-1-git-send-email-alex.shi@intel.com> <1336626013-28413-4-git-send-email-alex.shi@intel.com> <20120510075325.GB30055@aftab.osrc.amd.com> <4FAB8169.7090809@intel.com>
In-Reply-To: <4FAB8169.7090809@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/10/2012 03:50 AM, Alex Shi wrote:
>>
> 
>> Ok, question:
>>
>> we're comparing TLB size with the amount of pages mapped by this mm
>> struct. AFAICT, that doesn't mean that all those mapped pages do have
>> respective entries in the TLB, does it?
>>
>> If so, then the actual entries number is kinda inaccurate, no? We don't
>> really know how many TLB entries actually belong to this mm struct. Or am I
>> missing something?
> 
> No, we can not know the exactly TLB entires for. But usually, when you
> process is doing the mprotect/munmap etc system call, your process has
> taken much of memory and already filled lots of TLB entries.

$ strace true 2>&1 | grep mprotect
mprotect(0x7f67a934b000, 2093056, PROT_NONE) = 0
mprotect(0x7f67a954a000, 16384, PROT_READ) = 0
mprotect(0x607000, 4096, PROT_READ)     = 0
mprotect(0x7f67a9773000, 4096, PROT_READ) = 0

This appears to be part of glibc process setup. Define "usually".

Rob
-- 
GNU/Linux isn't: Linux=GPLv2, GNU=GPLv3+, they can't share code.
Either it's "mere aggregation", or a license violation.  Pick one.
