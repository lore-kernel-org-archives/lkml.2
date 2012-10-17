Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757407Ab2JQPsa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 11:48:30 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:60930 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756331Ab2JQPsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 11:48:20 -0400
Message-ID: <507ED31B.7010402@linux.vnet.ibm.com>
Date: Wed, 17 Oct 2012 21:17:39 +0530
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121012 Thunderbird/16.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, tony.luck@intel.com,
        gong.chen@linux.intel.com, ananth@in.ibm.com,
        masbock@linux.vnet.ibm.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, bp@amd64.org, lcm@us.ibm.com,
        andi@firstfloor.org, hpa@zytor.com, tglx@linutronix.de,
        mingo@redhat.com, gregkh@suse.de, linux-edac@vger.kernel.org
Subject: Re: [PATCH v3] x86/mce: Honour bios-set CMCI threshold
References: <CA+8MBbKVa0=qUpG-rjV5ieKkponZo77mzk_y_dF4qA2gVG++6A@mail.gmail.com> <20120912122516.3825.87838.stgit@localhost.localdomain> <505C51D8.6070402@linux.vnet.ibm.com> <20121017105940.GA14590@x1.osrc.amd.com> <507E9622.6090606@linux.vnet.ibm.com> <20121017130934.GB14590@x1.osrc.amd.com>
In-Reply-To: <20121017130934.GB14590@x1.osrc.amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12101715-8878-0000-0000-00000468FC54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/2012 06:39 PM, Borislav Petkov wrote:
> On Wed, Oct 17, 2012 at 04:57:30PM +0530, Naveen N. Rao wrote:
>> On 10/17/2012 04:29 PM, Borislav Petkov wrote:
>>>>>
>>>>> +static struct dev_ext_attribute dev_attr_bios_cmci_threshold = {
>>>>> +	__ATTR(bios_cmci_threshold, 0444, device_show_int, NULL),
>>>>> +	&mce_bios_cmci_threshold
>>>
>>> Ok, I just noticed this (we must've missed it during review) but why is
>>> this read-only? If it has to be read-only, why do we have a node for
>>> this in sysfs instead of simply issuing the printk statements below and
>>> people who are interested in this, can grep dmesg?
>>
>> This was added so that user-space tools could find out if we're
>> using thresholds for CMCI.
>
> That I figured out.
>
> What I can't figure out is why userspace tools need to know that - the
> fact that some MCI_CTL2 has a 0 CMCI threshold because BIOS forgot to
> set it correctly? IOW, this is a rather evolved workaround for b0rked
> BIOS (the gazillionth BIOS f*ckup, btw if someone is counting :)) and,
> on top of that, we have a read-only, special sysfs node which is pretty
> useless to me.
>
> Why?
>

This is not about the CMCI threshold being 0, but rather about the 
threshold not being 1. Linux used to program a threshold of 1 always but 
with this boot option, a firmware-set non-zero threshold is honoured.

Userspace tools need this sysfs attribute so they know how to react on 
receipt of a corrected error event: whether this is the first event or 
if such events have already been threshold-ed.


Regards,
Naveen

