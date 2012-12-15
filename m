Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756517Ab2LOMJl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 07:09:41 -0500
Received: from outbound-mail04.westnet.com.au ([203.10.1.245]:26461 "EHLO
	outbound-mail04.westnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755724Ab2LOMJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 07:09:39 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApMBAGNnzFB8qkPM/2dsb2JhbAANOLsCg2mDEQEBAQMBOEABBQsLGAkWDwkDAgECAUUGDQEHAQGHfAEMqCGTPYxdhEMDqVY
X-IronPort-AV: E=Sophos;i="4.84,290,1355068800"; 
   d="scan'208";a="57748178"
Message-ID: <50CC687F.6060305@westnet.com.au>
Date: Sat, 15 Dec 2012 22:09:35 +1000
From: Greg Ungerer <gregungerer@westnet.com.au>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Rob Landley <rob@landley.net>
CC: Geert Uytterhoeven <geert@linux-m68k.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Ungerer <gerg@uclinux.org>,
        Linux/m68k <linux-m68k@vger.kernel.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] m68k updates for 3.8
References: <1355521700.18402.7@driftwood>
In-Reply-To: <1355521700.18402.7@driftwood>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/15/2012 07:48 AM, Rob Landley wrote:
> On 12/14/2012 06:04:51 AM, Greg Ungerer wrote:
>> Hi Rob,
> ...
>>> Somebody got one of my images to boot under aranym but they had to patch
>>> the kernel fairly extensively to add the emulated device support that
>>> emulator provided. It doesn't emulate real devices the way qemu does,
>>> but qemu doesn't fully emulate the processor (just coldfire in
>>> mainline)...
>>
>> I use aranym for testing m68k. Though I don't really pound to heavily
>> on the devices. I really only cross-compile small systems for testing
>> on it.
>
> What kernel config do you use for aranym? I don't see an an aranym entry in
> arch/m68k/configs, and I stopped using it precisely because it required
> several large patches to add emulated device support for everything from
> serial console to block devices. (There was a kernel upgrade, it broke,
> I cut a release without it. Pretty much the same reason I stopped using
> squashfs for a year or so until it finally got merged.)

arch/m68k/configs/atari_defconfig

AranyM is an Atari emulator. As far as I know all the special device
support has been merged into mainline now.


> I can poke Laurent Vivier about possibly getting the qemu-system-m68k
> and the q800 board emulation to work better if there's interest from
> anyone other than me. (I just checked and it dies at the same place it
> did last year: setting up the page tables. The MMU emulation ain't
> there, and I haven't got documentation for it.)
>
> My interest is that my aboriginal linux setup builds the same system for
> a dozen different targets and then natively builds packages inside the
> emulator. This allows me to regression test if their behavior diverges,
> even from a cron job if I want to. From my viewpoint, the more targets
> the merrier.
>
> (I don't care hugely about which board emulation I'm using, the point is
> to run a native root filesystem including a native toolchain and build
> stuff locally on the board. This requires at least 256 megs of memory in
> the emulated board for gcc 4.2 (more for newer versions), and ideally I
> want a virtual network card so I can hook up distcc to the cross
> compiler and move the heavy lifting of compilation outside the emulator
> without reintroducing the whole "keep track of two simultaneous build
> contexts" complexity of cross compiling. So it's not "q800 vs aranym",
> it's "I already got qemu to emulate all the other targets I'm testing
> and it doesn't require an extensively patched kernel" vs "other emulator
> requiring patched kernel"...)

For whatever it is worth I don't run patched kernels under AranyM.
But I don't really care to much about the odd ball devices either
for most of the testing I use it for.

Regards
Greg


