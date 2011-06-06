Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757570Ab1FFXEr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 19:04:47 -0400
Received: from usmamail.tilera.com ([206.83.70.75]:56709 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754826Ab1FFXEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 19:04:44 -0400
Message-ID: <4DED5D08.3070704@tilera.com>
Date: Mon, 6 Jun 2011 19:04:40 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Arnd Bergmann <arnd@arndb.de>, Timur Tabi <timur@freescale.com>,
        Deepak Saxena <dsaxena@linaro.org>, <kumar.gala@freescale.com>,
        <benh@kernel.crashing.org>, <greg@kroah.com>, <akpm@kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <linux-console@vger.kernel.org>
Subject: Re: [PATCH 7/7] [v2] drivers/misc: introduce Freescale hypervisor
 management driver
References: <1306953337-15698-1-git-send-email-timur@freescale.com> <201106061803.58531.arnd@arndb.de> <4DECFBC5.6070205@freescale.com> <201106061824.53844.arnd@arndb.de> <4DED4030.9050503@tilera.com> <20110606212356.GA20112@dumpdata.com>
In-Reply-To: <20110606212356.GA20112@dumpdata.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For context, the most recent patch for the tile driver in question is here:

https://patchwork.kernel.org/patch/843892/

On 6/6/2011 5:23 PM, Konrad Rzeszutek Wilk wrote:
> On Mon, Jun 06, 2011 at 05:01:36PM -0400, Chris Metcalf wrote:
>> On 6/6/2011 12:24 PM, Arnd Bergmann wrote:
>>> On Monday 06 June 2011, Timur Tabi wrote:.
>>>> And what about my concern that my driver will be the only one in drivers/virt?
>>> I have no doubt that more of these will come. Chris Metcalf is currently
>>> looking for a home for his tilera hypervisor drivers, and we have the
>>> microsoft hyperv drivers in drivers/staging, so they will hopefully
>>> move to a proper place later. We also have similar drivers in other
>>> places, e.g. drivers/ps3/ps3-sys-manager.c, drivers/s390/char/vmcp.c
>>> or parts of drivers/xen.
>> It might help if someone (Arnd?) wanted to propose a statement of what
>> drivers/virt was really for.  If it's for any Linux driver that upcalls to
> Was for? I am not seeing it in v3.0-rc2?

Sorry, maybe a questionable idiom, but please read past tense in the quoted
text as meaning present tense :-)

>> a hypervisor for any reason, then the Tilera paravirtualized drivers fit in
>> well.  If it's intended more for drivers that guests running under a
>> hypervisor can use to talk to the hypervisor itself (e.g. managing
> I believe that the code that deals with specific subsystem (so block API
> for example) would reside in subsystem directory (so drivers/block would have
> your virtualization block driver). This allows the maintainer of block
> to make sure your driver is OK.

Sure, makes sense.  The new push (as I understand it) is to group primarily
by function, not by bus or architecture.

>> notifications that a hypervisor delivers to a guest to cause it to shut
>> down or take other actions), then it doesn't seem like the Tilera
> That looks to be arch/<x>/tilera/virt/ candidate?

Arnd, among others, has suggested that all drivers live in "drivers"
somewhere, so "arch/tile" may not be the best place.  (To be fair, I
originally had this driver in arch/tile/drivers/, so your idea is certainly
reasonable!)

>> paravirtualized device drivers belong there, since they're just using the
>> Tilera hypervisor synchronously to do I/O or get/set device and driver state.
> Well, I/O sounds like block API or network API. But then you are also
> doing management ioctl - which implies "drivers". "drivers/tilera" does not
> work?

There is certainly precedent for drivers that don't fit cleanly into an
existing category to go in drivers/<arch>, e.g. drivers/s390,
drivers/parisc, etc.  There is also drivers/platform/x86, though that seems
to be for the bus "platform drivers" rather than just a random character
driver like the one in question.

I don't have a particular opinion here; I'm just hoping to develop enough
consensus that I can ask Linus to pull the driver without generating
controversy :-)

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com


