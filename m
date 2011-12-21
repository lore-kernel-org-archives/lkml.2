Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858Ab1LUC4e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 21:56:34 -0500
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:51186
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752270Ab1LUC4b convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 21:56:31 -0500
X-SpamScore: -15
X-BigFish: VS-15(zzbb2dI9371I1447M542M1432N98dKzz1202hzz8275bh8275dhz2dh2a8h668h839h8e2h8e3h944hbe9n)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Dong Aisheng-B29396 <B29396@freescale.com>
To: Rob Herring <robherring2@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        Guo Shawn-R65073 <r65073@freescale.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "w.sang@pengutronix.de" <w.sang@pengutronix.de>
Subject: RE: [RFC PATCH v3 1/5] dt: add of_get_child_count helper function
Thread-Topic: [RFC PATCH v3 1/5] dt: add of_get_child_count helper function
Thread-Index: AQHMvzz5RapTRp5ozEOP+dD9oHyS7ZXlckYAgAAnLcA=
Date: Wed, 21 Dec 2011 02:56:26 +0000
Message-ID: <7FE21149F4667147B645348EC605788505C474@039-SN2MPN1-013.039d.mgd.msft.net>
References: <1324402840-32451-1-git-send-email-b29396@freescale.com>
 <1324402840-32451-2-git-send-email-b29396@freescale.com>
 <4EF0D556.3030701@gmail.com>
In-Reply-To: <4EF0D556.3030701@gmail.com>
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
> Sent: Wednesday, December 21, 2011 2:35 AM
> To: Dong Aisheng-B29396
> Cc: linux-kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org;
> linus.walleij@stericsson.com; s.hauer@pengutronix.de; Guo Shawn-R65073;
> kernel@pengutronix.de; grant.likely@secretlab.ca; devicetree-
> discuss@lists.ozlabs.org; cjb@laptop.org; w.sang@pengutronix.de
> Subject: Re: [RFC PATCH v3 1/5] dt: add of_get_child_count helper function
> Importance: High
> 
> On 12/20/2011 11:40 AM, Dong Aisheng wrote:
> > From: Dong Aisheng <dong.aisheng@linaro.org>
> >
> > Currently most code to get child count in kernel are almost same, add
> > a helper to implement this function for dt to use.
> >
> > ---
> > Changes v1->v2:
> >  * change the name from of_get_child_number to of_get_child_count
> >
> > Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
> > Cc: Grant Likely <grant.likely@secretlab.ca>
> > Cc: Rob Herring <rob.herring@calxeda.com>
> 
> I assume you want this to go in with the rest of the series? If not, let me know.
> 
> Acked-by: Rob Herring <rob.herring@calxeda.com>
> 
> Rob
>
Yes, since other patches in this series depend on this patch.
Thanks for the review.

Regards
Dong Aisheng 
> > ---
> >  include/linux/of.h |   16 ++++++++++++++++
> >  1 files changed, 16 insertions(+), 0 deletions(-)
> >
> > diff --git a/include/linux/of.h b/include/linux/of.h index
> > 4948552..d0d91a1 100644
> > --- a/include/linux/of.h
> > +++ b/include/linux/of.h
> > @@ -189,6 +189,17 @@ extern struct device_node *of_get_next_child(const struct
> device_node *node,
> >  	for (child = of_get_next_child(parent, NULL); child != NULL; \
> >  	     child = of_get_next_child(parent, child))
> >
> > +static inline int of_get_child_count(const struct device_node *np) {
> > +	struct device_node *child = NULL;
> > +	int num = 0;
> > +
> > +	while ((child = of_get_next_child(np, child)))
> > +		num++;
> > +
> > +	return num;
> > +}
> > +
> >  extern struct device_node *of_find_node_with_property(
> >  	struct device_node *from, const char *prop_name);  #define
> > for_each_node_with_property(dn, prop_name) \ @@ -262,6 +273,11 @@
> > static inline bool of_have_populated_dt(void)  #define
> > for_each_child_of_node(parent, child) \
> >  	while (0)
> >
> > +static inline int of_get_child_count(const struct device_node *np) {
> > +	return -ENOSYS;
> > +}
> > +
> >  static inline int of_device_is_compatible(const struct device_node *device,
> >  					  const char *name)
> >  {


