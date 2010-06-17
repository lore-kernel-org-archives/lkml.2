Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933129Ab0FQRCi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 13:02:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34949 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933084Ab0FQRCh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 13:02:37 -0400
Message-ID: <4C1A54C8.7020909@zytor.com>
Date: Thu, 17 Jun 2010 10:00:56 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       "kerstin.jonsson" <kerstin.jonsson@ericsson.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "jbohac@novell.com" <jbohac@novell.com>,
       Yinghai Lu <yinghai@kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
       Avi Kivity <avi@redhat.com>, "trenn@suse.de" <trenn@suse.de>
Subject: Re: [PATCH] x86 apic: Ack all pending irqs when crashed/on kexec
 - V5
References: <4B96116A.6090705@ericsson.com> <1268131954-13845-1-git-send-email-trenn@suse.de> <m11vfhaz24.fsf@fess.ebiederm.org> <m1pr2z8pe9.fsf@fess.ebiederm.org> <4BA75473.8090400@ericsson.com> <m1fx3swno3.fsf@fess.ebiederm.org> <43F901BD926A4E43B106BF17856F0755E7C393B9@orsmsx508.amr.corp.intel.com> <4C196A2F.5010604@zytor.com> <43F901BD926A4E43B106BF17856F0755E7C3985D@orsmsx508.amr.corp.intel.com>
In-Reply-To: <43F901BD926A4E43B106BF17856F0755E7C3985D@orsmsx508.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2010 09:52 AM, Pan, Jacob jun wrote:
>> On 06/16/2010 02:11 PM, Pan, Jacob jun wrote:
>>>
>>> W.R.T. the loop limits, is it possible to use a default max_loops
>> value in
>>> case when cpu_khz is not set? The reason is that on Moorestown
>> platform
>>> we need to do an early APIC setup before tsc_init(), so cpu_khz is 0
>> at the
>>> time we setup local APIC. The result is that we hit
>> WARN_ON(max_loops<= 0)
>>> on Moorestown for early APIC setup.
>>>
>>> The early APIC setup is needed because Moorestown does not have a PIT
>> and the
>>> system timer interrupts are routed via IOAPIC.
>>>
>>
>> Can't MRST install a quick ballpark value into cpu_khz?
>>
> yes, we can do that to avoid the warning. the true cpu_khz can then be set
> in tsc_init by platform specific calibration code. That is one option.
> 

Seems like a reasonable thing to do to me.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

