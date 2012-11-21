Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755804Ab2KUTUh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 14:20:37 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:23508 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755566Ab2KUTUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 14:20:35 -0500
Message-ID: <50AD2953.5070700@oracle.com>
Date: Wed, 21 Nov 2012 14:19:47 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121112 Thunderbird/16.0.1
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, penberg@kernel.org
Subject: Re: [PATCH] x86, smpboot: allow manual hotplug of CPUs
References: <1353522136-14944-1-git-send-email-sasha.levin@oracle.com> <50AD1CB6.9030707@zytor.com> <50AD1EE7.6020304@oracle.com> <50AD1F88.1010006@zytor.com>
In-Reply-To: <50AD1F88.1010006@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/2012 01:38 PM, H. Peter Anvin wrote:
> On 11/21/2012 10:35 AM, Sasha Levin wrote:
>>>
>>> Reading between the lines, this sounds like would cause a user-visible
>>> difference between mptable platforms and ACPI platforms?  If so, that is
>>> totally unacceptable.  If not, the description is confusing.
>>
>> With ACPI platforms you don't need probe/release because the hardware notifies
>> on CPU insert/eject - this doesn't exist on mptable which is why you have to
>> do it manually with probe/release.
>>
>> The difference is already user visible: you can hotplug on ACPI, but can't on
>> mptables.
>>
>> Yes, reading back the subject does sound confusing - a better one would probably
>> be "provide interface for CPU hotplug on mptable platforms" or something similar.
>>
> 
> So, are there any mptables platforms which support hotplug?  If the
> answer is "KVM" then the answer is that KVM needs to move to ACPI to get
> the proper functionality; putting a hack in is really not okay.

There are no platforms which support actual hotplug, but you can still set
existing processors as disabled in the table and without this patch there's
no way enable them.

I'm not sure if it's a "hack" though - the presentation of hotpluggable cpus
is the almost the same between mptable and acpi, and acpi provides a way to
manually probe/release cpus as well. The only difference is that acpi also
provides notifications about such events.

Actually, maybe acpi should start using probe/release as well... hmm...


Thanks,
Sasha
