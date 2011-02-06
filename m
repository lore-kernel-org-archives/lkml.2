Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753860Ab1BFWlm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 17:41:42 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48576 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753259Ab1BFWlk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 17:41:40 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH 5/5] ACPI: Tie ACPI backlight devices to PCI devices if possible
Date: Sun, 6 Feb 2011 23:41:19 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc3+; KDE/4.4.4; x86_64; ; )
Cc: akpm@linux-foundation.org, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, rpurdie@rpsys.net
References: <1295033065-13450-1-git-send-email-mjg@redhat.com> <201102062135.08171.rjw@sisk.pl> <20110206205619.GA21472@srcf.ucam.org>
In-Reply-To: <20110206205619.GA21472@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102062341.19631.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, February 06, 2011, Matthew Garrett wrote:
> On Sun, Feb 06, 2011 at 09:35:07PM +0100, Rafael J. Wysocki wrote:
> > > +		acpi_get_parent(device->dev->handle, &acpi_parent);
> > > +
> > > +		pdev = acpi_get_pci_dev(acpi_parent);
> > > +		if (pdev) {
> > > +			parent = &pdev->dev;
> > > +			pci_dev_put(pdev);
> > > +		}
> > 
> > I'm afraid you can't do that or suspend problems will happen.
> 
> Ugh. Ok, how can we fix this?

Not nicely, I'm afraid.

One possible way is to use device_pm_move_after() to rearrange the devices in
the PM core's suspend list, but that will happen in the video device being
suspended before the new parent (and resumed after it) -- of course, the only
option is to move the ACPI video device after the new parent.

Thanks,
Rafael
