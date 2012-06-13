Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497Ab2FMK51 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 06:57:27 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:55392 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252Ab2FMK5Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 06:57:25 -0400
Date: Wed, 13 Jun 2012 12:00:50 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Jeff Garzik <jgarzik@pobox.com>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Aaron Lu <aaron.lu@amd.com>, Holger Macht <holger@homac.de>,
        Matthew Garrett <mjg@redhat.com>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v4 02/13] libata: bind the Linux device tree to the ACPI
 device tree
Message-ID: <20120613120050.164c3f29@pyramind.ukuu.org.uk>
In-Reply-To: <CAF1ivSYBjw+UP3vP8RHaftjR8NJZEaHA1rtJ5ujDjkj-djHLTQ@mail.gmail.com>
References: <1338181720-4149-1-git-send-email-ming.m.lin@intel.com>
	<1338181720-4149-3-git-send-email-ming.m.lin@intel.com>
	<20120528105131.67d74d45@pyramind.ukuu.org.uk>
	<CAF1ivSYBjw+UP3vP8RHaftjR8NJZEaHA1rtJ5ujDjkj-djHLTQ@mail.gmail.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Jun 2012 16:03:23 +0800
Lin Ming <ming.m.lin@intel.com> wrote:

> On Mon, May 28, 2012 at 5:51 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> >> +static int is_pci_ata(struct device *dev)
> >> +{
> >> +     struct pci_dev *pdev;
> >> +
> >> +     if (!is_pci_dev(dev))
> >> +             return 0;
> >> +
> >> +     pdev = to_pci_dev(dev);
> >> +
> >> +     if ((pdev->class >> 8) != PCI_CLASS_STORAGE_SATA &&
> >> +         (pdev->class >> 8) != PCI_CLASS_STORAGE_IDE)
> >> +             return 0;
> >
> > This needs a better name. It doesn't check if a device is PCI ATA or
> > anything of the sort, it checks if its probably a device in compatibility
> > mode. A lot of controllers will in fact report RAID class or similar in
> > native mode.
> 
> How about compat_pci_ata?

Sounds reasonable. I'm not btw sure the test is entirely right, but I'm
not sure quite what you are trying to figure out from it and how ACPI
expects this mapping to work.

Alan
