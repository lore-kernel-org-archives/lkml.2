Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758185Ab2DYTpO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 15:45:14 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52762 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757829Ab2DYTpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 15:45:12 -0400
Date: Wed, 25 Apr 2012 20:45:06 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Andre Przywara <andre.przywara@amd.com>,
        Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>
Message-ID: <20120425194506.GG3932@decadent.org.uk>
References: <20120424223305.GA7748@kroah.com>
 <20120424223242.251771207@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120424223242.251771207@linuxfoundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [ 03/62] hwmon: fam15h_power: fix bogus values with current
 BIOSes
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 24, 2012 at 03:32:44PM -0700, Greg KH wrote:
> 3.3-stable review patch.  If anyone has any objections, please let me know.
[...]
> +static void __devinit tweak_runavg_range(struct pci_dev *pdev)
> +{
> +	u32 val;
> +	const struct pci_device_id affected_device = {
> +		PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_15H_NB_F4) };
> +
> +	/*
> +	 * let this quirk apply only to the current version of the
> +	 * northbridge, since future versions may change the behavior
> +	 */
> +	if (!pci_match_id(&affected_device, pdev))
> +		return;
[...]

pci_match_id() takes an *array* of IDs which must be properly zero-
terminated.  This change is bogus and should be fixed up before it
goes into a stable update.

Ben.

-- 
Ben Hutchings
We get into the habit of living before acquiring the habit of thinking.
                                                              - Albert Camus
