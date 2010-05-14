Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190Ab0ENT1O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 15:27:14 -0400
Received: from cpoproxy2-pub.bluehost.com ([67.222.39.38]:44086 "HELO
	outbound-mail-158.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751538Ab0ENT1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 15:27:12 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=qop2YLafuSwZrl4vgWwbrQF5jljGw653v3HQfqjy3E05EcU5dzSFcdGsUJte+myYj3gLaN7fbUCvKnfsH+Uge40Zoio/FFVbfvPOCOBbe2l/3mi79XRzn5wMvnK31HV1;
Date: Fri, 14 May 2010 12:26:15 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Greg KH <greg@kroah.com>
Cc: Chris Wright <chrisw@sous-sol.org>, matthew@wil.cx,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, ddutile@redhat.com, alex.williamson@redhat.com
Subject: Re: [PATCH 2/2] pci: allow sysfs file owner to read device
 dependent config space
Message-ID: <20100514122615.69026481@virtuousgeek.org>
In-Reply-To: <20100514190923.GE2505@kroah.com>
References: <20100513012857.GA28034@sequoia.sous-sol.org>
	<20100513012957.GB28034@sequoia.sous-sol.org>
	<20100514190923.GE2505@kroah.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 May 2010 12:09:23 -0700
Greg KH <greg@kroah.com> wrote:

> On Wed, May 12, 2010 at 06:29:57PM -0700, Chris Wright wrote:
> > The PCI config space bin_attr read handler has a hardcoded CAP_SYS_ADMIN
> > check to verify privileges before allowing a user to read device
> > dependent config space.  This is meant to protect from an unprivileged
> > user potentially locking up the box.
> > 
> > When assigning a PCI device directly to a guest with libvirt and KVM,
> > the sysfs config space file is chown'd to the unprivileged user that
> > the KVM guest will run as.  The guest needs to have full access to the
> > device's config space since it's responsible for driving the device.
> > However, despite being the owner of the sysfs file, the CAP_SYS_ADMIN
> > check will not allow read access beyond the config header.
> > 
> > With this patch the sysfs file owner is also considered privileged enough
> > to read all of the config space.
> > 
> > Signed-off-by: Chris Wright <chrisw@sous-sol.org>
> > ---
> >  drivers/pci/pci-sysfs.c |    4 +++-
> 
> Jesse, any objection to this going through my tree as it will depend on
> the sysfs change?

Aside from the concerns Alan raised, yeah that's fine.

But I guess it was your idea to rely on the CAP bits rather than
ownership, so you get to decide how to clean up the mess. :)

I really wish ownership was enough in sysfs, but we were too weak in
the beginning and allowed userspace bugs (like walking all of sysfs and
reading every file) to scare us into putting weird enable flags and
checks like this in...

-- 
Jesse Barnes, Intel Open Source Technology Center
