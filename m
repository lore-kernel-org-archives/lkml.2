Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751996Ab1DEC1K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 22:27:10 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:44963 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706Ab1DEC1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 22:27:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=CWX/OBmaT/4jDDLnCJBZoEida3xr7lGBjLbTesW8Etc1iBvHjMug7PtxojHA7fJKrD
         uB3fg7h5k0sSXjsB/g8oQLBrQhULKN897NCXrw3HieKaW7BkIRcRr5H6zHie2b01IWFr
         b/lJgxp6IOzG3GkyiSLI1Oc9cr+DE8PwQrFBU=
Message-ID: <4D9A7DF6.1040101@gmail.com>
Date: Mon, 04 Apr 2011 20:27:02 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Pekka Enberg <penberg@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Native KVM: can't boot existing Fedora 14 image
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was trying out the new kvm tool with an existing KVM image, and it is
failing to boot because the hard drive cannot be found.

The qemu-kvm command is:

/usr/bin/qemu-kvm \
   -kernel /tmp/vmlinuz-2.6.38 \
   -initrd /tmp/initramfs-2.6.38.img \
   -append "ro root=/dev/mapper/vg_f14vm-lv_root LANG=en_US.UTF-8
SYSFONT=latarcyrheb-sun16 KEYTABLE=us selinux=0 console=ttyS0" \
    -drive file=/home/dsa/vm/images/f14/disk-1.img,if=virtio,cache=none \
    -m 1024 -nographic -serial stdio -monitor unix:/tmp/f14,server,nowait

The console output during disk discovery is:

[   10.794727] dracut: dracut-006-6.fc14
[   10.849603] udev[53]: starting version 161
[   10.949862] dracut: Starting plymouth daemon
[   11.500216] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
[   11.501581] virtio-pci 0000:00:04.0: PCI INT A -> Link[LNKD] -> GSI
11 (level, high) -> IRQ 11
[   11.518211]  vda: vda1 vda2

And of course it boots nicely.

The corresponding (native) kvm command I tried is:

./kvm --kernel=/tmp/vmlinuz-2.6.38 \
      --initrd=/tmp/initramfs-2.6.38.img \
      --image=/home/dsa/vm/images/f14/disk-1.img  \
      --params="ro root=/dev/mapper/vg_f14vm-lv_root LANG=en_US.UTF-8
SYSFONT=latarcyrheb-sun16 KEYTABLE=us selinux=0" \
      --mem=1024

And the relevant discovery output is:
[   11.492079] dracut: dracut-006-6.fc14
[   11.550571] udev[50]: starting version 161
[   11.649098] dracut: Starting plymouth daemon
putfont: PIO_FONT trying ...
.[   11.977699] virtio-pci 0000:00:01.0: enabling device (0000 -> 0001)
[   11.991637]  vda: vda1 vda2
  Warning: request type 8
  Warning: request type 8
  Warning: request type 8
[   12.086194] EXT3-fs (vda): error: can't find ext3 filesystem on dev vda.
[   12.087358] EXT4-fs (vda): VFS: Can't find ext4 filesystem
[   12.141795] ISOFS: Unable to identify CD-ROM format.
mount: you must specify the filesystem type

At that point it loops over a few iterations of the last few lines and I
kill it. Any ideas why?

David
