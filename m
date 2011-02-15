Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752147Ab1BOFqj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 00:46:39 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:19140 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193Ab1BOFqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 00:46:38 -0500
Message-ID: <4D5A12CA.3060908@kernel.org>
Date: Mon, 14 Feb 2011 21:44:42 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, David Rientjes <rientjes@google.com>
CC: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, x86@kernel.org,
        brgerst@gmail.com, gorcunov@gmail.com, shaohui.zheng@intel.com,
        rientjes@google.com, hpa@linux.intel.com, ankita@in.ibm.com
Subject: Re: [PATCHSET x86/numa] x86-64, NUMA: bring sanity to NUMA emulation
References: <1297711715-3086-1-git-send-email-tj@kernel.org> <AANLkTikNy-vQ2V95dhyQ8k1jkQCiUOukY8ShP_GWM1w6@mail.gmail.com> <20110215022842.GD31134@elte.hu>
In-Reply-To: <20110215022842.GD31134@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4D5A1329.003D,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14/2011 06:28 PM, Ingo Molnar wrote:
> 
> * Yinghai Lu <yinghai@kernel.org> wrote:
> 
>> On Mon, Feb 14, 2011 at 11:28 AM, Tejun Heo <tj@kernel.org> wrote:
>>> Hello,
>>>
>>> NUMA emulation is quite convoluted involving unnecessary mapping and
>>> reverse mapping between apicids, PXMs, nodes and memory addresses.
>>> This patchset tries to restore some sanity to the whole thing.
>>>
>>> Tested on an opteron NUMA machine which can do both ACPI and AMD
>>> configs.  All NUMA configs, emulations, !NUMA and UP work as expected.
>>>
>>> This patchset is on top of tip/x86/numa[1] +
>>> bring-sanity-to-NUMA-configuration patchset[2] and contains the
>>> following 7 patches.
>>>
>>>  0001-x86-64-NUMA-Trivial-changes-to-prepare-for-emulation.patch
>>>  0002-x86-64-NUMA-Build-and-use-direct-emulated-nid-phys-n.patch
>>>  0003-x86-64-NUMA-Make-emulation-code-build-numa_meminfo-a.patch
>>>  0004-x86-64-NUMA-Wrap-node-ID-during-emulation.patch
>>>  0005-x86-64-NUMA-Emulate-directly-from-numa_meminfo.patch
>>>  0006-x86-64-NUMA-Unify-emulated-apicid-node-mapping-trans.patch
>>>  0007-x86-64-NUMA-Unify-emulated-distance-mapping.patch
>>>
>>> The patchset is available in the following git branch.
>>>
>>>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git x86_64-numa-emu-unify
>>>
>>> Diffstat follows.
>>>
>>>  arch/x86/include/asm/acpi.h    |    6
>>>  arch/x86/include/asm/amd_nb.h  |    4
>>>  arch/x86/include/asm/numa_64.h |    1
>>>  arch/x86/mm/amdtopology_64.c   |   47 ----
>>>  arch/x86/mm/numa_64.c          |  429 ++++++++++++++++++-----------------------
>>>  arch/x86/mm/srat_64.c          |   87 --------
>>>  6 files changed, 197 insertions(+), 377 deletions(-)
>>
>> wonder if numa_emu code could be put into one single file like numa_emu.c
> 
> That would be nice if it can be done sanely.
> 
> We could do it as a delta, on top of these existing patches, to not delay the 
> testing of these fixes/improvements, they are looking pretty good (on paper) 
> already, do you agree?

yes.

I went through TJ's numa-unify patches, and it looks good to me.
<except that I don't like putting setup_bootmem() etc in numa_register_memblks,
 but that could be addressed later>

For the numa-emu-unify, may need David to have a look on them.

Thanks

Yinghai

