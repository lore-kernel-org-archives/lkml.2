Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190Ab1LUDCU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 22:02:20 -0500
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:52515
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752228Ab1LUDCS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 22:02:18 -0500
X-SpamScore: -10
X-BigFish: VS-10(zzbb2dI9371I542M1432N98dKzz1202hzz8275bh8275dhz2dh2a8h668h839h8e2h8e3h944hbe9n)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-SS: 13,
From: Dong Aisheng-B29396 <B29396@freescale.com>
To: Rob Herring <robherring2@gmail.com>
CC: "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        Guo Shawn-R65073 <r65073@freescale.com>
Subject: RE: [PATCH 1/1] dt: reform for_each_property to
 for_each_property_of_node_of_node
Thread-Topic: [PATCH 1/1] dt: reform for_each_property to
 for_each_property_of_node_of_node
Thread-Index: AQHMvz7Gx2MpfI1h6Emg3bcFsOL3sZXldmgAgAAj1CA=
Date: Wed, 21 Dec 2011 03:02:15 +0000
Message-ID: <7FE21149F4667147B645348EC605788505C4B3@039-SN2MPN1-013.039d.mgd.msft.net>
References: <1324403518-3462-1-git-send-email-b29396@freescale.com>
 <4EF0D8D0.1020505@gmail.com>
In-Reply-To: <4EF0D8D0.1020505@gmail.com>
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
> From: Rob Herring [mailto:robherring2@gmail.com]
> Sent: Wednesday, December 21, 2011 2:50 AM
> To: Dong Aisheng-B29396
> Cc: devicetree-discuss@lists.ozlabs.org; linux-kernel@vger.kernel.org; linux-
> arm-kernel@lists.infradead.org; grant.likely@secretlab.ca; Guo Shawn-R65073
> Subject: Re: [PATCH 1/1] dt: reform for_each_property to
> for_each_property_of_node_of_node
> Importance: High
> 
> 
> On 12/20/2011 11:51 AM, Dong Aisheng wrote:
> > From: Dong Aisheng <dong.aisheng@linaro.org>
> >
> > Make this micro more easy to use(do not need to pass properties, a
> > node is
> 
> Make this macro easier to use...
> 
Acked.

> > enough), also change to a more sensible name as for_each_child_of_node.
> >
> > Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
> > Cc: Grant Likely <grant.likely@secretlab.ca>
> > Cc: Rob Herring <rob.herring@calxeda.com>
> > Cc: Shawn Guo <shawn.guo@freescale.com>
> > ---
> >  drivers/of/base.c  |    2 +-
> >  include/linux/of.h |    4 ++--
> >  2 files changed, 3 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/of/base.c b/drivers/of/base.c index
> > 9b6588e..f6f6fe8 100644
> > --- a/drivers/of/base.c
> > +++ b/drivers/of/base.c
> > @@ -1159,7 +1159,7 @@ void of_alias_scan(void * (*dt_alloc)(u64 size, u64
> align))
> >  	if (!of_aliases)
> >  		return;
> >
> > -	for_each_property(pp, of_aliases->properties) {
> > +	for_each_property_of_node(of_aliases, pp) {
> >  		const char *start = pp->name;
> >  		const char *end = start + strlen(start);
> >  		struct device_node *np;
> > diff --git a/include/linux/of.h b/include/linux/of.h index
> > 4948552..f1a490c 100644
> > --- a/include/linux/of.h
> > +++ b/include/linux/of.h
> > @@ -219,8 +219,8 @@ extern int of_device_is_available(const struct
> > device_node *device);  extern const void *of_get_property(const struct
> device_node *node,
> >  				const char *name,
> >  				int *lenp);
> > -#define for_each_property(pp, properties) \
> > -	for (pp = properties; pp != NULL; pp = pp->next)
> > +#define for_each_property_of_node(dn, pp) \
> > +	for (pp = dn->properties; pp != NULL; pp = pp->next)
> 
> Probably should prepend it with "of_" while you're at it.
> 
I agree.
But it seems other help microes also do not with a "of_" prefix
Like for_each_child_of_node.
So I just follow the old convention.
Do you think I need to change this one firstly?

Regards
Dong Aisheng

