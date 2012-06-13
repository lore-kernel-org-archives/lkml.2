Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753912Ab2FMOX7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 10:23:59 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:63871 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540Ab2FMOX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 10:23:58 -0400
Message-ID: <4FD81E27.4000006@landley.net>
Date: Tue, 12 Jun 2012 23:59:19 -0500
From: Rob Landley <rob@landley.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Bjorn Helgaas <bhelgaas@google.com>, Wen Congyang <wency@cn.fujitsu.com>,
        tglx@linutronix.de, Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2 v2] x86: add max_addr boot option
References: <4FD5AFF2.3040306@cn.fujitsu.com> <CAErSpo6EnHFFPwcPhWy=ACTn5+7i72fUR+1jjZrpfEMQp1zv0A@mail.gmail.com> <4FD6E1DA.2090700@cn.fujitsu.com> <CAErSpo6UwL6kY4rHeYQbn1kghJH-kQDeat7VXp95JE2pGER5ZA@mail.gmail.com> <4FD7F329.1000203@jp.fujitsu.com>
In-Reply-To: <4FD7F329.1000203@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2012 08:55 PM, Kamezawa Hiroyuki wrote:
>>> Currently, I only need to ignore the memory. If we need to ignore a
>>> node,
>>> "numa_node=" or similar parameter is a better choice.
>>
>> Doesn't the end user have to know the memory map of the system to use
>> "max_addr="?  How do you know what value to supply?  Do you have to
>> attempt a boot once to discover the highest address on node 0?  What
>> if node 0 and node 1 memory are interleaved, so there's some node 1
>> memory below the highest node 0 address?
> 
> Current our plan is to avoid asking end-user to fix their boot option by
> hand even if memory size per node is changed. We'll ship a  hardware, which has
> _fixed_ physical address range per each node regardless of equipped
> memory size.

I.E. you'll be configuring this yourself when you ship hardware.

You're adding an option because you consider it less confusing for your
end users who are digging into kernel parameters, but you will set this
new option for your users because they haven't got the information to
set it themselves?

> Problem happens => reboot (disable some DIMM) => remove memmap= option
> for avoiding
> trouble => check memory layout again =>fix mem_map= => reboot again.
> This reboot takes much time because the system which have
> Dynamic-partitioning tends to
> be big....so, we'd like to have some _relaxed_ way to specify the region
> of memory.
> 
> Problem happens => reboot (disable some DIMM) => no changes required
> (because we have enough memory hole between Node0 and Node1.)

I'm guessing the above means "or you'll be providing some tool that does
it when they install/remove memory in the hardware"...

> BTW, how do you think about mem= boot option which works as max_addr=,
> now ?
> This caused troubles some times on our support-desk, saying
> Q. I specified mem=8G boot option but it seems the system has only 7GB....
> A. it's because of PCI configuration area on 3G-4G address range...

So you're saying there are already two ways to do this, but you want to
add a third to be less confusing for end users who are modifying the
linux kernel boot parameters by hand using information only you can
supply to them?

I'm confused...

> Even if our requirement can be covered current mem= option, I'd like to
> have max_addr= option and make mem= option to be sane as ia64.

"sane as ia64".

Ok, I've read that phrase five times and the words still don't fit together.

I'm going to admit defeat on my attempt to understand this thread, and
move on...

Rob
-- 
GNU/Linux isn't: Linux=GPLv2, GNU=GPLv3+, they can't share code.
Either it's "mere aggregation", or a license violation.  Pick one.
