Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756904Ab2CLT5y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 15:57:54 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:59544 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756171Ab2CLT5w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 15:57:52 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Fernando Luis =?utf-8?Q?V=C3=A1zquez?= Cao 
	<fernando@oss.ntt.co.jp>,
        Don Zickus <dzickus@redhat.com>, linux-tip-commits@vger.kernel.org,
        torvalds@linux-foundation.org, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
        mingo@elte.hu, Yinghai Lu <yinghai@kernel.org>,
        akpm@linux-foundation.org, vgoyal@redhat.com
References: <CAE9FiQVPnO8-tuPoio0Wxv=8rjdm2tJbBk3+3ystueyYtZn9BA@mail.gmail.com>
	<CAE9FiQVhbAM9vjx-uFcuc0ndsUp0aez9_TsQHStje5G5iwYbag@mail.gmail.com>
	<20120216215603.GH9751@redhat.com> <m1y5s2ku36.fsf@fess.ebiederm.org>
	<m1fwe9bpk2.fsf@fess.ebiederm.org> <20120217195430.GO9751@redhat.com>
	<m1y5s07rn3.fsf@fess.ebiederm.org> <20120220151419.GU9751@redhat.com>
	<m1obss39a4.fsf@fess.ebiederm.org> <20120221135934.GF26998@redhat.com>
	<m1ipip6xe8.fsf@fess.ebiederm.org> <4F573E1C.2060909@oss.ntt.co.jp>
	<4F573E74.5040504@oss.ntt.co.jp> <m1eht31z8e.fsf@fess.ebiederm.org>
	<4F58495B.5080308@oss.ntt.co.jp> <m1r4x3yrsv.fsf@fess.ebiederm.org>
	<4F5A6D87.4050809@zytor.com> <4F5D8D0E.8060702@oss.ntt.co.jp>
	<4F5D8E63.60606@zytor.com> <4F5D943C.5020403@oss.ntt.co.jp>
	<4F5E431D.8010305@zytor.com>
Date: Mon, 12 Mar 2012 13:01:12 -0700
In-Reply-To: <4F5E431D.8010305@zytor.com> (H. Peter Anvin's message of "Mon,
	12 Mar 2012 11:40:29 -0700")
Message-ID: <m1zkblmvw7.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX193MmGcUsvYEsuinXjP4D/XolcLVlP2Rlk=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.1 XMSolicitRefs_0 Weightloss drug
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"H. Peter Anvin" <hpa@zytor.com>
X-Spam-Relay-Country: **
Subject: Re: [PATCH 1/2] boot: ignore early NMIs
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> On 03/11/2012 11:14 PM, Fernando Luis Vázquez Cao wrote:
>> 
>> The thing is that we want to avoid playing with hardware in the kdump
>> reboot patch when we can avoid it, the premise being that it cannot
>> be accessed without risking a lockup or worse (as the deadlock accessing
>> the I/O APIC showed). The kernel is crashing after all. What is more,
>> I forgot to mention that the long term goal is to leave the LAPIC
>> untouched too (we really want to keep the number of things we do in the
>> context of the crashing kernel to the bare minimum), so we would still
>> need to fix the early IDT.
>> 
>> My patch set just installs a special handler for the NMI case so I think
>> it is pretty simple and self contained.
>> 
>> Another reason to apply these patches is to be consistent with the rest
>> of the kernel. Spurious NMIs that would have been ignored after installing
>> the final IDT would cause the system to halt if they happen
>> to arrive while the early IDT is in place.
>> 
>
> I'm concerned that you're adding failure modes because you don't want to
> solve the real problem which is you need to block this at the source.
> It is way more than the IDT that has to work (at the very least, you
> need the GDT and a working stack) at all times in order for NMIs to be
> receivable.  That doesn't address what happens if you're getting an NMI
> storm either.

Good criticism.

The basic problem is what do we do when we receive NMIs during the
kernel boot.  Dying mysteriously certainly isn't a good solution.

In the kexec on panic code path we already have a stack and as long
as we can fit the GDT and the LDT on that same page we can have all of
the rest during the entire transition.

After that is basically the kernel's boot code.

The basic problem is which source do we block this at?  How many
sources are their?  And architecturally last I looked x86 no longer
has a NMI disable EFI and similar systems want to get away without
a CMOS legacy clock because designers so often get them wrong.

Eric
