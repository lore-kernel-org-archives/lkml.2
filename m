Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756256Ab0KSAjd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 19:39:33 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:63129 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808Ab0KSAjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 19:39:32 -0500
Date: Thu, 18 Nov 2010 17:39:29 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: David Daney <ddaney@caviumnetworks.com>
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Cyril Chemparathy <cyril@ti.com>,
        Arnaud Patard <arnaud.patard@rtp-net.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 1/2] of/phylib: Use device tree properties to
 initialize Marvell PHYs.
Message-ID: <20101119003929.GA18558@angua.secretlab.ca>
References: <1290038071-13296-1-git-send-email-ddaney@caviumnetworks.com>
 <1290038071-13296-2-git-send-email-ddaney@caviumnetworks.com>
 <20101118204036.GA16908@angua.secretlab.ca>
 <4CE5BB56.4040605@caviumnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CE5BB56.4040605@caviumnetworks.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 03:48:38PM -0800, David Daney wrote:
> On 11/18/2010 12:40 PM, Grant Likely wrote:
> >On Wed, Nov 17, 2010 at 03:54:30PM -0800, David Daney wrote:
> >>Some aspects of PHY initialization are board dependent, things like
> >>indicator LED connections and some clocking modes cannot be determined
> >>by probing.  The dev_flags element of struct phy_device can be used to
> >>control these things if an appropriate value can be passed from the
> >>Ethernet driver.  We run into problems however if the PHY connections
> >>are specified by the device tree.  There is no way for the Ethernet
> >>driver to know what flags it should pass.
> >>
> >>If we are using the device tree, the struct phy_device will be
> >>populated with the device tree node corresponding to the PHY, and we
> >>can extract extra configuration information from there.
> >>
> >>The next question is what should the format of that information be?
> >>It is highly device specific, and the device tree representation
> >>should not be tied to any arbitrary kernel defined constants.  A
> >>straight forward representation is just to specify the exact bits that
> >>should be set using the "marvell,reg-init" property:
> >>
> >>       phy5: ethernet-phy@5 {
> >>	reg =<5>;
> >>	device_type = "ethernet-phy";
> >
> >Some notes:
> >- device_type is only relevant for real openfirmware platforms.  It
> >   should not appear in dts files.
> 
> Documentation/powerpc/dts-bindings/phy.txt says device_type should
> be here.  I can remove it from my patch comment, but should it also
> be removed from the phy.txt file?

Heh, I didn't realize it was there.  Yes, it should be removed from
the phy.txt file.  It is clearly wrong.

> 
> >- This example phy node needs a compatible property
> 
> Ok, what would you suggest?  Something like:
> 
>      compatible = "marvell,88e1145";

Yes.

> 
> I can certainly do that, but I would note that the kernel probes
> these things and would completely ignore the compatible property.

That's okay.

> 
> >- This new binding needs to be documented.  You can use devicetree.org.
> >
> 
> Agreed, I was planning to do that once the patch was approved.
> 
> Where would that go?  Vendor:Marvell, or
> Type:PHY/compatible=marvell,* ... or somewhere else?

The page name should be compatible=marvell,88e1145, and it should be
have the vendor and type tags added so it appears in the category
pages.

g.
