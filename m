Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760180Ab0KRUI3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 15:08:29 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:31506 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760165Ab0KRUI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 15:08:27 -0500
Message-ID: <4CE5878F.2010609@kernel.org>
Date: Thu, 18 Nov 2010 12:07:43 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101026 SUSE/3.0.10 Thunderbird/3.0.10
MIME-Version: 1.0
To: Don Zickus <dzickus@redhat.com>
CC: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@elte.hu, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] x86, nmi_watchdog: Remove the old nmi_watchdog
References: <1289578944-28564-2-git-send-email-dzickus@redhat.com> <tip-5f2b0ba4d94b3ac23cbc4b7f675d98eb677a760a@git.kernel.org> <4CE57A4A.30200@kernel.org> <4CE58106.5070009@kernel.org> <20101118200250.GB8131@redhat.com>
In-Reply-To: <20101118200250.GB8131@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2010 12:02 PM, Don Zickus wrote:
> On Thu, Nov 18, 2010 at 11:39:50AM -0800, Yinghai Lu wrote:
>>>
>>> Please update the kernel-parameters.txt accordingly.
>>>
>>> and you need to keep unknown_nmi_panic or else as early_param().
>>>
>>> Also any corresponding part like "nmi_watchdog=off" ?
>>>
>>
>> also you have some other left-over...
>>
>> Documentation/kernel-parameters.txt:    unknown_nmi_panic
>> Documentation/kernel-parameters.txt:                    Set unknown_nmi_panic=1 early on boot.
>> Documentation/sysctl/kernel.txt:- unknown_nmi_panic
>> Documentation/sysctl/kernel.txt:unknown_nmi_panic:
>> arch/x86/include/asm/nmi.h:extern int unknown_nmi_panic;
>> arch/x86/kernel/apic/hw_nmi.c:int unknown_nmi_panic;
>> kernel/sysctl_binary.c: { CTL_INT,      KERN_UNKNOWN_NMI_PANIC,         "unknown_nmi_panic" },
>>
>> may still have left for nmi_watchdog too.
> 
> Yes the first part of the patch left in stubs.  The second piece should
> clean up stuff like nmi_watchdog.
> 
> On the other side unknown_nmi_panic is actually going to be added back in
> with another patch that re-arranges the default_do_nmi() call that I
> posted in another patch series.

those patches that you reposted from Huang Ying?

it seems there still have some arguments about that patchset. if that would take a while to get in.
Can you have a simple one to add back unknown_nmi_panic and nmi_watchdog=0 to early_param and sysctl?

Yinghai
