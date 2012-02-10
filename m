Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758277Ab2BJRTo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 12:19:44 -0500
Received: from mga09.intel.com ([134.134.136.24]:32584 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754806Ab2BJRTn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 12:19:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="106181476"
Message-ID: <4F3552A4.70902@intel.com>
Date: Fri, 10 Feb 2012 09:23:48 -0800
From: "Nelson, Doug" <doug.nelson@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111220 Thunderbird/9.0
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>
CC: Matthew Wilcox <willy@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: scsi_id: sending ioctl 2285 to a partition
References: <20120209202938.GA14342@linux.intel.com> <CA+55aFw1=2SR3CtDU_1F_9QJ8OpdGyRRWMbrbvT+COpLWMNO+A@mail.gmail.com> <20120209210039.GB14342@linux.intel.com> <4F34D292.4080404@redhat.com>
In-Reply-To: <4F34D292.4080404@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/10/2012 12:17 AM, Paolo Bonzini wrote:
> On 02/09/2012 10:00 PM, Matthew Wilcox wrote:
>> On Thu, Feb 09, 2012 at 12:42:00PM -0800, Linus Torvalds wrote:
>>> On Thu, Feb 9, 2012 at 12:29 PM, Matthew 
>>> Wilcox<willy@linux.intel.com>  wrote:
>>>>
>>>> Commit 0bfc96cb77 adds this printk that triggers tens of thousands of
>>>> times during a run of "a well-known database benchmark".  0x2285 is 
>>>> SG_IO.
>>>> I'm not sure why scsi_id feels that it needs to repeatedly send a SCSI
>>>> INQUIRY to a partition, but there we are.
>>>
>>> So is it doing this as root (in which case we end up allowing it) or
>>> as a normal user (in which case we end up disallowing it)?
>>
>> I'm pretty sure it's doing it as root ... it'll be run by udev, after 
>> all.
>
> What does the rule look like?  Here it is like this:
>
> # scsi devices
> KERNEL=="sd*[!0-9]|sr*", ENV{ID_SERIAL}!="?*",
> IMPORT{program}="scsi_id --export --whitelisted -d $tempnode",
> ENV{ID_BUS}="scsi"

The rule I had was not excluding partitions.   I'll fix that and try again.


thanks,

doug

>
> which should exclude partitions, and indeed I don't see any such 
> message.  I also have this rule:
>
> # for partitions import parent information
> ENV{DEVTYPE}=="partition", IMPORT{parent}="ID_*"
>
> which makes it clear that udev does not need to send INQUIRY to the 
> partition.
>
>>> And does it all work well apart from the printk? Because the printk
>>> itself is scheduled to be removed, it's only there to hear about users
>>> that may be doing crazy things that got disallowed by the patches in
>>> question?
>>
>> If it is being run as root, then the printk is pointless, right?
>
> At the time the printk is removed, access also will be disallowed to 
> root.
>
> Paolo

