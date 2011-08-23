Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751833Ab1HWGj6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 02:39:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62812 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751254Ab1HWGj4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 02:39:56 -0400
Date: Tue, 23 Aug 2011 09:39:53 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Iggy Iggy <ignatious1234@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Kernel Panic on KVM Guests: "Scheduling while atomic: swapper''
Message-ID: <20110823063953.GA15288@redhat.com>
References: <CAMzJPjex8_VjWeykGs+E1=R9hTjc_qbxsnr9w+t6hS370nZdcg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMzJPjex8_VjWeykGs+E1=R9hTjc_qbxsnr9w+t6hS370nZdcg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 17, 2011 at 10:40:15PM -0500, Iggy Iggy wrote:
> I've started seeing kernel panics on a few of our virtual machines
> after moving them (qemu-kvm, libvirt) off of a box with two Intel Xeon
> X5650 processors (12 cores total) onto one with four AMD Opteron 6174
> processors (48 cores total).
> 
> What is odd is that I feel like the panic is moving around on these
> virtual machines. It was only happening on one for a bit and then it
> stopped but started happening on another virtual machine. It also
> doesn't happen all the time but it can also happen frequently. Two
> days of not happening vs every four to six hours. The machine still
> functions to an extent but over time it crawls and needs to be
> destroyed and started back up.
> 
> This is the panic:
> Jul 20 06:35:47 test-db kernel: [10881.413875] BUG: scheduling while
> atomic: swapper/0/0x00010000
> Jul 20 06:35:47 test-db kernel: [10881.414184] Modules linked in:
> nf_conntrack_ftp i2c_piix4 i2c_core joydev virtio_net virtio_balloon
> virtio_blk virtio_pci virtio_ring virtio [last unloaded:
> scsi_wait_scan]
> Jul 20 06:35:47 test-db kernel: [10881.414196] Pid: 0, comm: swapper
> Not tainted 2.6.35.11-83.fc14.x86_64 #1
> Jul 20 06:35:47 test-db kernel: [10881.414198] Call Trace:
> Jul 20 06:35:47 test-db kernel: [10881.414205] [<ffffffff8103ffbe>]
> __schedule_bug+0x5f/0x64
> Jul 20 06:35:47 test-db kernel: [10881.414208] [<ffffffff8146845e>]
> schedule+0xd9/0x5cb
> Jul 20 06:35:47 test-db kernel: [10881.414214] [<ffffffff81072e20>] ?
> hrtimer_start_expires.clone.5+0x1e/0x20
> Jul 20 06:35:47 test-db kernel: [10881.414219] [<ffffffff81008345>]
> cpu_idle+0xca/0xcc
> Jul 20 06:35:47 test-db kernel: [10881.414223] [<ffffffff81451c66>]
> rest_init+0x8a/0x8c
> Jul 20 06:35:47 test-db kernel: [10881.414227] [<ffffffff81ba1c49>]
> start_kernel+0x40b/0x416
> Jul 20 06:35:47 test-db kernel: [10881.414231] [<ffffffff81ba12c6>]
> x86_64_start_reservations+0xb1/0xb5
> Jul 20 06:35:47 test-db kernel: [10881.414234] [<ffffffff81ba13c2>]
> x86_64_start_kernel+0xf8/0x107
> 
> The new server is running Scientific Linux 6.0 with kernel
> 2.6.32-131.6.1.el6.x86_64. One of the guests I see this on is running
> Fedora Core 14, kernel 2.6.35.13-92.fc14.x86_64 and the other is
> running Fedora Core 12, kernel 2.6.32.26-175.fc12.x86_64.
> 
This is RHEL bug [1], not upstream one and should be reported elsewhere.
Just for the record the bug is fixed on the latest RHEL kernel.

[1] https://bugzilla.redhat.com/show_bug.cgi?id=683658

--
			Gleb.
