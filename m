Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932195Ab0ENTR6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 15:17:58 -0400
Received: from kroah.org ([198.145.64.141]:57265 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759205Ab0ENTRs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 15:17:48 -0400
Date: Fri, 14 May 2010 12:09:23 -0700
From: Greg KH <greg@kroah.com>
To: Chris Wright <chrisw@sous-sol.org>, jbarnes@virtuousgeek.org
Cc: matthew@wil.cx, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, ddutile@redhat.com, alex.williamson@redhat.com
Subject: Re: [PATCH 2/2] pci: allow sysfs file owner to read device
 dependent config space
Message-ID: <20100514190923.GE2505@kroah.com>
References: <20100513012857.GA28034@sequoia.sous-sol.org>
 <20100513012957.GB28034@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100513012957.GB28034@sequoia.sous-sol.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 12, 2010 at 06:29:57PM -0700, Chris Wright wrote:
> The PCI config space bin_attr read handler has a hardcoded CAP_SYS_ADMIN
> check to verify privileges before allowing a user to read device
> dependent config space.  This is meant to protect from an unprivileged
> user potentially locking up the box.
> 
> When assigning a PCI device directly to a guest with libvirt and KVM,
> the sysfs config space file is chown'd to the unprivileged user that
> the KVM guest will run as.  The guest needs to have full access to the
> device's config space since it's responsible for driving the device.
> However, despite being the owner of the sysfs file, the CAP_SYS_ADMIN
> check will not allow read access beyond the config header.
> 
> With this patch the sysfs file owner is also considered privileged enough
> to read all of the config space.
> 
> Signed-off-by: Chris Wright <chrisw@sous-sol.org>
> ---
>  drivers/pci/pci-sysfs.c |    4 +++-

Jesse, any objection to this going through my tree as it will depend on
the sysfs change?

thanks,

greg k-h
