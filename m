Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752173Ab2H3Jth (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 05:49:37 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:41281 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103Ab2H3Jtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 05:49:35 -0400
Message-ID: <503F36C4.50004@linux.vnet.ibm.com>
Date: Thu, 30 Aug 2012 15:17:48 +0530
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: "Luck, Tony" <tony.luck@intel.com>, Borislav Petkov <bp@amd64.org>
CC: "andi@firstfloor.org" <andi@firstfloor.org>,
        "ananth@in.ibm.com" <ananth@in.ibm.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>
Subject: Re: [PATCH RFC] x86/mce: Move MCE sysfs attributes out of the per-cpu
 location
References: <20120829074154.6755.98941.stgit@localhost.localdomain> <20120829101302.GA26977@aftab.osrc.amd.com> <3908561D78D1C84285E8C5FCA982C28F193989D6@ORSMSX104.amr.corp.intel.com>
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F193989D6@ORSMSX104.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12083009-5816-0000-0000-000004379573
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29/2012 08:13 PM, Luck, Tony wrote:
>> Note: I'm not sure if it's ok to change sysfs entries and this does break
>> userspace tools that depend on the current path for some of these attributes.
>> So, they will need to be updated to use the new path. However, if we ever get
>> to a point where cpu0 can be offlined, these tools will need to be updated
>> anyway (as they mostly hardcode machinecheck0 currently)
>
> Linus' clarified his "never break user space" edict at the kernel summit
> on Monday. Paraphrasing:
>
>    If nobody notices, or nobody complains, then we can make changes. But
>    if anyone does complain, then the patch gets reverted.
>
> So if you want to do this, the right approach would be to change the
> utilities that use this to look in the new location for these sysfs files
> first, and fall back to looking in the old per-cpu place.
>
> Next (or in parallel) have the kernel provide both interfaces.
>
> Wait a long[1] time so that most people have updated utilities.
>
> Delete the per-cpu interfaces from the kernel.
>
> Delete the per-cpu references from the utilities.
>
> -Tony
>
> [1] Long enough that there are no complaints. At least a year, probably two or more.
>

Makes sense. Thanks for the explanation. I will send a new patch for this.


Thanks,
Naveen

