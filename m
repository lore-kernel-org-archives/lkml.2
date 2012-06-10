Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755704Ab2FJTAw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 15:00:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37163 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751315Ab2FJTAu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 15:00:50 -0400
Date: Sun, 10 Jun 2012 22:00:36 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: "Hans J. Koch" <hjk@hansjkoch.de>,
        Andreas Hartmann <andihartmann@01019freenet.de>,
        Dominic Eschweiler <eschweiler@fias.uni-frankfurt.de>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] uio_pci_generic does not export memory resources
Message-ID: <20120610190036.GD10523@redhat.com>
References: <4FD1FB49.3020905@siemens.com>
 <1339165009.26976.60.camel@ul30vt>
 <1339166867.3870.29.camel@blech>
 <4FD22552.6090609@01019freenet.de>
 <20120608164426.GE9705@local>
 <1339175476.26976.102.camel@ul30vt>
 <20120610141759.GB8922@redhat.com>
 <1339344566.26976.272.camel@ul30vt>
 <20120610164429.GB9879@redhat.com>
 <1339349905.26976.306.camel@ul30vt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339349905.26976.306.camel@ul30vt>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 10, 2012 at 11:38:25AM -0600, Alex Williamson wrote:
> On Sun, 2012-06-10 at 19:44 +0300, Michael S. Tsirkin wrote:
> > On Sun, Jun 10, 2012 at 10:09:26AM -0600, Alex Williamson wrote:
> > > On Sun, 2012-06-10 at 17:18 +0300, Michael S. Tsirkin wrote:
> > > > On Fri, Jun 08, 2012 at 11:11:16AM -0600, Alex Williamson wrote:
> > > > > On Fri, 2012-06-08 at 18:44 +0200, Hans J. Koch wrote:
> > > > > > On Fri, Jun 08, 2012 at 06:16:18PM +0200, Andreas Hartmann wrote:
> > > > > > > Hi Dominic,
> > > > > > > 
> > > > > > > Dominic Eschweiler wrote:
> > > > > > > > Am Freitag, den 08.06.2012, 08:16 -0600 schrieb Alex Williamson:
> > > > > > > >> Yes, thanks Jan.  This is exactly what VFIO does.  VFIO provides
> > > > > > > >> secure config space access, resource access, DMA mapping services, and
> > > > > > > >> full interrupt support to userspace.  
> > > > > > 
> > > > > > VFIO is not a "better UIO". It *requires* an IOMMU. Dominic didn't say on
> > > > > > what CPU he's working, so it's not clear if he can use VFIO at all.
> > > > > > 
> > > > > > UIO is intended for general use with devices that have mappable registers
> > > > > > and don't fit into any other subsystem. No more, no less.
> > > > > 
> > > > > VFIO is a secure UIO.
> > > > 
> > > > A secure UIO *for VFs*. I think that's why it's called VFIO :).
> > > > Other stuff sometimes also works but no real guarantees, though
> > > > VFIO tries to make sure you don't burn yourself too badly
> > > > if it breaks.
> > > 
> > > We do a little better than that.  Multifunction devices that don't
> > > explicitly report ACS support are grouped together, so we have security
> > > for multifunction devices as well.
> > 
> > How can you get security with insecure hardware?
> > 
> > So you prevent the device from writing to host memory? Cool.
> > Now guest puts a virus on an on-card flash, the
> > moment device is assigned to another VM it will own that,
> > or host if it's enabled in host.
> > 
> > I can make up more silliness.  Buggy userspace can brick the device,
> > e.g. by damaging the internal eeprom memory, and these things were known
> > to happen even by accident.
> > 
> > Simply put if you want secure userspace drivers you must be able to
> > trust your hardware for security and the only hardware that promises you
> > security is a VF in an SRIOV device.

One thing I stand corrected on: assigning a PF that does DMA with VFIO
*might* be secure, and sometimes, maybe often, is.
There's just no way to make sure.
This is unlike uio_pci_generic where it would always be insecure.

-- 
MST
