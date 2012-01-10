Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756127Ab2AJHCm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 02:02:42 -0500
Received: from va3ehsobe010.messaging.microsoft.com ([216.32.180.30]:27511
	"EHLO VA3EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756107Ab2AJHCj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 02:02:39 -0500
X-SpamScore: -9
X-BigFish: VS-9(zz9371I542M1432Nzz1202hzz8275dhz2dhc1ahc1bh2a8h668h839h8e2h8e3h944hbe9k61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Dong Aisheng-B29396 <B29396@freescale.com>
To: Stephen Warren <swarren@nvidia.com>,
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
Subject: RE: [RFC PATCH v3 2/5] pinctrl: add dt binding support for pinmux
 mappings
Thread-Topic: [RFC PATCH v3 2/5] pinctrl: add dt binding support for pinmux
 mappings
Thread-Index: AQHMvzz/OIptPg50WkeChzdBCJw49JXl2BOAgAA9DlCABdN5oIAB+HxAgBCkJsCAALzAkIAAbm5ggAWZ2SA=
Date: Tue, 10 Jan 2012 07:02:24 +0000
Message-ID: <7FE21149F4667147B645348EC605788508AB04@039-SN2MPN1-013.039d.mgd.msft.net>
References: <1324402840-32451-1-git-send-email-b29396@freescale.com>
 <1324402840-32451-3-git-send-email-b29396@freescale.com>
 <74CDBE0F657A3D45AFBB94109FB122FF176BE92F00@HQMAIL01.nvidia.com>
 <7FE21149F4667147B645348EC6057885075542@039-SN2MPN1-013.039d.mgd.msft.net>
 <74CDBE0F657A3D45AFBB94109FB122FF176CC743EF@HQMAIL01.nvidia.com>
 <7FE21149F4667147B645348EC6057885077F82@039-SN2MPN1-013.039d.mgd.msft.net>
 <74CDBE0F657A3D45AFBB94109FB122FF17761F1887@HQMAIL01.nvidia.com>
 <7FE21149F4667147B645348EC605788507F615@039-SN2MPN1-013.039d.mgd.msft.net>
 <74CDBE0F657A3D45AFBB94109FB122FF177EE39E40@HQMAIL01.nvidia.com>
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF177EE39E40@HQMAIL01.nvidia.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.192.242.198]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Stephen Warren [mailto:swarren@nvidia.com]
> Sent: Saturday, January 07, 2012 1:24 AM
> To: Dong Aisheng-B29396; linux-kernel@vger.kernel.org
> Cc: linus.walleij@stericsson.com; s.hauer@pengutronix.de;
> rob.herring@calxeda.com; linux-arm-kernel@lists.infradead.org;
> kernel@pengutronix.de; cjb@laptop.org; devicetree-discuss@lists.ozlabs.org
> Subject: RE: [RFC PATCH v3 2/5] pinctrl: add dt binding support for pinmux
> mappings
> Importance: High
> 
> Dong Aisheng-B29396 wrote at Friday, January 06, 2012 3:51 AM:
> > Stephen Warren wrote at Friday, January 06, 2012 7:38 AM:
> > > Dong Aisheng-B29396 wrote at Tuesday, December 27, 2011 7:41 AM:
> ...
> > > > But what about the pin maps without device associated?
> > >
> > > Indeed; that's why I'd tend towards defining a table of pinmux usage
> > > in the pinmux node, and having other devices refer to that table.
> >
> > Currently we still prefer to use device node relationship to reflect
> > the pinmux map if we can since as you said pinmux map is little
> > depending on the pinctrl subsystem implementation.
> > And I'm trying to do it now.
> >
> > > Still, if the pinmux definitions are in the device nodes, we could
> > > simply make the pinmux controller have such a definition itself too, for the
> "system hog"
> > > case.
> >
> > Yes, that way I think is like:
> > iomuxc@020e0000 {
> >         pinctrl_uart4: uart4 {
> >                 grp-pins = <107 108>;
> >                 grp-mux = <4 4>;
> > 		   hog_on_boot;
> >         };
> > }
> 
> If pinmux usage is defined in each individual device node,
Per my understanding a phandle to the pinmux usage defined in iomuxc node
Is also ok.
The next, you also pointed out before, we need to find a at least semi-standardized
per-device "pinmux" property which is suitable for all platforms.

> and the "hog"
> setup is included in the pinmux controller's own device node, then there's no
> need for a "hog_on_boot" property; any pinmux setup node that's inside the
> pinmux controller node would automatically be a "hog" entry, and could be
> activated as soon as the pinmux controller was probed and registered with the
> pinctrl subsystem.
> 
+1
I think this is a right solution for dt without a pinmux map.

> (as a minor nit, DT usually uses - not _ in property names, so that would be
> "hog-on-boot").
> 
> --
> nvpublic
> 


