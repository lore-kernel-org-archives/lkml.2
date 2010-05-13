Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932501Ab0EMTQo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 15:16:44 -0400
Received: from sous-sol.org ([216.99.217.87]:60319 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757368Ab0EMTQk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 15:16:40 -0400
Date: Thu, 13 May 2010 12:16:19 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Greg KH <greg@kroah.com>
Cc: Chris Wright <chrisw@sous-sol.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       jbarnes@virtuousgeek.org, matthew@wil.cx, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org, ddutile@redhat.com,
       alex.williamson@redhat.com
Subject: Re: [PATCH 2/2 v2] pci: check caps from sysfs file open to read
 device dependent config space
Message-ID: <20100513191619.GI28034@sequoia.sous-sol.org>
References: <20100513012857.GA28034@sequoia.sous-sol.org>
 <20100513012957.GB28034@sequoia.sous-sol.org>
 <20100513105911.6469c434@lxorguk.ukuu.org.uk>
 <20100513174307.GH28034@sequoia.sous-sol.org>
 <20100513190636.GC5979@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100513190636.GC5979@kroah.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Greg KH (greg@kroah.com) wrote:
> On Thu, May 13, 2010 at 10:43:07AM -0700, Chris Wright wrote:
> > * Alan Cox (alan@lxorguk.ukuu.org.uk) wrote:
> > > I agree with the problem - but IMHO the fix is to require opening the file
> > > checks CAP_SYS_something instead: not to hack the read method and make it
> > > even weirder and more un-Linux than it is now.
> > 
> > This patch does that.  Not as convenient from the KVM/libvirt point of view
> > because it is not prepared to do this setup before dropping privileges
> > and launching the VM.
> 
> So does that mean that this patch doesn't solve your original problem
> here?

Right, it means we have to change how we create a guest with a directly
assigned PCI device.

Currently KVM/libvirt is assuming that sysfs file ownership is sufficient
to read a sysfs file.  It chowns all relevant sysfs files and updates
security labels such that only that guest can access the files, then
drops privileges and launches the guest.

With the v2 patch we'll have to open the config space sysfs file in the
privileged context and pass it into the unprivileged one.  It is awkward,
but it should be doable.

thanks,
-chris
