Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757805Ab0FIOXs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 10:23:48 -0400
Received: from relay3.sgi.com ([192.48.152.1]:50047 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757757Ab0FIOXr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 10:23:47 -0400
Message-ID: <4C0FA3F0.6040609@sgi.com>
Date: Wed, 09 Jun 2010 09:23:44 -0500
From: Mike Habeck <habeck@sgi.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Mike Travis <travis@sgi.com>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
       Jacob Pan <jacob.jun.pan@intel.com>, Tejun Heo <tj@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
Subject: Re: [Patch 1/1] x86 pci: Add option to not assign BAR's if not already
 assigned
References: <4BEAF008.9030805@sgi.com>	<201006011649.56074.bjorn.helgaas@hp.com>	<4C0608C6.4090901@zytor.com>	<201006020945.09107.bjorn.helgaas@hp.com>	<4C067D0B.7030804@zytor.com>	<20100602085327.71dfaca0@virtuousgeek.org>	<4C0EE5FF.5080003@zytor.com> <20100608182633.582fb650@virtuousgeek.org>
In-Reply-To: <20100608182633.582fb650@virtuousgeek.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes wrote:
> On Tue, 08 Jun 2010 17:53:19 -0700
> "H. Peter Anvin" <hpa@zytor.com> wrote:
> 
>> On 06/02/2010 08:53 AM, Jesse Barnes wrote:
>>>> That's what I thought, which I guess means my original question to Mike 
>>>> still stands...
>>> I thought the whole reason for this was hotplug; we don't want to
>>> exhaust I/O space unnecessarily by allocating resources for BARs the
>>> BIOS didn't assign so we can keep them around for later hotplug
>>> activity.
>>>
>>> If there's some other issue, it's not too late to drop this patch.
>>>
>> Okay, now... this means that if a device that the BIOS doesn't know
>> about, but which needs I/O addresses, then it will work if hotplugged,
>> but not if it is plugged in on system boot?
> 
> Depends on the BIOS interactions on this platform; if the kernel ends
> up doing all the allocations itself, we'll allocate space for every BAR
> unconditionally, meaning that any hotplugged device should work.

Correct, our BIOS allocates I/O space for all devices except for a
few that it knows don't use it.  On a hotplug attach the kernel
will be unconditionally allocating the I/O space for all devices..
The pci=nobar option strictly prevents the kernel from allocating
BAR resources to device BARs that the BIOS didn't assign (similar
to how the pci=norom option works for the device's ROM BAR)

> 
> But really the SGI guys should comment here.
> 

