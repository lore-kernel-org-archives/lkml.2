Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758860Ab2AFRXl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 12:23:41 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:6392 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752395Ab2AFRXk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 12:23:40 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Fri, 06 Jan 2012 09:23:36 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Dong Aisheng-B29396 <B29396@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Date: Fri, 6 Jan 2012 09:23:35 -0800
Subject: RE: [RFC PATCH v3 2/5] pinctrl: add dt binding support for pinmux
 mappings
Thread-Topic: [RFC PATCH v3 2/5] pinctrl: add dt binding support for pinmux
 mappings
Thread-Index: AQHMvzz/OIptPg50WkeChzdBCJw49JXl2BOAgAA9DlCABdN5oIAB+HxAgBCkJsCAALzAkIAAbm5g
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF177EE39E40@HQMAIL01.nvidia.com>
References: <1324402840-32451-1-git-send-email-b29396@freescale.com>
 <1324402840-32451-3-git-send-email-b29396@freescale.com>
 <74CDBE0F657A3D45AFBB94109FB122FF176BE92F00@HQMAIL01.nvidia.com>
 <7FE21149F4667147B645348EC6057885075542@039-SN2MPN1-013.039d.mgd.msft.net>
 <74CDBE0F657A3D45AFBB94109FB122FF176CC743EF@HQMAIL01.nvidia.com>
 <7FE21149F4667147B645348EC6057885077F82@039-SN2MPN1-013.039d.mgd.msft.net>
 <74CDBE0F657A3D45AFBB94109FB122FF17761F1887@HQMAIL01.nvidia.com>
 <7FE21149F4667147B645348EC605788507F615@039-SN2MPN1-013.039d.mgd.msft.net>
In-Reply-To: <7FE21149F4667147B645348EC605788507F615@039-SN2MPN1-013.039d.mgd.msft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dong Aisheng-B29396 wrote at Friday, January 06, 2012 3:51 AM:
> Stephen Warren wrote at Friday, January 06, 2012 7:38 AM:
> > Dong Aisheng-B29396 wrote at Tuesday, December 27, 2011 7:41 AM:
...
> > > But what about the pin maps without device associated?
> >
> > Indeed; that's why I'd tend towards defining a table of pinmux usage in the
> > pinmux node, and having other devices refer to that table.
>
> Currently we still prefer to use device node relationship to reflect the pinmux
> map if we can since as you said pinmux map is little depending on the pinctrl
> subsystem implementation.
> And I'm trying to do it now.
> 
> > Still, if the pinmux definitions are in the device nodes, we could simply make
> > the pinmux controller have such a definition itself too, for the "system hog"
> > case.
>
> Yes, that way I think is like:
> iomuxc@020e0000 {
>         pinctrl_uart4: uart4 {
>                 grp-pins = <107 108>;
>                 grp-mux = <4 4>;
> 		   hog_on_boot;
>         };
> }

If pinmux usage is defined in each individual device node, and the "hog"
setup is included in the pinmux controller's own device node, then there's
no need for a "hog_on_boot" property; any pinmux setup node that's inside
the pinmux controller node would automatically be a "hog" entry, and
could be activated as soon as the pinmux controller was probed and
registered with the pinctrl subsystem.

(as a minor nit, DT usually uses - not _ in property names, so that would
be "hog-on-boot").

-- 
nvpublic

