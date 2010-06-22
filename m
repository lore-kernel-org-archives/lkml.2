Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753617Ab0FVSn6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 14:43:58 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38665 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753055Ab0FVSn4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 14:43:56 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Matthew Garrett <mjg@redhat.com>
Subject: Re: [PATCH] ACPI: Disable ASPM if the platform won't provide _OSC control for PCIe
Date: Tue, 22 Jun 2010 20:42:14 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.35-rc3-rjw+; KDE/4.4.3; x86_64; ; )
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1277220343-25168-1-git-send-email-mjg@redhat.com> <201006222017.30023.rjw@sisk.pl> <20100622112908.4122ceb2@virtuousgeek.org>
In-Reply-To: <20100622112908.4122ceb2@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006222042.14774.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, June 22, 2010, Jesse Barnes wrote:
> On Tue, 22 Jun 2010 20:17:29 +0200
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > On Tuesday, June 22, 2010, Matthew Garrett wrote:
> > > The PCI SIG documentation for the _OSC OS/firmware handshaking interface
> > > states:
> > > 
> > > "If the _OSC control method is absent from the scope of a host bridge
> > > device, then the operating system must not enable or attempt to use any
> > > features defined in this section for the hierarchy originated by the host
> > > bridge."
> > > 
> > > The obvious interpretation of this is that the OS should not attempt to use
> > > PCIe hotplug, PME or AER - however, the specification also notes that an
> > > _OSC method is *required* for PCIe hierarchies, and experimental validation
> > > with An Alternative OS indicates that it doesn't use any PCIe functionality
> > > if the _OSC method is missing. That arguably means we shouldn't be using
> > > MSI or extended config space, but right now our problems seem to be limited
> > > to vendors being surprised when ASPM gets enabled on machines when other
> > > OSs refuse to do so. So, for now, let's just disable ASPM if the _OSC
> > > method doesn't exist or refuses to hand over PCIe capability control.
> > > 
> > > Signed-off-by: Matthew Garrett <mjg@redhat.com>
> > 
> > Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Applied to my linux-next branch, thanks.

I think it's 2.6.35 (and probably -stable) material, these problems aleady
happen in the field.

Matthew, what do you think?

Rafael
