Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755810Ab1H3QhR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 12:37:17 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38599 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755763Ab1H3QhP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 12:37:15 -0400
MIME-Version: 1.0
In-Reply-To: <20110830122630.GA19450@amt.cnet>
References: <1314660435-23293-1-git-send-email-emunson@mgebm.net>
	<20110830122630.GA19450@amt.cnet>
Date: Tue, 30 Aug 2011 10:37:13 -0600
Message-ID: <CAKu_SN2rYCgjCAydf0B_78QgYnT4yHTLZ3G7-qAXOUSgxXYkQA@mail.gmail.com>
Subject: Re: [PATCH 0/4] Avoid soft lockup message when KVM is stopped by host
From: Eric B Munson <emunson@mgebm.net>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: avi@redhat.com, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        arnd@arndb.de, riel@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        kvm-ppc@vger.kernel.org, aliguori@us.ibm.com, raharper@us.ibm.com,
        kvm-ia64@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 30, 2011 at 06:26, Marcelo Tosatti <mtosatti@redhat.com> wrote:
> On Mon, Aug 29, 2011 at 05:27:11PM -0600, Eric B Munson wrote:
>> Currently, when qemu stops a guest kernel that guest will issue a soft lockup
>> message when it resumes.  This set provides the ability for qemu to comminucate
>> to the guest that it has been stopped.  When the guest hits the watchdog on
>> resume it will check if it was suspended before issuing the warning.
>>
>> Eric B Munson (4):
>>   Add flag to indicate that a vm was stopped by the host
>>   Add functions to check if the host has stopped the vm
>>   Add generic stubs for kvm stop check functions
>>   Add check for suspended vm in softlockup detector
>>
>>  arch/x86/include/asm/pvclock-abi.h |    1 +
>>  arch/x86/include/asm/pvclock.h     |    2 ++
>>  arch/x86/kernel/kvmclock.c         |   14 ++++++++++++++
>>  include/asm-generic/pvclock.h      |   14 ++++++++++++++
>>  kernel/watchdog.c                  |   12 ++++++++++++
>>  5 files changed, 43 insertions(+), 0 deletions(-)
>>  create mode 100644 include/asm-generic/pvclock.h
>>
>> --
>> 1.7.4.1
>
> How is the host supposed to set this flag?

The hypervisor will set the flag (the second bit in the struct
pvclock_vcpu_time_info.flags field) when it stops the guest.  I could
be reading pvclock-abi.h incorrectly, but the way I understand it is
that this structure is used to communicate between hypervisor and
guest.

>
> As mentioned previously, if you save save/restore the offset added to
> kvmclock on stop/cont (and the TSC MSR, forgot to mention that), no
> paravirt infrastructure is required. Which means the issue is also fixed
> for older guests.
>
