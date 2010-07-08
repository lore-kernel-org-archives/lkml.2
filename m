Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758742Ab0GHXvq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 19:51:46 -0400
Received: from claw.goop.org ([74.207.240.146]:52769 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754882Ab0GHXvo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 19:51:44 -0400
Message-ID: <4C36648F.6020006@goop.org>
Date: Thu, 08 Jul 2010 16:51:43 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Lightning/1.0b2pre Thunderbird/3.0.5
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Daniel Kiper <dkiper@net-space.pl>, xen-devel@lists.xensource.com,
       linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] Re: GSoC 2010 - Migration from memory ballooning
 to	memory hotplug in Xen
References: <20100708194553.GA30124@router-fw-old.local.net-space.pl> <871vbdr4ey.fsf@basil.nowhere.org>
In-Reply-To: <871vbdr4ey.fsf@basil.nowhere.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/08/2010 03:32 PM, Andi Kleen wrote:
> Daniel Kiper <dkiper@net-space.pl> writes:
>   
>> OK, let's go to details. When I was playing with Xen I saw that
>> ballooning does not give possibility to extend memory over boundary
>> declared at the start of system. Yes, I know that is by desing however
>> I thought that it is a limitation which could by very annoing in some
>> enviroments (I think especially about servers). That is why I decided to
>> develop some code which remove that one. At the beggining I thought
>> that it should be replaced by memory hotplyg however after some test
>> and discussion with Jeremy we decided to link balooning (for memory
>> removal) with memory hotplug (for extending memory above boundary
>> declared at the startup of system). Additionaly, we decided to implement
>> this solution for Linux Xen gustes in all forms (PV/i386,x86_64 and
>> HVM/i386,x86_64).
>>     
> While you can do that the value is not very large because you
> could just start the guests with more memory, but ballooned in 
> the first place (so that they don't actually use it) 
>   

Yes.  Another approach would be to fiddle with the E820 maps early at
boot to add more RAM, but then early_reserve it and hand it over to the
control of the balloon driver.  But it does mean you need to statically
come up with the max ever at boot time.

> The only advantage of using memory hotadd is that the mem_map doesn't
> need to be pre-allocated, but that's only a few percent of the memory.
>
> So it would only help if you want to add gigantic amounts of memory
> to a VM (like >20-30x of what it already has).
>   

That's not wildly unreasonable on the face of it; consider a domain
which starts at 1GB but could go up to 32GB as demand requires.  But
that also depends on what other things in the kernel are statically
scaled at boot time according to memory size (hash tables?).

> One trap is also that memory hotadd is a frequent source of regressions,
> so you'll likely run into existing bugs.

That could be painful, but I expect the main reason for regressions is
that the code is fairly underused.  Adding new users should help.

    J
