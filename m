Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171Ab2JVUR0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 16:17:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35867 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755782Ab2JVURY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 16:17:24 -0400
Message-ID: <5085A9A8.5020004@zytor.com>
Date: Mon, 22 Oct 2012 13:16:40 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>, linux-kernel@vger.kernel.org,
        kexec@lists.infradead.org, x86@kernel.org, mingo@elte.hu,
        tglx@linutronix.de, len.brown@intel.com, fenghua.yu@intel.com,
        vgoyal@redhat.com, grant.likely@secretlab.ca, rob.herring@calxeda.com
Subject: Re: [PATCH v1 2/2] x86, apic: Disable BSP if boot cpu is AP
References: <20121016043357.20003.5885.stgit@localhost6.localdomain6> <20121016043528.20003.601.stgit@localhost6.localdomain6> <873916i88t.fsf@xmission.com>
In-Reply-To: <873916i88t.fsf@xmission.com>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2012 01:04 PM, Eric W. Biederman wrote:
> HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com> writes:
> 
>> We disable BSP if boot cpu is AP.
>>
>> INIT-INIT-SIPI sequence, a protocal to initiate AP, cannot be used for
>> BSP since it causes BSP jump to BIOS init code; typical visible
>> behaviour is hang or immediate reset, depending on the BIOS init code.
>>
>> INIT can be used to reset AP in a fatal system error state as
>> described in MP spec 3.7.3 Processor-specific INIT. In contrast, there
>> is no processor-specific INIT for BSP to initilize from a fatal system
>> error. It might be possible to do so by NMI plus any hand-crafted
>> reset code that is carefully designed, but at least I have no idea in
>> this direction now.
> 
> Has anyone looked at clearing bit 8 of the IA32_APIC_BASE_MSR (0x1B) on
> the bootstrap processor?  Bit 8 being the bit that indicates we are a
> bootstrap processor.
> 
> If we can clear that bit INIT will always place the processor in
> wait-for-startup-ipi mode and we won't have this problem.
> 
> That would also solve the hotunplug the bootstrap processor without
> using an NMI as well.
> 

IIRC Fenghua experimented with that and it didn't work.  Not all BIOSes
use that bit to determine BSP-ness.

	-hpa

