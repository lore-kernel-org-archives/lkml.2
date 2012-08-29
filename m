Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752902Ab2H2K2L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 06:28:11 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:60670 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641Ab2H2K2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 06:28:09 -0400
Message-ID: <503DEE3C.6020406@linux.vnet.ibm.com>
Date: Wed, 29 Aug 2012 15:56:04 +0530
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: tony.luck@intel.com, andi@firstfloor.org, ananth@in.ibm.com,
        x86@kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com,
        hpa@zytor.com, tglx@linutronix.de, linux-edac@vger.kernel.org
Subject: Re: [PATCH RFC] x86/mce: Move MCE sysfs attributes out of the per-cpu
 location
References: <20120829074154.6755.98941.stgit@localhost.localdomain> <20120829101302.GA26977@aftab.osrc.amd.com>
In-Reply-To: <20120829101302.GA26977@aftab.osrc.amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12082910-7014-0000-0000-000001CE9A6F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29/2012 03:43 PM, Borislav Petkov wrote:
> On Wed, Aug 29, 2012 at 01:11:55PM +0530, Naveen N. Rao wrote:
>> All the MCE attributes currently exported via sysfs appear under
>> /sys/devices/system/machinecheck/machinecheck<n>/. Pretty much all of these
>> are global in nature and not specific to a processor. We have around 7
>> attributes duplicated across each processor and on multi-core multi-socket
>> machines, this amounts to quite a large number. So, move these out under
>> /sys/devices/system/machinecheck/ where they rightly belong.
>>
>> Note: I'm not sure if it's ok to change sysfs entries and this does break
>> userspace tools that depend on the current path for some of these attributes.
>> So, they will need to be updated to use the new path. However, if we ever get
>> to a point where cpu0 can be offlined, these tools will need to be updated
>> anyway (as they mostly hardcode machinecheck0 currently)
>
> How do you know that for all tools out there?

I don't - I've seen mcelog and related tools and they look in machinecheck0.

>
> I know, I know, moving them to /sys/.../machinecheck/ is the right thing
> to do but they're exposed to userspace and we're breaking it with this
> patch. And we don't break userspace so I'd guess we're stuck with the
> current situation.

Hmmm.. Can't we just deprecate these? ;)
Perhaps we can consider adding newer tunables in the right place.


Thanks,
Naveen

>
> Sorry.
>

