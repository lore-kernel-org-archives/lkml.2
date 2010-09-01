Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483Ab0IAPAl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 11:00:41 -0400
Received: from cantor.suse.de ([195.135.220.2]:40744 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754953Ab0IAPAk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 11:00:40 -0400
Date: Wed, 1 Sep 2010 08:00:52 -0700
From: Greg KH <gregkh@suse.de>
To: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
Cc: mjg59@srcf.ucam.org, linux-kernel@vger.kernel.org, mjg@redhat.com,
        jlee@novell.com, Dennis.Jansen@web.de, linux-acpi@vger.kernel.org,
        trenn@suse.de
Subject: Re: [PATCH] Add Intel Poulsbo Stub Driver
Message-ID: <20100901150052.GA26036@suse.de>
References: <1283332119-26352-1-git-send-email-jlee@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283332119-26352-1-git-send-email-jlee@novell.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 01, 2010 at 05:08:39PM +0800, Lee, Chun-Yi wrote:
> +static struct pci_device_id pciidlist[] = {
> +	{0x8086, 0x8108, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_PSB_8108}, \
> +	{0x8086, 0x8109, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_PSB_8109}, \
> +	{0, 0, 0}
> +};

Now that you have this, just use:
	MODULE_DEVICE_TABLE(pci, pciidlist);
instead of:

> +MODULE_ALIAS("pci:v00008086d00008108sv*sd*bc*sc*i*");
> +MODULE_ALIAS("pci:v00008086d00008109sv*sd*bc*sc*i*");

As the proper alias will automatically get generated from the
MODULE_DEVICE_TABLE() macro.

thanks,

greg k-h
