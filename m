Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752433Ab2JAMJL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 08:09:11 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41519 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750929Ab2JAMJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 08:09:09 -0400
Date: Mon, 1 Oct 2012 13:09:07 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "ABRAHAM, KISHON VIJAY" <kishon@ti.com>
Cc: Sourav Poddar <sourav.poddar@ti.com>, devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        b-cousson@ti.com, balbi@ti.com, santosh.shilimkar@ti.com,
        sameo@linux.intel.com
Subject: Re: [PATCHv3 1/4] mfd: smsc: Add support for smsc gpio io/keypad
 driver
Message-ID: <20121001120907.GK4360@opensource.wolfsonmicro.com>
References: <1349089282-22105-1-git-send-email-sourav.poddar@ti.com>
 <CAAe_U6+zEGuwMC1yn7O=LXE6PhPvPc2i7DCF0EAprkE8s+-iEw@mail.gmail.com>
 <20121001114454.GA9170@sirena.org.uk>
 <CAAe_U6JX9QDWvWA3KH7E9sOv0EHGkozVONuXDgn+a2MZ4GTE7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAe_U6JX9QDWvWA3KH7E9sOv0EHGkozVONuXDgn+a2MZ4GTE7Q@mail.gmail.com>
X-Cookie: You look tired.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 01, 2012 at 05:23:15PM +0530, ABRAHAM, KISHON VIJAY wrote:
> On Mon, Oct 1, 2012 at 5:14 PM, Mark Brown

> > No, this is not at all sensible - if there's an mfd_remove_devices()
> > function we really ought to be able to use it to remove the children.
> > If we can't do that we should fix the API usability, not open code the
> > same stuff in every user.

> What makes more sense to me is extend mfd_add_devices to create child
> devices from dt data. Then for removing devices, one can use
> mfd_remove_devices().

Why would that be helpful?  Most platforms don't support DT at all, and
having the API behave differently depending on the platform doesn't seem
like a step forwards.  I would really expect any usage of DT to be
totally orthogonal here.
