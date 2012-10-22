Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756204Ab2JVV3m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 17:29:42 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:56015 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755742Ab2JVV3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 17:29:41 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>, linux-kernel@vger.kernel.org,
        kexec@lists.infradead.org, x86@kernel.org, mingo@elte.hu,
        tglx@linutronix.de, len.brown@intel.com, fenghua.yu@intel.com,
        vgoyal@redhat.com, grant.likely@secretlab.ca, rob.herring@calxeda.com
References: <20121016043357.20003.5885.stgit@localhost6.localdomain6>
	<20121016043528.20003.601.stgit@localhost6.localdomain6>
	<873916i88t.fsf@xmission.com> <5085A9A8.5020004@zytor.com>
	<87fw56fduo.fsf@xmission.com> <5085AD7D.106@zytor.com>
	<87a9vedyqe.fsf@xmission.com> <5085B0D0.9020508@zytor.com>
Date: Mon, 22 Oct 2012 14:29:25 -0700
In-Reply-To: <5085B0D0.9020508@zytor.com> (H. Peter Anvin's message of "Mon,
	22 Oct 2012 13:47:12 -0700")
Message-ID: <87mwze8abu.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19rTCENVo+SSGIYlskhRodiI1LEKzP/9d4=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0005]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"H. Peter Anvin" <hpa@zytor.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH v1 2/2] x86, apic: Disable BSP if boot cpu is AP
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> On 10/22/2012 01:43 PM, Eric W. Biederman wrote:
>> 
>> The reason the BIOSen go wonky is the INIT cause the cpu to go to the
>> reset vector at 4G-16 bytes.  So it is very much expected that the
>> BIOSen start acting like you just came out of reset.
>> 
>> If you can clear bit 8 of IA32_APIC_BASE_MSR and inform the cpu to not
>> send the cpu to 4G-16 bytes and instead send the cpu into it's magic
>> startup-ipi-wait mode then the BIOSen will not be involved on that path.
>> 
>> It is a simple question of does the cpu support clearing bit 8
>> meaningfully.
>> 
>> If the cpu allows bit 8 to be cleared and sends the cpu to the reset
>> vector on receipt of the INIT IPI I would call that a deviation from the
>> x86 cpu specification.
>> 
>> So clearing bit 8 is not a question about BIOSen it is a question of can
>> we avoid the BIOSen, by using an obscure under-documented cpu feature.
>> 
>
> As I said, I thought Fenghua tried that but it didn't work, experimentally.

Fair enough.  You described the problem with clearing bit 8 in a weird
way.

If the best we can muster are fuzzy memories it may be worth revisiting.
Perhaps it works on enough cpu models to be interesting.

Eric

