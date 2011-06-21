Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757010Ab1FUQXk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 12:23:40 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:33763 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756881Ab1FUQXg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 12:23:36 -0400
Date: Tue, 21 Jun 2011 09:23:21 -0700
From: Ram Pai <linuxram@us.ibm.com>
To: Dominik Brodowski <linux@dominikbrodowski.net>,
        Ram Pai <linuxram@us.ibm.com>, jbarnes@virtuousgeek.org,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        svenkatr@ti.com, yinghai@kernel.org, cjb@laptop.org,
        linux-pci@vger.kernel.org, linux-net-drivers@solarflare.com,
        bhutchings@solarflare.com
Subject: Re: [PATCH 4/4] PCI: make cardbus-bridge resources nice-to-have
Message-ID: <20110621162321.GB22917@ram-laptop>
Reply-To: Ram Pai <linuxram@us.ibm.com>
References: <1308610037-6261-1-git-send-email-linuxram@us.ibm.com>
 <1308610037-6261-5-git-send-email-linuxram@us.ibm.com>
 <20110621075659.GA4620@comet.dominikbrodowski.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110621075659.GA4620@comet.dominikbrodowski.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 21, 2011 at 09:57:00AM +0200, Dominik Brodowski wrote:
> On Mon, Jun 20, 2011 at 03:47:17PM -0700, Ram Pai wrote:
> > Allocate resources to cardbus bridge only after all other genuine
> > resources requests are satisfied. Dont retry if resource allocation
> > for cardbus-bridge fails.
> 
> Well, for those who use cardbus cards, cardbus resources aren't "nice to
> have", they are absolutely required. Of course, not all cardbus cards need
> as many resources as are currently assigned, so I wouldn't oppose a patch
> which marks _some_ of the currently assigned resources as "nice to have".
> But this approach -- 0 required, all "nice to have" -- seems wrong to me.

Do you know how much minimal resource is good enough?  The value, before
this patch, was 256 for IO ports and  64M for memory.

BTW: If the BIOS has already assigned enough resources for all the devices on
the system, no devices will be starved including the cardbus. The OS intervenes
and is forced to make this hard choice only when it sees unassigned resources to
some devices along with resource contention.

RP
