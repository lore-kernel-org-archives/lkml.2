Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932587Ab2FGRnc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 13:43:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44750 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932456Ab2FGRn3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 13:43:29 -0400
Message-ID: <1339091004.26976.26.camel@ul30vt>
Subject: Re: [PATCH] PCI: Add Ralink RT2800 broken INTx masking quirk
From: Alex Williamson <alex.williamson@redhat.com>
To: Jan Kiszka <jan.kiszka@web.de>
Cc: Andreas Hartmann <andihartmann@01019freenet.de>, bhelgaas@google.com,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Date: Thu, 07 Jun 2012 11:43:24 -0600
In-Reply-To: <4FD0E27B.6060502@web.de>
References: <20120606212241.6627.98371.stgit@bling.home>
	  <4FD047A7.6050602@01019freenet.de> <1339088741.26976.19.camel@ul30vt>
	 <4FD0E27B.6060502@web.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-07 at 19:18 +0200, Jan Kiszka wrote:
> On 2012-06-07 19:05, Alex Williamson wrote:
> > On Thu, 2012-06-07 at 08:18 +0200, Andreas Hartmann wrote:
> >> Hello Alex,
> >>
> >> what about a module parameter to achieve this behaviour manually by
> >> the user without recompiling? I fear, there are much more candidates
> >> out there needing this "feature".
> > 
> > Yeah, that's probably a good idea.  For debugging and letting users have
> > a workaround rather than any kind of regular use.  I'll add a nointxmask
> > to vfio-pci with a description indicating that if it fixes a device to
> > report it for quirking.  Thanks,
> 
> Isn't this controllable on a per-device base from userspace (or is this
> what you mean)? That would nicely align to qemu-kvm's pci-assign
> share_intx property (and may allow to map pci-assign's user-visible
> interface to a vfio backend one day).

No, there's currently no per-device control of this from userspace with
VFIO.  It wouldn't be hard to make use of flags bits in the ioctls to
support it, but I don't just want to move the blacklist from the kernel
out to the user.  Thanks,

Alex

