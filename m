Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755853Ab1DVSUf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 14:20:35 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:32799 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753697Ab1DVSUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 14:20:33 -0400
Date: Fri, 22 Apr 2011 20:20:23 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Seth Heasley <seth.heasley@intel.com>, linux-i2c@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.39-rc3] i2c-i801: SMBus patch for Intel Panther 
 Point DeviceIDs
Message-ID: <20110422202023.042a2509@endymion.delvare>
In-Reply-To: <20110422095259.4d5875d2@jbarnes-desktop>
References: <201104201133.39979.seth.heasley@intel.com>
	<20110422184449.06116327@endymion.delvare>
	<20110422095259.4d5875d2@jbarnes-desktop>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Apr 2011 09:52:59 -0700, Jesse Barnes wrote:
> On Fri, 22 Apr 2011 18:44:49 +0200
> Jean Delvare <khali@linux-fr.org> wrote:
> 
> > Hi Seth,
> > 
> > On Wed, 20 Apr 2011 11:33:39 -0700, Seth Heasley wrote:
> > > This patch adds the SMBus controller DeviceID for the Intel Panther Point PCH.
> > 
> > With each new chip, we have to add the SMBus device ID to pci_ids.h,
> > then wait for Jesse to merge that, and only then I can apply the
> > changes to i2c-i801.c. This approach slows things down needlessly.
> > 
> > It isn't mandatory to add IDs to pci_ids.h when an ID is only used
> > locally in a device driver. So what I would like to propose is that we
> > move all PCI_DEVICE_ID_INTEL_*_SMBUS declarations from pci_ids.h to
> > i2c-i801.c now. Then you can resubmit your Panther Point patches, and
> > the pci and i2c parts will be independent, so Jesse and myself don't
> > depend on each other to apply them.
> > 
> > What do you think? Jesse, any objection?
> > 
> > Seth, if you agree, I can take care of the move, or you can send a
> > patch doing that, whatever you prefer.
> 
> Yeah, that makes sense.  I'd be happy to take a patch to pull the
> defines out of pci_ids.h and push them into the x86 irq.c and your i2c
> code.

I really only had i2c in mind. For irq it's a little different because
it relates to devices which are kind of generic and the IDs could be
(and, I think, are) used in more than one place (such as quirks.c) for
at least some of these devices.

-- 
Jean Delvare
