Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753630Ab1KFBOw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Nov 2011 21:14:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56912 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751636Ab1KFBOv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Nov 2011 21:14:51 -0400
Message-ID: <4EB5DF80.5090809@suse.de>
Date: Sun, 06 Nov 2011 02:14:40 +0100
From: =?ISO-8859-15?Q?Andreas_F=E4rber?= <afaerber@suse.de>
Organization: SUSE LINUX Products GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Alexander Graf <agraf@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Blue Swirl <blauwirbel@gmail.com>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        Pekka Enberg <penberg@kernel.org>, Avi Kivity <avi@redhat.com>,
        =?ISO-8859-15?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [Qemu-devel] [PATCH] KVM: Add wrapper script around QEMU to test
 kernels
References: <1320543320-32728-1-git-send-email-agraf@suse.de>
In-Reply-To: <1320543320-32728-1-git-send-email-agraf@suse.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 06.11.2011 02:35, schrieb Alexander Graf:
> On LinuxCon I had a nice chat with Linus on what he thinks kvm-tool
> would be doing and what he expects from it. Basically he wants a
> small and simple tool he and other developers can run to try out and
> see if the kernel they just built actually works.
> 
> Fortunately, QEMU can do that today already! The only piece that was
> missing was the "simple" piece of the equation, so here is a script
> that wraps around QEMU and executes a kernel you just built.
> 
> If you do have KVM around and are not cross-compiling, it will use
> KVM. But if you don't, you can still fall back to emulation mode and
> at least check if your kernel still does what you expect. I only
> implemented support for s390x and ppc there, but it's easily extensible
> to more platforms, as QEMU can emulate (and virtualize) pretty much
> any platform out there.
> 
> If you don't have qemu installed, please do so before using this script. Your
> distro should provide a package for it (might even call it "kvm"). If not,
> just compile it from source - it's not hard!
> 
> To quickly get going, just execute the following as user:
> 
>     $ ./Documentation/run-qemu.sh -r / -a init=/bin/bash

Path needs updating.

> 
> This will drop you into a shell on your rootfs.
> 
> Happy hacking!
> 
> Signed-off-by: Alexander Graf <agraf@suse.de>
> 
> ---

> diff --git a/tools/testing/run-qemu/run-qemu.sh b/tools/testing/run-qemu/run-qemu.sh
> new file mode 100755
> index 0000000..70f194f
> --- /dev/null
> +++ b/tools/testing/run-qemu/run-qemu.sh

> +# Try to find the KVM accelerated QEMU binary
> +
> +[ "$ARCH" ] || ARCH=$(uname -m)
> +case $ARCH in
> +x86_64)
> +	KERNEL_BIN=arch/x86/boot/bzImage
> +	# SUSE and Red Hat call the binary qemu-kvm
> +	[ "$QEMU_BIN" ] || QEMU_BIN=$(which qemu-kvm 2>/dev/null)
> +
> +	# Debian and Gentoo call it kvm
> +	[ "$QEMU_BIN" ] || QEMU_BIN=$(which kvm 2>/dev/null)
> +
> +	# QEMU's own build system calls it qemu-system-x86_64
> +	[ "$QEMU_BIN" ] || QEMU_BIN=$(which qemu-system-x86_64 2>/dev/null)
> +	;;
> +i*86)
> +	KERNEL_BIN=arch/x86/boot/bzImage
> +	# SUSE and Red Hat call the binary qemu-kvm
> +	[ "$QEMU_BIN" ] || QEMU_BIN=$(which qemu-kvm 2>/dev/null)
> +
> +	# Debian and Gentoo call it kvm
> +	[ "$QEMU_BIN" ] || QEMU_BIN=$(which kvm 2>/dev/null)
> +
> +	KERNEL_BIN=arch/x86/boot/bzImage

Copy&paste?

> +	# i386 version of QEMU

QEMU's own build system calls it qemu-system-i386 now. :)

> +	[ "$QEMU_BIN" ] || QEMU_BIN=$(which qemu 2>/dev/null)

We should first test for qemu-system-i386, then fall back to old qemu.

Andreas

P.S. You're still ahead of time...


-- 
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg, Germany
GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer; HRB 16746 AG Nürnberg
