Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758228Ab2JXKzr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 06:55:47 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:10976 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758162Ab2JXKzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 06:55:46 -0400
X-IronPort-AV: E=Sophos;i="4.80,639,1344211200"; 
   d="scan'208";a="15355389"
Date: Wed, 24 Oct 2012 11:55:13 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Yinghai Lu <yinghai@kernel.org>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/19] x86, mm: setup page table in top-down
In-Reply-To: <CAE9FiQXvN5LMQCFwU6_RWjmS8fbL=NMbJonC3dCHe-+=uy9daw@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1210241142210.2689@kaball.uk.xensource.com>
References: <1350593430-24470-1-git-send-email-yinghai@kernel.org> <1350593430-24470-10-git-send-email-yinghai@kernel.org> <alpine.DEB.2.02.1210191714330.2689@kaball.uk.xensource.com> <CAE9FiQX-JBHvjqLyjutKfBUp2DQKEwVMGEkj7Wi6yijAERhP6w@mail.gmail.com>
 <alpine.DEB.2.02.1210221405010.2689@kaball.uk.xensource.com> <CAE9FiQViaompYixDoOb_XPA4Npwb0RyYu2czfpAGMGQbVSCB=A@mail.gmail.com> <alpine.DEB.2.02.1210231320390.2689@kaball.uk.xensource.com>
 <CAE9FiQXvN5LMQCFwU6_RWjmS8fbL=NMbJonC3dCHe-+=uy9daw@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Oct 2012, Yinghai Lu wrote:
> On Tue, Oct 23, 2012 at 5:22 AM, Stefano Stabellini
> <stefano.stabellini@eu.citrix.com> wrote:
> > On Mon, 22 Oct 2012, Yinghai Lu wrote:
> >> Can you test domU 32bit too?
> >> I did not test that, and looks like Jacob only test 64 bit domU too.
> >
> > Sure. It works fine.
> 
> great.
> 
> Do you know any simple way to test xen domU after pxe booting xen/dom0 via pxe?
> 
> >From kvm, it is simple with pxe:
> 1. build kernel and iso at the same time., initrd is converted from
> opensuse rescue initramfs.
> 2. copy kernel and iso into boot server
> 3. network boot the kernel
> 4. mount nfs dir so could access iso, and qemu-kvm.
> 5. qemu-kvm to load the iso.

After building and installing the Xen tools in Dom0 (basically
everything that comes out a xen-unstable build), you can use "xl" to
create VMs:

1) build and install xen and tools in dom0 (make; make install)
If you are running dom0 out of his initramfs you might have to add them to it.
But I guess that you can also make them available to your dom0 via nfs
share.

2) copy your domU kernel and initrd to dom0

3) Write a simple config file in dom0 with the path to the kernel and initrd

name = "linux"
kernel = "/path/to/vmlinuz"
ramdisk = "/path/to/initrd"
memory = 1024
vcpus = 4
vif = [ 'bridge=xenbr0' ]
disk = [ '/path/to/debian_squeeze_amd64_standard.raw,raw,xvda,w' ]
extra = 'textmode=1 xencons=xvc0'
root = "/dev/xvda1"

4) create the VM
xl create -c /path/to/config_file


As an alternative you can get an account on Amazon EC2 for few cents per
hour and test your kernel over there ;)
