Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555Ab0DZNAF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 09:00:05 -0400
Received: from prod-mail-xrelay01.akamai.com ([72.246.2.12]:35067 "EHLO
	prod-mail-xrelay01.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750991Ab0DZNAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 09:00:03 -0400
X-Greylist: delayed 563 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Apr 2010 09:00:03 EDT
Date: Mon, 26 Apr 2010 08:50:32 -0400
From: "R. Andrew Bailey" <bailey@akamai.com>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Andy Isaacson <adi@hexapodia.org>, Yinghai <yinghai.lu@oracle.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, guenter.roeck@ericsson.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Renninger <trenn@suse.de>, yaneti@declera.com
Subject: Re: [PATCH] x86/PCI: never allocate PCI MMIO resources below BIOS_END
Message-ID: <20100426125032.GA1623@akamai.com>
References: <4BC4E55B.7000103@oracle.com>
 <4BCE8E3E.4030809@oracle.com>
 <20100421193120.GD11130@hexapodia.org>
 <201004231705.25659.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <201004231705.25659.bjorn.helgaas@hp.com>
User-Agent: Mutt/1.5.21 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/04/10 17:05 -0600, Bjorn Helgaas wrote:
>On Wednesday 21 April 2010 01:31:20 pm Andy Isaacson wrote:
>> On Tue, Apr 20, 2010 at 10:33:50PM -0700, Yinghai wrote:
>> > Update e820 at first, and later put them resource tree.
>> > Reserved that early, will not be allocated to unassigned PCI BAR
>> >
>> > v3: remove probe_roms() that is not needed, because whole range is reserved
>> > 	 already
>>
>> Test booted this patch series on the problematic t3400, seems to work
>> fine.  dmesg attached to bug 15744.
>
>Thanks for testing (again).  I'm not confident that this series is
>going to be successful, so I started looking for other approaches.
>
>I can't reproduce the exact problem you're seeing, but in my
>kludged-up attempt, the patch below is enough to keep us from
>assigning the space below 1MB to a device.
>
>Would you guys (Andy & Andy, what a coincidence :-)) mind giving
>it a try?  This is intended to work on top of current upstream,
>with no other patches required.
>
>Bjorn
>

Good news- that solved it. I tried Yinghai's patches saturday to no
avail (sorry it took me so long to get back to you, I was about 5 bios
revisions behind on this machine and wanted to update it before I
tried any more tests).

  .andy
