Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759058Ab2DYUwN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 16:52:13 -0400
Received: from imr4.ericy.com ([198.24.6.9]:55022 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754243Ab2DYUwM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 16:52:12 -0400
Message-ID: <1335387002.18790.145.camel@groeck-laptop>
Subject: Re: [ 03/62] hwmon: fam15h_power: fix bogus values with current
 BIOSes
From: Guenter Roeck <guenter.roeck@ericsson.com>
Reply-To: guenter.roeck@ericsson.com
To: Ben Hutchings <ben@decadent.org.uk>
CC: Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        Andre Przywara <andre.przywara@amd.com>,
        Jean Delvare <khali@linux-fr.org>
Date: Wed, 25 Apr 2012 13:50:02 -0700
In-Reply-To: <20120425194506.GG3932@decadent.org.uk>
References: <20120424223305.GA7748@kroah.com>
	 <20120424223242.251771207@linuxfoundation.org>
	 <20120425194506.GG3932@decadent.org.uk>
Organization: Ericsson
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-04-25 at 15:45 -0400, Ben Hutchings wrote:
> On Tue, Apr 24, 2012 at 03:32:44PM -0700, Greg KH wrote:
> > 3.3-stable review patch.  If anyone has any objections, please let me know.
> [...]
> > +static void __devinit tweak_runavg_range(struct pci_dev *pdev)
> > +{
> > +	u32 val;
> > +	const struct pci_device_id affected_device = {
> > +		PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_15H_NB_F4) };
> > +
> > +	/*
> > +	 * let this quirk apply only to the current version of the
> > +	 * northbridge, since future versions may change the behavior
> > +	 */
> > +	if (!pci_match_id(&affected_device, pdev))
> > +		return;
> [...]
> 
> pci_match_id() takes an *array* of IDs which must be properly zero-
> terminated.  This change is bogus and should be fixed up before it
> goes into a stable update.

Good catch. I sent a patch to fix this in mainline a minute ago.

Guenter


