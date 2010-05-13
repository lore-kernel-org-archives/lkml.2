Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758677Ab0EMLDO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 07:03:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21697 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755588Ab0EMLDM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 07:03:12 -0400
Date: Thu, 13 May 2010 12:02:52 +0100
From: "Daniel P. Berrange" <berrange@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Chris Wright <chrisw@sous-sol.org>, greg@kroah.com,
       jbarnes@virtuousgeek.org, matthew@wil.cx, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org, ddutile@redhat.com,
       alex.williamson@redhat.com
Subject: Re: [PATCH 2/2] pci: allow sysfs file owner to read device dependent config space
Message-ID: <20100513110252.GE12207@redhat.com>
Reply-To: "Daniel P. Berrange" <berrange@redhat.com>
References: <20100513012857.GA28034@sequoia.sous-sol.org> <20100513012957.GB28034@sequoia.sous-sol.org> <4BEBDAF5.3020004@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BEBDAF5.3020004@redhat.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 13, 2010 at 01:56:53PM +0300, Avi Kivity wrote:
> On 05/13/2010 04:29 AM, Chris Wright wrote:
> >The PCI config space bin_attr read handler has a hardcoded CAP_SYS_ADMIN
> >check to verify privileges before allowing a user to read device
> >dependent config space.  This is meant to protect from an unprivileged
> >user potentially locking up the box.
> >
> >When assigning a PCI device directly to a guest with libvirt and KVM,
> >the sysfs config space file is chown'd to the unprivileged user that
> >the KVM guest will run as.  The guest needs to have full access to the
> >device's config space since it's responsible for driving the device.
> >However, despite being the owner of the sysfs file, the CAP_SYS_ADMIN
> >check will not allow read access beyond the config header.
> >
> >With this patch the sysfs file owner is also considered privileged enough
> >to read all of the config space.
> >
> >   
> 
> Related questions:
> 
> - does sysfs support selinux labels?

With a recent enough kernel + selinux policy it does.

Regards,
Daniel
-- 
|: Red Hat, Engineering, London    -o-   http://people.redhat.com/berrange/ :|
|: http://libvirt.org -o- http://virt-manager.org -o- http://deltacloud.org :|
|: http://autobuild.org        -o-         http://search.cpan.org/~danberr/ :|
|: GnuPG: 7D3B9505  -o-   F3C9 553F A1DA 4AC2 5648 23C1 B3DF F742 7D3B 9505 :|
