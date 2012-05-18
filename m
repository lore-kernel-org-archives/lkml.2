Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946368Ab2ERXco (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 19:32:44 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:60633 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946262Ab2ERXcj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 19:32:39 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQXN5z0riswyECKw5OKe+nPUBN2yZ1d4=Asb3kqaj770NA@mail.gmail.com>
References: <1336422606-4244-1-git-send-email-yinghai@kernel.org>
 <CAErSpo6OZYXz-M=C9r154MY7kwC7LRR3ZnQe3pnmVJY2uoWeRw@mail.gmail.com> <CAE9FiQXN5z0riswyECKw5OKe+nPUBN2yZ1d4=Asb3kqaj770NA@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 18 May 2012 17:32:17 -0600
Message-ID: <CAErSpo71805jTs1qVMx+9ghzUub77r47VqpXF0sVOFuDSq6pmg@mail.gmail.com>
Subject: Re: [PATCH 00/21] PCI: use busn_res to replace bus secondary/subordinate
To: Yinghai Lu <yinghai@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>, David Miller <davem@davemloft.net>,
        x86 <x86@kernel.org>, Dominik Brodowski <linux@dominikbrodowski.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2012 at 8:13 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Thu, May 17, 2012 at 3:19 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> Sigh.  You previously said we should do this order:
>>
>>        for-pci-hostbridge-cleanup
>>        for-pci-busn-alloc
>>        for-pci-res-alloc
>>        for-pci-root-bus-hotplug
>>        for-pci-for-each-res-addon
>>
>> I merged for-pci-hostbridge-cleanup already.  I was about to start
>> merging for-pci-busn-alloc.
>>
>> But now you added for-pci-hotplug-cleanup and made for-pci-busn-alloc
>> depend on it.  I have some comments on for-pci-hotplug-cleanup, so I'm
>> not ready to merge it quite yet.  Can you please just go back to the
>> original order and put the new hotplug cleanup stuff at the *end*?
>
> ok, update for-pci-busn_res branch, now it is based on your next branch.
>
> git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git
> for-pci-busn_res

OK.  You just incorporated the hotplug-cleanup stuff into that branch,
which isn't what I had in mind.  But in the interest of making forward
progress, I merged as much as I could.  The result is at:

  git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git next-3.5

After Linus pulls my current "next" branch during the merge window,
I'll put the "next-3.5" stuff into the "next" branch.

Note that I stopped at your probe_resource() patch -- I already told
you I won't merge that in its current form because I think the
interface you propose is too complicated.

Let me know what series you'd like me to work on next, and send the
current patches to the list.

Bjorn
