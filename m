Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757114Ab1DBUiN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Apr 2011 16:38:13 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:63982 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756897Ab1DBUiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Apr 2011 16:38:11 -0400
Message-ID: <4D978930.1000909@codemonkey.ws>
Date: Sat, 02 Apr 2011 15:38:08 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Lightning/1.0b2 Thunderbird/3.1.8
MIME-Version: 1.0
To: Pekka Enberg <penberg@kernel.org>
CC: linux-kernel@vger.kernel.org, aarcange@redhat.com, avi@redhat.com,
        mtosatti@redhat.com, kvm@vger.kernel.org, joro@8bytes.org,
        penberg@cs.helsinki.fi, asias.hejun@gmail.com, gorcunov@gmail.com,
        mingo@elte.hu
Subject: Re: [ANNOUNCE] Native Linux KVM tool
References: <1301592656.586.15.camel@jaguar>
In-Reply-To: <1301592656.586.15.camel@jaguar>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/2011 12:30 PM, Pekka Enberg wrote:
> Hi all,
>
> We’re proud to announce the native Linux KVM tool!

Neat!

As something of a lesson of history, I'd suggest picking a more unique 
name while it's still a prototype :-)

> The goal of this tool is to provide a clean, from-scratch, lightweight
> KVM host tool implementation that can boot Linux guest images (just a
> hobby, won't be big and professional like QEMU) with no BIOS
> dependencies and with only the minimal amount of legacy device
> emulation.

I see you do provide 16-bit entry points for Linux.  Are you planning on 
paravirtualizing this within Linux to truly eliminate the BIOS dependency?

Regards,

Anthony Liguori

> Note that this is a development prototype for the time being: there's no
> networking support and no graphics support, amongst other missing
> essentials.
>
> It's great as a learning tool if you want to get your feet wet in
> virtualization land: it's only 5 KLOC of clean C code that can already
> boot a guest Linux image.
>
> Right now it can boot a Linux image and provide you output via a serial
> console, over the host terminal, i.e. you can use it to boot a guest
> Linux image in a terminal or over ssh and log into the guest without
> much guest or host side setup work needed.
>
> 1. To try out the tool, clone the git repository:
>
>    git clone git://github.com/penberg/linux-kvm.git
>
> or alternatively, if you already have a kernel source tree:
>
>    git checkout -b kvm/tool
>    git pull git://github.com/penberg/linux-kvm.git
>
> 2. Compile the tool:
>
>    cd tools/kvm&&  make
>
> 3. Download a raw userspace image:
>
>    wget http://wiki.qemu.org/download/linux-0.2.img.bz2&&  bunzip2
> linux-0.2.img.bz2
>
> 4. Build a kernel with CONFIG_VIRTIO_BLK=y and
> CONFIG_SERIAL_8250_CONSOLE=y configuration options. Note: also make sure
> you have CONFIG_EXT2_FS or CONFIG_EXT4_FS if you use the above image.
>
> 5. And finally, launch the hypervisor:
>
>    ./kvm --image=linux-0.2.img --kernel=../../arch/x86/boot/bzImage
>
> The tool has been written by Pekka Enberg, Cyrill Gorcunov, and Asias
> He. Special thanks to Avi Kivity for his help on KVM internals and Ingo
> Molnar for all-around support and encouragement!
>
> See the following thread for original discussion for motivation of this
> project:
>
> http://thread.gmane.org/gmane.linux.kernel/962051/focus=962620
>
> 			Pekka
>
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

