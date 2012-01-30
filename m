Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430Ab2A3P1g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 10:27:36 -0500
Received: from furry1.cpalmer.me.uk ([91.84.39.42]:50502 "EHLO
	furry1.cpalmer.me.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752916Ab2A3P1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 10:27:35 -0500
X-Greylist: delayed 1430 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Jan 2012 10:27:35 EST
Message-ID: <4F26B162.4050000@pobox.com>
Date: Mon, 30 Jan 2012 15:04:02 +0000
From: Chris Palmer <chris.palmer@pobox.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: torvalds@linux-foundation.org
CC: Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
        ghost3k@ghost3k.net, linux-kernel@vger.kernel.org,
        hancockrwd@gmail.com, edward.donovan@numble.net, keve@irb.hu
Subject: ASM1083 PCIx-PCI bridge interrupts - widespread problems
References: <4E68A6E8.9020700@pobox.com> <20110908165155.f661a738.akpm@linux-foundation.org>
In-Reply-To: <20110908165155.f661a738.akpm@linux-foundation.org>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus et al


For about 6 months many users have been having interrupt problems with PCI boards, but it hasn't been 
easy trying to find where the problem may be. However, it is now looking likely that the problem lies 
in the ASM1083 PCIe-PCI bridge chipset, as used by Asus in many Sandybridge and AMD boards.

My original bug report is:
    https://bugzilla.kernel.org/show_bug.cgi?id=38632  (Sandybridge)

and there several other similar ones. However there is also extensive investigation in the following thread:
    http://www.gossamer-threads.com/lists/linux/kernel/1466185  (AMD)

There have also been reports of Windows users having similar problems.

This problem prevents use of PCI boards in any motherboard with that bridge chipset - including most 
ASUS boards. At the moment though we don't know whether the chipset or drivers are faulty, and if a 
workaround is possible.

At the moment my bug is assigned to drivers_network, but this doesn't look appropriate.

Hoping someone can help...

Regards
Chris




On 09/09/2011 00:51, Andrew Morton wrote:

> On Thu, 08 Sep 2011 12:28:40 +0100
> Chris Palmer <chris.palmer@pobox.com> wrote:
>
>> Andrew
>>
>> I'm writing to ask if you could cast a quick eye over the following
>> bugs, to give an opinion on where they should be assigned. Mine has been
>> reassigned to Network Drivers but I'm not convinced that is right, and I
>> think the problem is wider than that.
>>
>> In summary, interrupt handling for *PCI boards with ASUS Sandybridge
>> motherboards* seems to be broken.
>>
>> It has been seen with network and non-network PCI boards. PCIx network
>> boards work OK. And all reports are for ASUS motherboards.
>>
>> My bug report is
>>
>> https://bugzilla.kernel.org/show_bug.cgi?id=38632
>>
>> Others that I know of are:
>>
>> https://bugzilla.redhat.com/show_bug.cgi?id=713351
>> https://bugzilla.kernel.org/show_bug.cgi?id=35332
>> https://bugzilla.kernel.org/show_bug.cgi?id=34242
>> https://bugzilla.kernel.org/show_bug.cgi?id=32242
>> https://bugzilla.kernel.org/show_bug.cgi?id=39122
>>
>>
>> I'm now on kernel 3.0.4 with the problem still there. The only thing
>> that seems to make a difference is acpi=off (although one person
>> reported that it merely changed it from minutes to days before occurring).
>>
>> I'd appreciate anything you could do to move this in the right direction...
>>
>
> Most likely ACPI, I expect.  I think that's
> acpi-config-interrupts@bugzilla.kernel.org.  kernel.org DNS is dead at
> present and I can't check.
>
> Len, can you suggest how to triage these please?
