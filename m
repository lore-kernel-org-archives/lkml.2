Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932233Ab1JMQv4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 12:51:56 -0400
Received: from utopia.booyaka.com ([72.9.107.138]:53561 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753572Ab1JMQvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 12:51:55 -0400
Date: Thu, 13 Oct 2011 10:51:54 -0600 (MDT)
From: Paul Walmsley <paul@pwsan.com>
To: "Cousson, Benoit" <b-cousson@ti.com>
cc: "Kristo, Tero" <t-kristo@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCHv9 03/18] TEMP: OMAP3xxx: hwmod data: add PRM hwmod
In-Reply-To: <alpine.DEB.2.00.1110131033410.24155@utopia.booyaka.com>
Message-ID: <alpine.DEB.2.00.1110131047110.24155@utopia.booyaka.com>
References: <1316781986-30642-1-git-send-email-t-kristo@ti.com> <1316781986-30642-4-git-send-email-t-kristo@ti.com> <alpine.DEB.2.00.1110101320180.5205@utopia.booyaka.com> <4E934D79.4080000@ti.com> <alpine.DEB.2.00.1110101416530.5205@utopia.booyaka.com>
 <4E936F0E.9050203@ti.com> <alpine.DEB.2.00.1110101725140.5205@utopia.booyaka.com> <4E954CDA.10107@ti.com> <alpine.DEB.2.00.1110131033410.24155@utopia.booyaka.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Oct 2011, Paul Walmsley wrote:

> On Wed, 12 Oct 2011, Cousson, Benoit wrote:
> 
> > On 10/11/2011 1:26 AM, Paul Walmsley wrote:
> > > On Tue, 11 Oct 2011, Cousson, Benoit wrote:
> > > 
> > > > In fact the device name does not have to match the hwmod name. So we 
> > > > can just create an "omap2_prm" omap_device for OMAP2, "omap3_prm" 
> > > > omap_device for OMAP3... That will allow the relevant PRM driver to 
> > > > be bound to the proper device.
> > > 
> > > Incidentally, given that we would be using the hwmod name and the version
> > > number to determine the appropriate omap_device name, what IP version
> > > numbers should we assign to these PRM IP blocks for different SoCs?
> > 
> > It can just be 1, 2 and 3... The idea is just to differentiate the IP for each
> > OMAP.
> 
> So those are basically arbitrary?  Something is not clear here.
> 
> In the current hwmod design, IP blocks with different interfaces were 
> intended to be uniquely identified by the hwmod name alone.  That is why 
> omap_hwmod_lookup() only takes a 'name' parameter.
> 
> If I understand what you want to do, you wish to change this to uniquely 
> identify them by a (name, interface version number) tuple.
> 
> I don't have a problem with this in theory, but it implies some changes to 
> the existing model.  Specifically:
> 
> - we'll need to add an interface version number to the struct omap_hwmod
> 
> - we'll need to modify omap_hwmod_lookup() to take an interface version 
> number
> 
> - the "ti,hwmod" DT binding that you proposed earlier will need to include 
> an interface version number

Hmm, reflecting on this further, is your intention to bind drivers to 
hwmods by the struct omap_hwmod_class instead?

If we define that "rev" field as the interface version number, that should 
probably work.

So then in C struct format, in a platform_device system, the mapping table 
would basically become

struct omap_hwmod_driver_map {
	const char *class_name;
	const u32 class_rev;
	const char *platform_device_name;
}

- Paul
