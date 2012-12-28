Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247Ab2L1DRD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 22:17:03 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:57443 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125Ab2L1DRC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 22:17:02 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Daniel Kiper <daniel.kiper@oracle.com>, kexec@lists.infradead.org,
        xen-devel@lists.xensource.com, konrad.wilk@oracle.com,
        tglx@linutronix.de, maxim.uvarov@oracle.com, andrew.cooper3@citrix.com,
        jbeulich@suse.com, mingo@redhat.com, x86@kernel.org,
        virtualization@lists.linux-foundation.org, vgoyal@redhat.com,
        linux-kernel@vger.kernel.org
References: <5698071f-c96c-4891-81d6-a77c4e3b77c2@default>
	<50DCDBD3.1020703@zytor.com>
Date: Thu, 27 Dec 2012 19:16:46 -0800
In-Reply-To: <50DCDBD3.1020703@zytor.com> (H. Peter Anvin's message of "Thu,
	27 Dec 2012 15:37:55 -0800")
Message-ID: <87han6n9wh.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/F1tbWEEceGoJXUWc2fmBDWHR7nPNYdvE=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"H. Peter Anvin" <hpa@zytor.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH v3 06/11] x86/xen: Add i386 kexec/kdump implementation
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> On 12/27/2012 03:23 PM, Daniel Kiper wrote:
>>> On 12/26/2012 06:18 PM, Daniel Kiper wrote:
>>>> Add i386 kexec/kdump implementation.
>>>>
>>>> v2 - suggestions/fixes:
>>>>      - allocate transition page table pages below 4 GiB
>>>>        (suggested by Jan Beulich).
>>>
>>> Why?
>>
>> Sadly all addresses are passed via unsigned long
>> variable to kexec hypercall.
>>
>
> So can you unf*ck your broken interface before imposing it on anyone
> else?

Hasn't 32bit dom0 been retired?

Untill the kexec firmware pass through and the normal kexec code paths
are separated I can't make sense out of this code.

The normal kexec code path should be doable without any special
constraints on the kernel.  Just leaning on some xen paravirt calls.

The kexec pass through probably should not even touch x86 arch code.

Certainly the same patch should not have code for both the xen kexec
pass through and the paravirt arch code for the normal kexec path.

Eric
