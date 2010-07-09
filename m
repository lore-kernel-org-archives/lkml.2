Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758511Ab0GIRPd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 13:15:33 -0400
Received: from ausc60ps301.us.dell.com ([143.166.148.206]:64523 "EHLO
	ausc60ps301.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758213Ab0GIRPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 13:15:31 -0400
X-Loopcount0: from 143.166.82.43
Date: Fri, 9 Jul 2010 12:15:29 -0500
From: Matt Domsch <Matt_Domsch@dell.com>
To: "Loke, Chetan" <Chetan.Loke@netscout.com>
Cc: Florian Weimer <fweimer@bfk.de>, linux-net@vger.kernel.org,
       Michael Di Domenico <mdidomenico4@gmail.com>,
       linux-kernel@vger.kernel.org, kay.sievers@vrfy.org
Subject: Re: nic enumeration
Message-ID: <20100709171529.GA27241@auslistsprd01.us.dell.com>
References: <82tyo9i0n2.fsf@mid.bfk.de> <D3F292ADF945FB49B35E96C94C2061B90C3CF3E9@nsmail.netscout.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D3F292ADF945FB49B35E96C94C2061B90C3CF3E9@nsmail.netscout.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 09, 2010 at 12:27:53PM -0400, Loke, Chetan wrote:
> Ok, no renaming, I would like a reference. And symlink just doesn't work
> w/ the udevadm trigger business. We've tried that already.
> 
> What needs to be changed in udev etc to create a soft link? Any place
> where I should start digging and gotchas to lookout for?

Unlike disks which have /dev/disk/by-{id,path,uuid}/* symlinks back to
/dev/sd*, which udev manages, network devices have no such on-disk
representation for udev to manage.  My proposal to create such on-disk
mappings was shot down, as was my suggestion to create (multiple)
network device symlinks/references/aliases inside the kernel.

The approach I'm pursuing now is called libnetdevname[1], which can
take as input a device name from various name spaces (BIOS-provided
from SMBIOS or in future, ACPI, or perhaps a userspace mapping similar
to /etc/mactab in concept), and which as output is the single kernel
name for a device.  Once plumbed into the tools that manipulate
network devices, it would allow you to do:
  # ip addr add xx.xx.xx.xx dev Embedded_NIC_1
and have "Embedded_NIC_1" map to the appropriate "ethN", for use by
the calls into the kernel.

In this case, Embedded_NIC_1 would come from BIOS; conceivably other
namespace sources could hook into this same framework then.

FWIW, I have a talk at LinuxCon Boston coming up on this, and have a
proposal in for Linux Plumbers Conference as well.

Thanks,
Matt

[1] http://linux.dell.com/wiki/index.php/Oss/libnetdevname 

-- 
Matt Domsch
Technology Strategist
Dell | Office of the CTO
