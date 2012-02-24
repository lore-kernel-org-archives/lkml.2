Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756325Ab2BXIdv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 03:33:51 -0500
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:26189
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756272Ab2BXIdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 03:33:41 -0500
X-SpamScore: -10
X-BigFish: VS-10(zz9371I1432N98dKzz1202hzzz2dh2a8h668h839h944h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Fri, 24 Feb 2012 16:40:39 +0800
From: Dong Aisheng <aisheng.dong@freescale.com>
To: Stephen Warren <swarren@nvidia.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        "B29396@freescale.com" <B29396@freescale.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "dongas86@gmail.com" <dongas86@gmail.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "thomas.abraham@linaro.org" <thomas.abraham@linaro.org>,
        "tony@atomide.com" <tony@atomide.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 08/20] pinctrl: Assume map table entries can't have a
 NULL name field
Message-ID: <20120224084038.GF25789@shlinux2.ap.freescale.net>
References: <CACRpkdYK1epBfxPCu+cc3Edmd_9aZf4nvNyBx8O0sns5V+gNWw@mail.gmail.com>
 <74CDBE0F657A3D45AFBB94109FB122FF17BD8BC323@HQMAIL01.nvidia.com>
 <20120222063440.GB11087@shlinux2.ap.freescale.net>
 <74CDBE0F657A3D45AFBB94109FB122FF17BD8BC6A9@HQMAIL01.nvidia.com>
 <20120223033510.GA9141@shlinux2.ap.freescale.net>
 <74CDBE0F657A3D45AFBB94109FB122FF17BD8BC8E3@HQMAIL01.nvidia.com>
 <20120223035640.GC9141@shlinux2.ap.freescale.net>
 <74CDBE0F657A3D45AFBB94109FB122FF17BD8BC8EE@HQMAIL01.nvidia.com>
 <20120223044825.GD9141@shlinux2.ap.freescale.net>
 <74CDBE0F657A3D45AFBB94109FB122FF17BD8BC96D@HQMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF17BD8BC96D@HQMAIL01.nvidia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 23, 2012 at 08:39:58AM -0800, Stephen Warren wrote:
> Dong Aisheng wrote at Wednesday, February 22, 2012 9:48 PM:
> > On Wed, Feb 22, 2012 at 07:53:44PM -0800, Stephen Warren wrote:
> ...
> > > I'm hoping that we don't do this internal conversion. The rules I'd like are:
> ...
> > > * Every mapping table entry must include a non-NULL name field.
> > >
> > > * Every call to pinctrl_get()/pinctrl_lookup_state() must pass a non-NULL name
> >
> > This is a way.
> > 
> > Before using this, i'm  still wondering what big problems do you think for us to support
> > a NULL map name?
> > Because the name for devices do not have different state really does not make too much
> > sense but extra overhead.
> 
> If we disallow NULL names, it simplifies the code in the pinctrl core;
> when registering mappings or right at the start of pinctrl_get() or
> pinctrl_lookup_state(), we check if the name is NULL and if so error out.
> Everywhere else can then assume name!=NULL, and hence not have special-
> cases for name==NULL, e.g.:
> 
> In debug code:
> name ? name : "(unnamed)"
> vs.:
> name
> 
> When matching mapping table entries:
> match = !name ? !map->name : !strcmp(name, map->name)
> vs.:
> match = !strcmp(name, map->name)
> 
> Similar for the body of pinctrl_lookup_state().
> 
Yes, it does make thing simple.
But i guess it's not the key point to not support NULL state name, right?

> Equally, it's not possible to generate a mapping table entry with a NULL
> name from device tree given the bindings we discussed, so disallowing them
> everywhere keeps things consistent.
> 
Yes, i'm wondering if we can change it a bit to support NULL name.
I replied with my idea in another mail before this one.

Regards
Dong Aisheng

