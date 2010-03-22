Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755746Ab0CVSfL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 14:35:11 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:23154 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755675Ab0CVSfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 14:35:08 -0400
Date: Mon, 22 Mar 2010 12:17:30 -0600
From: Alex Chiang <achiang@hp.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       linux-pci <linux-pci@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, willy@linux.intel.com
Subject: Re: [PATCH] PCI: create function symlinks in /sys/bus/pci/slots/N/
Message-ID: <20100322181730.GA6310@ldl.fc.hp.com>
References: <20100308172429.GA20953@ldl.fc.hp.com> <20100319144625.4247b7e6@jbarnes-piketon> <86802c441003201052taa660c0n2098e3ced56d2f1d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c441003201052taa660c0n2098e3ced56d2f1d@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Yinghai Lu <yinghai@kernel.org>:
> On Fri, Mar 19, 2010 at 2:46 PM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> > On Mon, 8 Mar 2010 10:24:29 -0700
> > Alex Chiang <achiang@hp.com> wrote:
> >
> >> Create convenience symlinks in sysfs, linking slots to device
> >> functions, and vice versa. These links make it easier for users to
> >> figure out which devices actually live in what slots.
> >>
> >> For example:
> >
> > Applied to linux-next, thanks.
> 
> looks this one cause
> 
> [  225.210695] calling  pci_sysfs_init+0x0/0x51 @ 1
> [  225.224774] ------------[ cut here ]------------
> [  225.228913] WARNING: at fs/sysfs/dir.c:451 sysfs_add_one+0xd9/0xf3()
> [  225.245349] Hardware name: Sun Fire x4800
> [  225.247894] sysfs: cannot create duplicate filename
> '/devices/pci0000:00/0000:00:03.0/0000:02:00.0/slot'

That's really not supposed to happen.

It means that somehow, a single pci_dev is associated with
multiple slots.

There are dev_dbg statements in pci_create_slot() that should
display which slots are getting associated with which pci_dev
during initialization.

Can you please turn those debug statements on and send the
output?

Thanks,
/ac

