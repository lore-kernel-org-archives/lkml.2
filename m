Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753105Ab1FXNDR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 09:03:17 -0400
Received: from mail.windriver.com ([147.11.1.11]:32966 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007Ab1FXNDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 09:03:15 -0400
Message-ID: <4E048AEF.6010708@windriver.com>
Date: Fri, 24 Jun 2011 09:02:39 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110516 Thunderbird/3.1.10
MIME-Version: 1.0
To: Robert Richter <robert.richter@amd.com>
CC: "stable@kernel.org" <stable@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable-review@kernel.org" <stable-review@kernel.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [34-longterm 228/247] arch/x86/oprofile/op_model_amd.c: Perform
 initialisation on a single CPU
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com> <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com> <1308850515-15242-169-git-send-email-paul.gortmaker@windriver.com> <20110624092302.GI20052@erda.amd.com>
In-Reply-To: <20110624092302.GI20052@erda.amd.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-06-24 05:23 AM, Robert Richter wrote:
> On 23.06.11 13:34:56, Paul Gortmaker wrote:
>> From: Robert Richter <robert.richter@amd.com>
>>
>>                    -------------------
>>     This is a commit scheduled for the next v2.6.34 longterm release.
>>     If you see a problem with using this for longterm, please comment.
>>                    -------------------
>>
>> commit c7c25802b39c443b3745cfa973dc49a97a3491f8 upstream.
>>
>> Disable preemption in init_ibs(). The function only checks the
>> ibs capabilities and sets up pci devices (if necessary). It runs
>> only on one cpu but operates with the local APIC and some MSRs,
>> thus it is better to disable preemption.
>>
>> [    7.034377] BUG: using smp_processor_id() in preemptible [00000000] code: modprobe/483
>> [    7.034385] caller is setup_APIC_eilvt+0x155/0x180
>> [    7.034389] Pid: 483, comm: modprobe Not tainted 2.6.37-rc1-20101110+ #1
>> [    7.034392] Call Trace:
>> [    7.034400]  [<ffffffff812a2b72>] debug_smp_processor_id+0xd2/0xf0
>> [    7.034404]  [<ffffffff8101e985>] setup_APIC_eilvt+0x155/0x180
>> [ ... ]
>>
>> Addresses https://bugzilla.kernel.org/show_bug.cgi?id=22812
>>
>> Reported-by: <atswartz@gmail.com>
>> Signed-off-by: Robert Richter <robert.richter@amd.com>
>> Cc: oprofile-list@lists.sourceforge.net <oprofile-list@lists.sourceforge.net>
>> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
>> Cc: Frederic Weisbecker <fweisbec@gmail.com>
>> Cc: Rafael J. Wysocki <rjw@sisk.pl>
>> Cc: Dan Carpenter <error27@gmail.com>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> LKML-Reference: <20110103111514.GM4739@erda.amd.com>
>> [ small cleanups ]
>> Signed-off-by: Ingo Molnar <mingo@elte.hu>
>> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
>> ---
>>  arch/x86/oprofile/op_model_amd.c |   24 ++++++++++++++++--------
>>  1 files changed, 16 insertions(+), 8 deletions(-)
> 
> This patch introduces a sleeping-while-atomic bug. There is another
> upstream fix on top, see:
> 
> commit 3d2606f42984613d324ad3047cf503bcddc3880a
> Author: Robert Richter <robert.richter@amd.com>
> Date:   Fri May 20 09:46:54 2011 +0200
> 
>     oprofile, x86: Enable preemption during pci device setup in IBS init
> 
> This fix should be applied too (or instead).

Thanks Robert.  I guess I'll end up dropping c7c25802b39c
then.  I just did a quick test and it appears the 2.6.34
code base is too old for me to be able to apply 3d2606f4298
in anything close to resembling its original form.

Paul.

> 
> -Robert
> 
