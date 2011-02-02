Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752057Ab1BBTxS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 14:53:18 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59200 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751503Ab1BBTxR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 14:53:17 -0500
Message-ID: <4D49B5F6.5010606@zytor.com>
Date: Wed, 02 Feb 2011 11:52:22 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Thunderbird/3.1.7
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@elte.hu>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Xen Devel <Xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 0/2] x86/microcode: support for microcode update in Xen
 dom0
References: <cover.1296259339.git.jeremy.fitzhardinge@citrix.com> <20110130113356.GA27967@liondog.tnic> <4D461FB9.5050807@goop.org> <20110131070241.GA22071@liondog.tnic> <4D46FC9F.6090309@goop.org> <20110131234131.GA16095@liondog.tnic> <4D475099.1080004@goop.org> <4D475DB5.1020300@zytor.com> <4D488EB1.9020803@goop.org>
In-Reply-To: <4D488EB1.9020803@goop.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/2011 02:52 PM, Jeremy Fitzhardinge wrote:
> On 01/31/2011 05:11 PM, H. Peter Anvin wrote:
>> Note: Xen may not have devices, but it is already using multiboot to
>> load multiple modules.  It could load the microcode blob that way.
>>
>> That would enable an earlier loading of microcode, which is a very
>> good thing.
> 
> Yes, that is a thought, but it would require some distro support to make
> sure the firmware is copied into /boot, and grub updated appropriately.
> 
> The principle advantage of updating the microcode driver is that it Just
> Works regardless of whether the system is booting native or Xen.
> 

As I mentioned on IRC...

1. Xen already uses Multiboot, so it's a fairly trivial thing to add
another item to the list for the boot loader to get.

2. The only reason we don't currently install microcode from the boot
loader is because of the considerable complexity in adding SMP support
to boot loaders, as it requires handling the APIC system.

3. Arguably on native hardware we should still load the microcode into
RAM in the boot loader, and install it on the very early CPU bringup
path.  That means locking down some (currently) 400K of RAM to handle
different combinations of CPUs, or the additional complexity of
jettisoning microcode which cannot be used while still be able to deal
with hotplug.  I think there is a strong case for this model, which
would mean moving the microcode into /boot anyway.

	-hpa
