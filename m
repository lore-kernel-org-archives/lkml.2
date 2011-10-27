Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786Ab1J0SLI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 14:11:08 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:39620 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754416Ab1J0SLF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 14:11:05 -0400
MIME-Version: 1.0
In-Reply-To: <1319717234-20918-1-git-send-email-levinsasha928@gmail.com>
References: <1319717234-20918-1-git-send-email-levinsasha928@gmail.com>
From: Rabin Vincent <rabin@rab.in>
Date: Thu, 27 Oct 2011 23:35:56 +0530
X-Google-Sender-Auth: -cxwyg2xkD02nQ91f7jPWnGvnfk
Message-ID: <CAH+eYFBw99Yb-x+QEyZiXZ4yL3r=jr1Z+Gk95DG3hsYLkC_R_A@mail.gmail.com>
Subject: Re: [PATCH] config: Add 'make kvmconfig'
To: Sasha Levin <levinsasha928@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kbuild@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 27, 2011 at 17:37, Sasha Levin <levinsasha928@gmail.com> wrote:
> +config KVMTOOL_TEST_ENABLE
> +       bool "Enable options to create a bootable tools/kvm/ kernel"
> +       select NET
> +       select NETDEVICES
> +       select PCI
> +       select BLK_DEV
> +       select NETWORK_FILESYSTEMS
> +       select INET
> +       select EXPERIMENTAL
> +       select SERIAL_8250
> +       select SERIAL_8250_CONSOLE
> +       select IP_PNP
> +       select IP_PNP_DHCP
> +       select BINFMT_ELF
> +       select PCI_MSI
> +       select KGDB
> +       select KGDB_SERIAL_CONSOLE
> +       select VIRTIO
> +       select VIRTIO_RING
> +       select VIRTIO_PCI
> +       select VIRTIO_BLK
> +       select VIRTIO_CONSOLE
> +       select VIRTIO_NET
> +       select 9P_FS
> +       select NET_9P
> +       select NET_9P_VIRTIO

This lot doesn't seem to be enough for me on next-20111025.  I seem to
have to also enable CONFIG_FB_VESA for the kernel to boot.

Without CONFIG_FB_VESA, I just get:

$ tools/kvm/kvm run --debug arch/x86/boot/bzImage --disk
~/kernel/linux-0.2.img
  # kvm run -k arch/x86/boot/bzImage -m 448 -c 4 --name guest-11466
PPrroobbiinngg  EEDDDD  ((eedddd==ooffff  ttoo  ddiissaabbllee))......  ookk
<no more output>
