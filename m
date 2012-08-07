Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755920Ab2HGRpu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 13:45:50 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:35248 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755853Ab2HGRpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 13:45:47 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Borislav Petkov <bp@amd64.org>, Robert Richter <robert.richter@amd.com>,
        mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org,
        "Petkov\, Borislav" <borislav.petkov@amd.com>
References: <1337644682-19854-1-git-send-email-suresh.b.siddha@intel.com>
	<tip-332afa656e76458ee9cf0f0d123016a0658539e4@git.kernel.org>
	<20120807153149.GI3732@erda.amd.com>
	<20120807154134.GA7456@aftab.osrc.amd.com>
	<1344356662.2041.48.camel@sbsiddha-desk.sc.intel.com>
Date: Tue, 07 Aug 2012 10:45:30 -0700
In-Reply-To: <1344356662.2041.48.camel@sbsiddha-desk.sc.intel.com> (Suresh
	Siddha's message of "Tue, 07 Aug 2012 09:24:21 -0700")
Message-ID: <87pq72a951.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+q72AFOL9vCGhl9Uf5bAuM3gpEtwrNbM8=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.5 BAYES_05 BODY: Bayes spam probability is 1 to 5%
	*      [score: 0.0355]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_XMDrugObfuBody_14 obfuscated drug references
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Suresh Siddha <suresh.b.siddha@intel.com>
X-Spam-Relay-Country: 
Subject: Re: do_IRQ: 1.55 No irq handler for vector (irq -1)
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suresh Siddha <suresh.b.siddha@intel.com> writes:

> On Tue, 2012-08-07 at 17:41 +0200, Borislav Petkov wrote:
>> On Tue, Aug 07, 2012 at 05:31:49PM +0200, Robert Richter wrote:
>> > On 06.06.12 08:03:58, tip-bot for Suresh Siddha wrote:
>> > > Commit-ID:  332afa656e76458ee9cf0f0d123016a0658539e4
>> > > Gitweb:     http://git.kernel.org/tip/332afa656e76458ee9cf0f0d123016a0658539e4
>> > > Author:     Suresh Siddha <suresh.b.siddha@intel.com>
>> > > AuthorDate: Mon, 21 May 2012 16:58:01 -0700
>> > > Committer:  Ingo Molnar <mingo@kernel.org>
>> > > CommitDate: Wed, 6 Jun 2012 09:51:22 +0200
>> > > 
>> > > x86/irq: Update irq_cfg domain unless the new affinity is a subset of the current domain
>> > 
>> > This commit causes a sata error and thus a boot failure:
>> > 
>> >  ACPI: Invalid Power Resource to register!ata1: lost interrupt (Status 0x50)
>> >  ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x40000000 action 0x6 frozen
>> >  ata1: SError: { }
>> >  ata1.00: failed command: READ DMA
>> > 
>> > Reverting it as following helped:
>> > 
>> >  $ git revert d872818dbbeed1bccf58c7f8c7db432154c802f9
>> >  $ git revert 1ac322d0b169c95ce34d55b3ed6d40ce1a5f3a02
>> >  $ git revert 332afa656e76458ee9cf0f0d123016a0658539e4
>> 
>> Right,
>> 
>> and it is a good thing Robert and I were talking about his issue and I
>> mentioned seeing funny do_IRQ messages during 3.6-rc1 boot:
>> 
>> [    0.170256] AMD PMU driver.
>> [    0.170451] ... version:                0
>> [    0.170683] ... bit width:              48
>> [    0.170906] ... generic registers:      6
>> [    0.171125] ... value mask:             0000ffffffffffff
>> [    0.171399] ... max period:             00007fffffffffff
>> [    0.171673] ... fixed-purpose events:   0
>> [    0.171902] ... event mask:             000000000000003f
>> [    0.172687] MCE: In-kernel MCE decoding enabled.
>> [    0.184214] [Firmware Info]: CPU: Re-enabling disabled Topology Extensions Support
>> [    0.186687] do_IRQ: 1.55 No irq handler for vector (irq -1)				<---
>> [    0.198126] [Firmware Info]: CPU: Re-enabling disabled Topology Extensions Support
>> [    0.200579] do_IRQ: 2.55 No irq handler for vector (irq -1)				<---
>> [    0.173040] smpboot: Booting Node   0, Processors  #1 #2 #3 OK
>> [    0.212083] [Firmware Info]: CPU: Re-enabling disabled Topology Extensions Support
>> [    0.214538] do_IRQ: 3.55 No irq handler for vector (irq -1)				<---
>> [    0.214864] Brought up 4 CPUs
>> 
>> of it now having IRQ handler for vector 55.
>> 
>> And guess what: reverting those three above make the message go away
>> too.
>> 
>
> Boris, Robert, Can you please send me the complete dmesg
> and /proc/interrupts on a successful boot?

Hmm.  I wonder if this is one of those cases where the apics don't honor
the masks in lowest priority delivery mode and simply deliver to some
cpu in the same die.

Certainly outside of x2apic mode I have seen that happen and that is why
the reservation in lowest priroity delivery mode was for the same vector
across all cpus.

This certainly looks like we have one irq going across multiple cpus
and the software simply appears unprepared for the irq to show up where
the irq is showing up.

Eric
