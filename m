Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932892Ab2AEVgL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 16:36:11 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:47739 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932437Ab2AEVgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 16:36:08 -0500
Date: Thu, 5 Jan 2012 16:34:23 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Don Dutile <ddutile@redhat.com>
Cc: Ian Campbell <Ian.Campbell@citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [Xen-devel] [PATCH 2/5] xen/pciback: Support pci_reset_function,
 aka FLR or D3 support.
Message-ID: <20120105213423.GC5180@phenom.dumpdata.com>
References: <1325724403-29642-1-git-send-email-konrad.wilk@oracle.com>
 <1325724403-29642-3-git-send-email-konrad.wilk@oracle.com>
 <1325759051.25206.361.camel@zakaz.uk.xensource.com>
 <4F05F2EA.5030502@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F05F2EA.5030502@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090207.4F0617C3.00D4,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 05, 2012 at 01:58:50PM -0500, Don Dutile wrote:
> On 01/05/2012 05:24 AM, Ian Campbell wrote:
> >On Thu, 2012-01-05 at 00:46 +0000, Konrad Rzeszutek Wilk wrote:
> >>We use the __pci_reset_function_locked to perform the action.
> >>Also on attaching ("bind") and detaching ("unbind") we save and
> >>restore the configuration states. When the device is disconnected
> >>from a guest we use the "pci_reset_function" to also reset the
> >>device before being passed to another guest.
> >
> >Currently I thought the toolstack was supposed to do the reset (by
> >writing to the reset node in sysfs) as it was (de)assigning devices
> >to/from guests. That's not to say that there isn't an argument for
> >preferring to do it kernels side but it would be interesting to make
> >that argument explicitly.
> >
> >I guess the toolstack doesn't currently save/restore the configuration
> >state, could it though? I guess the state is all available in sysfs. On
> pci_reset_function() saves the config state before doing a fcn-level reset.
> 
> the libvirt toolstack handles the unbind/reset/bind functionality
> and is used by kvm for it's device assignment.

The KVM assigned PCI module does the call as well via the ioctls when
assigning/de-assigning the PCI device. Look in 'kvm_free_assigned_device'
and in 'kvm_vm_ioctl_assign_device'.

Is that what you mean by the unbind/reset/bind functionality - the ioctl
call?

