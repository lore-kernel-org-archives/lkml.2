Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069Ab1BFU4f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 15:56:35 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:41387 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754002Ab1BFU4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 15:56:33 -0500
Date: Sun, 6 Feb 2011 20:56:19 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: akpm@linux-foundation.org, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, rpurdie@rpsys.net
Subject: Re: [PATCH 5/5] ACPI: Tie ACPI backlight devices to PCI devices if
	possible
Message-ID: <20110206205619.GA21472@srcf.ucam.org>
References: <1295033065-13450-1-git-send-email-mjg@redhat.com> <1295033065-13450-5-git-send-email-mjg@redhat.com> <201102062135.08171.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201102062135.08171.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 06, 2011 at 09:35:07PM +0100, Rafael J. Wysocki wrote:
> > +		acpi_get_parent(device->dev->handle, &acpi_parent);
> > +
> > +		pdev = acpi_get_pci_dev(acpi_parent);
> > +		if (pdev) {
> > +			parent = &pdev->dev;
> > +			pci_dev_put(pdev);
> > +		}
> 
> I'm afraid you can't do that or suspend problems will happen.

Ugh. Ok, how can we fix this?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
