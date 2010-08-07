Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762497Ab0HGCtP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 22:49:15 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:41921 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762474Ab0HGCtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 22:49:13 -0400
To: Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, mingo@redhat.com,
        linux-kernel@vger.kernel.org, tvrtko.ursulin@sophos.com,
        hilld@binarystorm.net, tglx@linutronix.de, hpa@linux.intel.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86, apic: Map the local apic when parsing the MP table.
References: <m1eiee86jg.fsf_-_@fess.ebiederm.org>
	<tip-5989cd6a1cbf86587edcc856791f960978087311@git.kernel.org>
	<4C5CA3E4.1080908@kernel.org> <4C5CA5AC.3060608@zytor.com>
	<m1d3tvtekq.fsf@fess.ebiederm.org> <4C5CB52A.9080102@zytor.com>
	<4C5CB71D.1040509@kernel.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 06 Aug 2010 19:49:04 -0700
In-Reply-To: <4C5CB71D.1040509@kernel.org> (Yinghai Lu's message of "Fri\, 06 Aug 2010 18\:30\:05 -0700")
Message-ID: <m1fwyrgmsf.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.188.4.80;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.188.4.80
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu <yinghai@kernel.org> writes:

> On 08/06/2010 06:21 PM, H. Peter Anvin wrote:
>> On 08/06/2010 06:08 PM, Eric W. Biederman wrote:
>>>>
>>>> I'm not sure the above is decipherable.  Please provide an incremental
>>>> patch with a more detailed description.
>>>
>>> YH was saying I overoptimized, and it looks like he is right,
>>> although there are only one or two machines in existence that
>>> are likely to be affected.
>>>
>>> Untested patch to remove the cleverness below.  It it boots all
>>> is well.
>>>
>> 
>> This makes sense to me.  Yinghai, do you have a system that is actually
>> affected, and if so, could you test this patch?
>
> no, i don't have those kind of system.

I don't know if anyone does.  It looks like sfi aka moorestown
and visws are what are affected.

That is why I made a patch that any boot where we exercise a local
apic will exercise.

Arguably if it is best to just remove that hunk from my patch, so
we have something that is safe to backport to 2.6.35.1.

> found it when i was preparing more smp_register_lapic_address patcheset.
>
> I suggest we still keep !acpi_lapic checking, that should always right.

Ultimately we want to remove the code duplication entirely.

Eric
