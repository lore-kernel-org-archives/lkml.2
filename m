Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672Ab3ABLrq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 06:47:46 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:53275 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090Ab3ABLro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 06:47:44 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Cooper <andrew.cooper3@citrix.com>
Cc: "x86\@kernel.org" <x86@kernel.org>,
        "konrad.wilk\@oracle.com" <konrad.wilk@oracle.com>,
        Daniel Kiper <daniel.kiper@oracle.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "kexec\@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization\@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        "mingo\@redhat.com" <mingo@redhat.com>,
        "jbeulich\@suse.com" <jbeulich@suse.com>,
        "maxim.uvarov\@oracle.com" <maxim.uvarov@oracle.com>,
        "tglx\@linutronix.de" <tglx@linutronix.de>,
        "xen-devel\@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "vgoyal\@redhat.com" <vgoyal@redhat.com>
References: <1356574740-6806-1-git-send-email-daniel.kiper@oracle.com>
	<50DBC856.6030208@zytor.com>
	<791b4922-078f-4adc-b3f3-0651f2266147@email.android.com>
	<50DC58C4.3000307@citrix.com> <874nj7qsor.fsf@xmission.com>
	<50E41973.9050705@citrix.com>
Date: Wed, 02 Jan 2013 03:47:28 -0800
In-Reply-To: <50E41973.9050705@citrix.com> (Andrew Cooper's message of "Wed, 2
	Jan 2013 11:26:43 +0000")
Message-ID: <87r4m3yffz.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19BBcukmbG3/h2Q3o6P1It315cW1Z9brSY=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andrew Cooper <andrew.cooper3@citrix.com>
X-Spam-Relay-Country: 
Subject: Re: [Xen-devel] [PATCH v3 00/11] xen: Initial kexec/kdump implementation
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Cooper <andrew.cooper3@citrix.com> writes:

> On 27/12/12 18:02, Eric W. Biederman wrote:
>> Andrew Cooper<andrew.cooper3@citrix.com>  writes:
>>
>>> On 27/12/2012 07:53, Eric W. Biederman wrote:
>>>> The syscall ABI still has the wrong semantics.
>>>>
>>>> Aka totally unmaintainable and umergeable.
>>>>
>>>> The concept of domU support is also strange.  What does domU support even mean, when the dom0 support is loading a kernel to pick up Xen when Xen falls over.
>>> There are two requirements pulling at this patch series, but I agree
>>> that we need to clarify them.
>> It probably make sense to split them apart a little even.
>>
>>
>
> Thinking about this split, there might be a way to simply it even more.
>
> /sbin/kexec can load the "Xen" crash kernel itself by issuing
> hypercalls using /dev/xen/privcmd.  This would remove the need for the
> dom0 kernel to distinguish between loading a crash kernel for itself
> and loading a kernel for Xen.
>
> Or is this just a silly idea complicating the matter?

At a first approximation it sounds reasonable.

If the Xen kexec actually copies the loaded kernel to somewhere internal
like the linux kexec that would be entirely reasonable.  If Xen has
other requirements on the dom0 case you might not be able to implement
the call without linux kernel support.

But if you can implement it all in terms of /dev/xen/privcmd go for it.

Eric

