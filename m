Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389Ab2DZVPc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 17:15:32 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:61012 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754374Ab2DZVPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 17:15:31 -0400
Date: Thu, 26 Apr 2012 14:15:26 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Ben Hutchings <ben@decadent.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        Andre Przywara <andre.przywara@amd.com>,
        Jean Delvare <khali@linux-fr.org>
Subject: Re: [ 03/62] hwmon: fam15h_power: fix bogus values with current
 BIOSes
Message-ID: <20120426211526.GA372@kroah.com>
References: <20120424223305.GA7748@kroah.com>
 <20120424223242.251771207@linuxfoundation.org>
 <20120425194506.GG3932@decadent.org.uk>
 <1335387002.18790.145.camel@groeck-laptop>
 <20120426164308.GA18682@kroah.com>
 <1335458867.2351.30.camel@groeck-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335458867.2351.30.camel@groeck-laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2012 at 09:47:47AM -0700, Guenter Roeck wrote:
> On Thu, 2012-04-26 at 12:43 -0400, Greg KH wrote:
> > On Wed, Apr 25, 2012 at 01:50:02PM -0700, Guenter Roeck wrote:
> > > On Wed, 2012-04-25 at 15:45 -0400, Ben Hutchings wrote:
> > > > On Tue, Apr 24, 2012 at 03:32:44PM -0700, Greg KH wrote:
> > > > > 3.3-stable review patch.  If anyone has any objections, please let me know.
> > > > [...]
> > > > > +static void __devinit tweak_runavg_range(struct pci_dev *pdev)
> > > > > +{
> > > > > +	u32 val;
> > > > > +	const struct pci_device_id affected_device = {
> > > > > +		PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_15H_NB_F4) };
> > > > > +
> > > > > +	/*
> > > > > +	 * let this quirk apply only to the current version of the
> > > > > +	 * northbridge, since future versions may change the behavior
> > > > > +	 */
> > > > > +	if (!pci_match_id(&affected_device, pdev))
> > > > > +		return;
> > > > [...]
> > > > 
> > > > pci_match_id() takes an *array* of IDs which must be properly zero-
> > > > terminated.  This change is bogus and should be fixed up before it
> > > > goes into a stable update.
> > > 
> > > Good catch. I sent a patch to fix this in mainline a minute ago.
> > 
> > Is it in Linus's tree yet?  If so, what's the git commit id?  If not,
> > I'll have to drop it from this release.
> 
> It is not in Linus' tree yet. I plan to send the pull request tomorrow,
> after having it rest for another night in my tree (with nightly builds)
> and in linux-next.
> 
> Please drop the patch for now. The fix will include a reference to it,
> so you can pull both patches once the fix shows up in Linus' tree.

Now dropped.
