Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756767Ab0ITP1K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 11:27:10 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33754 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756644Ab0ITP1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 11:27:08 -0400
Date: Mon, 20 Sep 2010 16:27:06 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Alan Cox <alan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, grant.likely@secretlab.ca
Subject: Re: [PATCH] x86/mrst: add SFI platform device parsing code
Message-ID: <20100920152705.GJ3414@rakim.wolfsonmicro.main>
References: <20100920140049.31408.67527.stgit@localhost.localdomain>
 <20100920150431.GD31167@sirena.org.uk>
 <20100920152726.68ac2d84@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100920152726.68ac2d84@linux.intel.com>
X-Cookie: Do students of Zen Buddhism do Om-work?
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 20, 2010 at 03:27:26PM +0100, Alan Cox wrote:

> > It's rather concerning that the parser here needs to have all this
> > knowledge about the specific chips that will be on the boards.  Is
> > there a plan for how this will be managed once system integrators
> > begin putting other chips onto Moorestown boards?

> For a device that doesn't need any private structure passing it's just
> a case of knowing the Linux name that matches the firmware description.
> For a chip that already has a Linux driver that expects private data
> (or a new driver that needs to) the info has to come from somewhere and
> Linux packages it in per device fashion.

Right, we need to do something and given that folks decided that OF
wasn't for them... :/

> The parser has the knowledge precisely because we don't want to put the
> knowledge in the driver.

This is precisely the opposite approach to that which has been taken
with all the OF stuff where individual drivers take care of parsing
their own data out of the OF tree.  I guess it'd be good if we could
achieve some level of consistency on this one, though I have this
horrible feeling that we're going to end up with all sorts of board
specific workarounds in here, especially around things like audio where
you've got multiple chips working together.

The OF approach does have the advantage of avoiding collisions between
multiple devices, and gives us some hope that the driver maintainers may
have seen the definitions that are being created for the BIOSes.
