Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760094Ab0ENXYA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 19:24:00 -0400
Received: from relay2.sgi.com ([192.48.179.30]:36256 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759939Ab0ENXX4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 19:23:56 -0400
Message-ID: <4BEDDB88.6000608@sgi.com>
Date: Fri, 14 May 2010 16:23:52 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Bjorn Helgaas <bjorn.helgaas@hp.com>, Mike Habeck <habeck@sgi.com>,
       Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
       Jacob Pan <jacob.jun.pan@intel.com>, Tejun Heo <tj@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Yinghai <yinghai.lu@oracle.com>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Myron Stowe <myron.stowe@hp.com>
Subject: Re: [Patch 1/1] x86 pci: Add option to not assign BAR's if not already
 assigned
References: <4BEAF008.9030805@sgi.com>	<201005131256.17997.bjorn.helgaas@hp.com>	<4BEC5530.1000008@sgi.com>	<201005131402.30759.bjorn.helgaas@hp.com>	<20100514152509.3aeb37b4@virtuousgeek.org>	<4BEDCFD9.7020202@sgi.com>	<20100514154706.4f36f4ed@virtuousgeek.org>	<4BEDD5BF.5030005@sgi.com> <20100514160651.2b4ee3d7@virtuousgeek.org>
In-Reply-To: <20100514160651.2b4ee3d7@virtuousgeek.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Jesse Barnes wrote:
> On Fri, 14 May 2010 15:59:11 -0700
> Mike Travis <travis@sgi.com> wrote:
> 
>>
>> Jesse Barnes wrote:
>>> On Fri, 14 May 2010 15:34:01 -0700
>>> Mike Travis <travis@sgi.com> wrote:
>>>
>>>> Jesse Barnes wrote:
>>>>> On Thu, 13 May 2010 14:02:30 -0600
>>>>> Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
>>>>>>>> This issue is not specific to x86, so I don't really like having
>>>>>>>> the implementation be x86-specific.
>>>>>>> I agree this isn't a x86 specific issue but given the 'norom'
>>>>>>> cmdline option is basically doing the same thing (but for pci
>>>>>>> Expansion ROM BARs) this code was modeled after it.
>>>>>> IMHO, we should fix both.
>>>>> Yeah, that would be good.  Mike, have you looked at this at all?
>>>>>
>>>>> Also, to clarify, this isn't affecting users today, right?  Or do you
>>>>> need all this I/O space for multiple IOHs and the drivers that bind to
>>>>> them in current UV systems?
>>>> We have customers that want to install more than 16 PCI-e cards right
>>>> now.  Our window of opportunity closes very soon (days), so either this
>>>> patch makes it in as is (or something close), or we wait for another
>>>> release cycle.  UV shipments start this month.
>>>>
>>>> [I wouldn't mind working on an improvement for later.]
>>> Wow and they're using cards that want to use I/O space?  Funky.  It's
>>> too late to get this into 2.6.34, but that can't be what you were
>>> expecting... I don't see a problem with getting something like this in
>>> for 2.6.35.
>> 2.6.35 would be fine.  It's the acceptance that's the key.
>>
>> And yes, we're using standard cards like everyone else... ;-)
>>
>> [The message is "UV" is just a really, really big PC. ;-)]
>>
>> I would appreciate however, some more detail on what's the goal of the
>> updates to "fix both".  Thanks!
> 
> As Bjorn noted, both the norom and nobar options are listed as x86
> specific in the documentation and use x86 specific flags and code to
> prevent their respective allocations.
> 
> It would be good if we could move the flags and code to the common PCI
> layer in drivers/pci so that other arches could take advantage of it,
> and we could have less resource management fragmentation.
> 

Thanks!  I was hoping you weren't going to say we need to remove the
need for these options.

I think the dynamic provisioning thing would be a great feature for the
future, but it seems to me that it would entail quite a bit of coordinated
effort between BIOS and the kernel?  Not to mention the final death of
all POST related initialization (at least in the case where the device
is not being used in Legacy mode)?  [Heck, can we kill POST too?!?] I
haven't looked too closely at non-x86 arch's but unless they run an
x86 emulator, then the POST initialization is pretty much superfluous,
isn't it?  The drivers will initialize when the device comes online?
I mean we do have more the 64k of memory now... ;-)]

Thanks,
Mike




