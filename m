Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751357Ab1I0PSx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 11:18:53 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37523 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750824Ab1I0PSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 11:18:52 -0400
Date: Tue, 27 Sep 2011 16:18:51 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Daniel Drake <dsd@laptop.org>, sameo@linux.intel.com,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        dilinger@queued.net
Subject: Re: [PATCH 1/3] mfd: allow mfd_cell association with device tree node
Message-ID: <20110927151850.GN4289@opensource.wolfsonmicro.com>
References: <20110921120148.4A81E9D401D@zog.reactivated.net>
 <20110921124936.GA25620@sirena.org.uk>
 <CAMLZHHQZnajC4e12MjaK3W8WcAB2ZB+6L=5kS5BBFZF=+YWicQ@mail.gmail.com>
 <20110921131637.GF4374@opensource.wolfsonmicro.com>
 <CAMLZHHTJaOddSj00g0-WpFQu6pUTqizKjKaQF9hLrhceEMhY1Q@mail.gmail.com>
 <20110927150555.GF20588@ponder.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110927150555.GF20588@ponder.secretlab.ca>
X-Cookie: You will outgrow your usefulness.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 27, 2011 at 09:05:55AM -0600, Grant Likely wrote:
> On Tue, Sep 27, 2011 at 03:44:56PM +0100, Daniel Drake wrote:
> > On Wed, Sep 21, 2011 at 2:16 PM, Mark Brown

> > > My suspicion is that for device tree in cases where the MFD really is
> > > totally independent of the parent we shouldn't need explicit MFD code to
> > > instantiate the child at all any more in the same way that we should be
> > > avoiding this for the SoCs.

> Right. MFD seems to be most useful when IP blocks are used in multiple
> places and can be instantiated by multiple parents.  Sometimes a
> driver really should just register the interfaces that the device
> provides without the MFD framework.

Well, if you need a bunch of platform devices it's a good way of
creating them especially in the current world.  There's also generally
some core logic, for example routing interrupt lines, that can usefully
be provided by the MFD part of the driver.
