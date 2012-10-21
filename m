Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751438Ab2JUDq1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 23:46:27 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:35395 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850Ab2JUDq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 23:46:26 -0400
MIME-Version: 1.0
In-Reply-To: <CAPM=9twcHxUGgYUc27DV1AcYZbzKSbA1Bru8vK1kcWvcG0Jpkw@mail.gmail.com>
References: <alpine.LFD.2.02.1210121434140.10531@tux.localdomain>
	<20121016134129.2fcd7c8ebe1235065aea929e@canb.auug.org.au>
	<CA+55aFzz66Y1MtOoqEMrQCVzdL-2pgr43e1sXUa=eM5GXL9XSA@mail.gmail.com>
	<20121020180436.c42b7325431fe87104b008fa@canb.auug.org.au>
	<20121020181425.GA11191@liondog.tnic>
	<CAPM=9twcHxUGgYUc27DV1AcYZbzKSbA1Bru8vK1kcWvcG0Jpkw@mail.gmail.com>
Date: Sat, 20 Oct 2012 20:46:24 -0700
X-Google-Sender-Auth: qMsGzVcyByWNUJ91Oj-YoUvCyug
Message-ID: <CAE9FiQUBRVgkJ=18TGtr=2UCq+xYceUsppr9Xth0LOq-37g-Eg@mail.gmail.com>
Subject: Re: [GIT PULL] Linux KVM tool for v3.7-rc0
From: Yinghai Lu <yinghai@kernel.org>
To: Dave Airlie <airlied@gmail.com>
Cc: Borislav Petkov <bp@alien8.de>, Stephen Rothwell <sfr@canb.auug.org.au>,
        Pekka Enberg <penberg@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Avi Kivity <avi@redhat.com>,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 20, 2012 at 8:07 PM, Dave Airlie <airlied@gmail.com> wrote:
>
> Why couldn't this script just be a wrapper around qemu?
>
> I get the kvm developers developing features that isn't ideal, but for
> the quick boot a kernel tests, I don't see why a well maintained qemu
> wrapper isn't superior. I hate constructing qemu command lines, but a
> script in the kernel repo seems like a good idea.

you can build one iso like:

make isoimage FDARGS="ignore_loglevel debug initcall_debug
acpi.debug_layer=0xffff0000 pci=routeirq apic=debug
ramdisk_size=262144 root=/dev/ram0 rw ip=dhcp
console=uart8250,io,0x3f8,115200"
FDINITRD=/home/yhlu/xx/xx/rootfs/mydisk14_x86_64_xz.xz

then use kvm to load that iso

/usr/local/kvm/bin/qemu-system-x86_64 -L /usr/local/kvm/share/qemu -m
6144 -net nic,model=e1000,macaddr=00:1c:25:1c:13:e9 -net user -smp 2
-cdrom /home/yhlu/xx/xx/kernel/tip/linux-2.6/arch/x86/boot/image.iso
-boot d -serial telnet:127.0.0.1:4444,server -monitor stdio

later could use
  telnet 127.0.0.1 4444
in another terminal to get serial console.

and initrd is converted from opensuse rescue initrd.

hope we can have scripts to create standalone initrd with updated user
program etc.

Thanks

Yinghai
