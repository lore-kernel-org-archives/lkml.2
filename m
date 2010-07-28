Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756592Ab0G1WNt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 18:13:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44741 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756551Ab0G1WNp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 18:13:45 -0400
Subject: Re: [PATCH V3] VFIO driver: Non-privileged user level PCI drivers
From: Alex Williamson <alex.williamson@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Tom Lyon <pugs@cisco.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, randy.dunlap@oracle.com, arnd@arndb.de,
        chrisw@sous-sol.org, joro@8bytes.org, hjk@linutronix.de,
        avi@redhat.com, gregkh@suse.de, aafabbri@cisco.com, scofeldm@cisco.com
In-Reply-To: <20100728215739.GA9671@redhat.com>
References: <4c40d618./j7HFMCg9NusCIiB%pugs@cisco.com>
	 <201007271513.15093.pugs@cisco.com> <20100727235322.GB19930@redhat.com>
	 <201007281414.22335.pugs@cisco.com> <1280354222.3919.12.camel@x201>
	 <20100728215739.GA9671@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Jul 2010 16:13:19 -0600
Message-ID: <1280355199.3919.22.camel@x201>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-29 at 00:57 +0300, Michael S. Tsirkin wrote:
> On Wed, Jul 28, 2010 at 03:57:02PM -0600, Alex Williamson wrote:
> > 
> > Something like GET_MSIX_VECTORS seems like a user library routine to me.
> > The PCI config space is well specified and if we try to do more than
> > shortcut trivial operations (like getting the BAR length), we risk
> > losing functionality.  And for my purposes, translating to and from a
> > made up API to PCI for the guest seems like a pain.
> 
> Won't a userspace library do just as well for you?

You mean aside from qemu's reluctance to add dependencies for more
libraries?  My only concern is that I want enough virtualized/raw config
space that I'm not always translating PCI config accesses from the guest
into some userspace API.  If it makes sense to do this for things like
MSI, since I need someone to figure out what resources can actually be
allocated on the host, then maybe the library makes sense for that.
Then again, if every user needs to do this, let the vfio kernel driver
check what it can get and virtualize the available MSIs in exposed
config space, and my driver would be even happier.

Alex

