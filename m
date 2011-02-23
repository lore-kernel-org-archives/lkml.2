Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932261Ab1BWSoK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 13:44:10 -0500
Received: from mail-yi0-f46.google.com ([209.85.218.46]:58826 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755440Ab1BWSoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 13:44:08 -0500
Date: Wed, 23 Feb 2011 11:44:03 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Rob Herring <robherring2@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        devicetree-discuss@lists.ozlabs.org, sfr@canb.auug.org.au,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        sparclinux@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [RFC PATCH 02/15] dt: add a match table pointer to struct
 device
Message-ID: <20110223184402.GM14597@angua.secretlab.ca>
References: <20110223043015.20795.37090.stgit@localhost6.localdomain6>
 <20110223043345.20795.2936.stgit@localhost6.localdomain6>
 <4D6551EF.70207@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D6551EF.70207@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 23, 2011 at 12:29:03PM -0600, Rob Herring wrote:
> Grant,
> 
> On 02/22/2011 10:33 PM, Grant Likely wrote:
> >Add a new .of_match field to struct device which points at the
> >matching device driver .of_match_table entry when a device is probed
> >via the device tree
> >
> >Signed-off-by: Grant Likely<grant.likely@secretlab.ca>
> >---
> >  include/linux/device.h    |    1 +
> >  include/linux/of_device.h |    5 +++--
> >  2 files changed, 4 insertions(+), 2 deletions(-)
> >
> >diff --git a/include/linux/device.h b/include/linux/device.h
> >index ca5d252..8d8e267 100644
> >--- a/include/linux/device.h
> >+++ b/include/linux/device.h
> >@@ -441,6 +441,7 @@ struct device {
> >  	struct dev_archdata	archdata;
> >
> >  	struct device_node	*of_node; /* associated device tree node */
> >+	const struct of_device_id *of_match; /* matching of_device_id from driver */
> 
> Couldn't of_match/of_match_table be merged into the platform dev/drv
> id_entry/id_table. Handling MODALIAS for a driver that does both OF
> style and normal platform device matching may be a problem though.

.of_match & .of_match_table works on all devices, not just
platform devices.  It allows the common library of device tree support
routines to be used with any bus type.

g.

