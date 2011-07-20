Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692Ab1GTW5N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 18:57:13 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:3524 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102Ab1GTW5K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 18:57:10 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Wed, 20 Jul 2011 15:57:03 -0700
From: Andrew Chew <AChew@nvidia.com>
To: Andrew Chew <AChew@nvidia.com>,
        "'Grant Likely'" <grant.likely@secretlab.ca>
CC: "'olof@lixom.net'" <olof@lixom.net>, Stephen Warren <swarren@nvidia.com>,
        Dan Willemsen <dwillemsen@nvidia.com>,
        Rhyland Klein <rklein@nvidia.com>,
        Venkat Moganty <vmoganty@nvidia.com>,
        "'devicetree-discuss@lists.ozlabs.org'" 
	<devicetree-discuss@lists.ozlabs.org>,
        "'linux-tegra@vger.kernel.org'" <linux-tegra@vger.kernel.org>,
        "'linux-usb@vger.kernel.org'" <linux-usb@vger.kernel.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Date: Wed, 20 Jul 2011 15:57:03 -0700
Subject: RE: [PATCH 1/3 v2] usb: tegra20-ehci: Add devicetree support.
Thread-Topic: [PATCH 1/3 v2] usb: tegra20-ehci: Add devicetree support.
Thread-Index: AcxHF/dB+sbXVNoRSQiKUl6LNrkNkwAEu7sQAAE+6oA=
Message-ID: <643E69AA4436674C8F39DCC2C05F76383CF0DD227D@HQMAIL03.nvidia.com>
References: <1311190690-18334-1-git-send-email-achew@nvidia.com>
 <CACxGe6uDVdemjbjY_i-_M_-VT8HuLdtXP-R9V8kB+pSSin4dEw@mail.gmail.com>
 <643E69AA4436674C8F39DCC2C05F76383CF0DD2279@HQMAIL03.nvidia.com>
In-Reply-To: <643E69AA4436674C8F39DCC2C05F76383CF0DD2279@HQMAIL03.nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > +Required properties for type = "utmi".  These values are 
> > derived from
> > > +characterization by system engineering.
> > > + - hssync_start_delay
> > > + - idle_wait_delay
> > > + - elastic_limit
> > > + - term_range_adj
> > > + - xcvr_setup
> > > + - xcvr_lsfslew
> > > + - xcvr_lsrslew
> > 
> > All of these custom properties should be prefixed with "nvidia," to
> > avoid namespace collisions.
> 
> Are you saying we should prefix with "nvidia," on ALL of the 
> properties I've defined for the tegra20-ehci node?  Or 
> specifically those seven that you pointed out?  Because I 
> don't see a difference in terms of "custom"-ality between 
> say, hssync-start-delay, and the other stuff like phy-type, 
> mode, power-down-on-bus-suspend, and the reset-gpio and clk 
> from phy-type=ulpi...unless we're considering stuff like 
> phy-type to be a standard USB host controller node property.

Looking around for precedence, I see that fsl-usb.txt documents a phy-type as well as a dr-mode (though there's still underscores in that document...I assume they will be replaced by hyphens at some point).  So I think the tegra2 ehci host driver will mirror that, and use those property names, in which case I assume we don't have a vendor prefix on those.  Are "standard" usb host controller properties (those that shouldn't have a vendor prefix) documented anywhere?