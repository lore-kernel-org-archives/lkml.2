Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593Ab2DSHk0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 03:40:26 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53359 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838Ab2DSHkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 03:40:22 -0400
Date: Thu, 19 Apr 2012 08:40:18 +0100
From: Andy Whitcroft <apw@canonical.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: KY Srinivasan <kys@microsoft.com>, Jeff Garzik <jgarzik@pobox.com>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mike Sterling <mike.sterling@microsoft.com>
Subject: Re: [PATCH 0/2] Hyper-V disk support V3
Message-ID: <20120419074018.GA3342@shadowen.org>
References: <20120414170223.24f6ea31@pyramind.ukuu.org.uk>
 <1334575229-7493-1-git-send-email-apw@canonical.com>
 <20120416122634.7d1357e1@ultron>
 <20120416182927.GB3346@shadowen.org>
 <426367E2313C2449837CD2DE46E7EAF92CE0B5@CH1PRD0310MB381.namprd03.prod.outlook.com>
 <20120418211235.55b9befc@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120418211235.55b9befc@pyramind.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2012 at 09:12:35PM +0100, Alan Cox wrote:
> > The notion of "pass through" in Hyper-V  is a little different. IDE devices can be configured
> > under either one of the supported controllers and these devices can either be virtual disks
> > (VHDs) or physical disks. In either case these will be presented to the guest as IDE devices.
> 
> So what ensures that by skipping it at the ATA device level we will
> always find it as a VHD ?

My understanding of things is that the if you have disks assigned to the
guest that they will always appear both on the virtualised SATA contoller
and on the paravirtualised driver channel.  So that assuming a valid
configuration in which both drivers initialise they will be picked up by
one or the other.

KY for clarity are we saying the only way a disk can appear in the guest
is either on the emulated controller or paravirtualised, we will never
expose real devices into the guest.

Reading my own statement that ought to imply we really should only default
preferring paravirtualised to 'on' when the hyperv paravirtualised drivers
is enabled too; easy enough to do.  Howeever in a perfect world the
override would also have the inverse effect even if the paravirtualised
driver initialises first; not so easy but I assume we with some fiddling
we could make both drivers handle the same parameter.

/me considers this further.

-apw
