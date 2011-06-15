Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755929Ab1FOPxp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 11:53:45 -0400
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:48884 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755271Ab1FOPxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 11:53:44 -0400
Subject: [ANNOUNCE] Native Linux KVM tool v2
From: Pekka Enberg <penberg@kernel.org>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: Avi Kivity <avi@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Prasad Joshi <prasadjoshi124@gmail.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>, Asias He <asias.hejun@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 15 Jun 2011 18:53:34 +0300
Message-ID: <1308153214.7566.6.camel@jaguar>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

We’re proud to announce the second version of the Native Linux KVM tool! We’re
now officially aiming for merging to mainline in 3.1.

Highlights:

- Experimental GUI support using SDL and VNC

- SMP support. tools/kvm/ now has a highly scalable, largely lockless driver
  interface and the individual drivers are using finegrained locks.

- TAP-based virtio networking

- Fast QCOW2 image read-write support beating Qemu in fio benchmarks. See the
  following URL for test result details: https://gist.github.com/1026888

- Virtio-9p support for host filesystem access in guests

- Virtio Random Number Generator

- Host block devices as in-memory copy-on-write guest images on 64-bit hosts

1. To try out the tool, clone the git repository:

  git clone git://github.com/penberg/linux-kvm.git

or alternatively, if you already have a kernel source tree:

  git remote add kvm-tool git://github.com/penberg/linux-kvm.git
  git remote update
  git checkout -b kvm-tool/master kvm-tool

2. Compile the tool:

  cd tools/kvm && make

3. Download a raw userspace image:

  Minimal:

  wget http://wiki.qemu.org/download/linux-0.2.img.bz2 && bunzip2 linux-0.2.img.bz2

  Debian Squeeze QCOW2 image:

  wget http://people.debian.org/~aurel32/qemu/i386/debian_squeeze_i386_standard.qcow2

4. Build a kernel with the following options:

  CONFIG_VIRTIO_BLK=y
  CONFIG_VIRTIO_NET=y
  CONFIG_VIRTIO_CONSOLE=y
  CONFIG_SERIAL_8250_CONSOLE=y
  CONFIG_HW_RANDOM_VIRTIO=y
  CONFIG_FB_VESA=y

Note: also make sure you have CONFIG_EXT2_FS or CONFIG_EXT4_FS if you use the
above images.

5. And finally, launch the hypervisor:

  ./kvm run -d linux-0.2.img

or

  ./kvm run -d debian_squeeze_i386_standard.qcow2

or

    sudo ./kvm run -d linux-0.2.img -n virtio

This release was brought to you by the following people:

    Sasha Levin
    Pekka Enberg
    Asias He
    Prasad Joshi
    Cyrill Gorcunov
    Ingo Molnar
    John Floren
    Amos Kong
    Giuseppe Calderaro
    Amerigo Wang
    Paul Bolle
    David Ahern

Most of us developers are hanging out on #pvm channel at irc.freenode.net
if you want to drop by for questions, comments, and bug reports.

			Pekka

