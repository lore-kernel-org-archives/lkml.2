Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751488Ab1DCJCX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Apr 2011 05:02:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12149 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750932Ab1DCJCW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Apr 2011 05:02:22 -0400
Date: Sun, 3 Apr 2011 12:01:50 +0300
From: Alon Levy <alevy@redhat.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [ANNOUNCE] Native Linux KVM tool
Message-ID: <20110403090149.GI4047@playa.redhat.com>
Mail-Followup-To: Pekka Enberg <penberg@kernel.org>,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <1301592656.586.15.camel@jaguar>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1301592656.586.15.camel@jaguar>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 31, 2011 at 08:30:56PM +0300, Pekka Enberg wrote:
> Hi all,
> 
> We’re proud to announce the native Linux KVM tool!
> 
> The goal of this tool is to provide a clean, from-scratch, lightweight
> KVM host tool implementation that can boot Linux guest images (just a
> hobby, won't be big and professional like QEMU) with no BIOS
> dependencies and with only the minimal amount of legacy device
> emulation.
> 
> Note that this is a development prototype for the time being: there's no
> networking support and no graphics support, amongst other missing
> essentials.

I've looked at how to add spice to this, the qxl device should be relatively
easy to add as it's just another pci device and you already support the virtio
block pci device. But to add the spice server library there needs to be some
simple fd and timer (i.e. select/epoll) event loop, which I see is missing. Are
you planning on adding something like that?

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
>   git clone git://github.com/penberg/linux-kvm.git
> 
> or alternatively, if you already have a kernel source tree:
> 
>   git checkout -b kvm/tool
>   git pull git://github.com/penberg/linux-kvm.git
> 
> 2. Compile the tool:
> 
>   cd tools/kvm && make
> 
> 3. Download a raw userspace image:
> 
>   wget http://wiki.qemu.org/download/linux-0.2.img.bz2 && bunzip2
> linux-0.2.img.bz2
> 
> 4. Build a kernel with CONFIG_VIRTIO_BLK=y and
> CONFIG_SERIAL_8250_CONSOLE=y configuration options. Note: also make sure
> you have CONFIG_EXT2_FS or CONFIG_EXT4_FS if you use the above image.
> 
> 5. And finally, launch the hypervisor:
> 
>   ./kvm --image=linux-0.2.img --kernel=../../arch/x86/boot/bzImage
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
