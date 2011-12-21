Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751981Ab1LUD1F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 22:27:05 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:4150 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750Ab1LUD1D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 22:27:03 -0500
X-SpamScore: -6
X-BigFish: VS-6(zz9371I542M1432Nzz1202hzz8275bh8275dhz2dh2a8h668h839h8e2h8e3h944hbe9n61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Dong Aisheng-B29396 <B29396@freescale.com>
To: Marek Vasut <marek.vasut@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "w.sang@pengutronix.de" <w.sang@pengutronix.de>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Guo Shawn-R65073 <r65073@freescale.com>
Subject: RE: [RFC PATCH v3 1/5] dt: add of_get_child_count helper function
Thread-Topic: [RFC PATCH v3 1/5] dt: add of_get_child_count helper function
Thread-Index: AQHMvzz5RapTRp5ozEOP+dD9oHyS7ZXlhm4AgAAaVcA=
Date: Wed, 21 Dec 2011 03:27:01 +0000
Message-ID: <7FE21149F4667147B645348EC605788505C544@039-SN2MPN1-013.039d.mgd.msft.net>
References: <1324402840-32451-1-git-send-email-b29396@freescale.com>
 <1324402840-32451-2-git-send-email-b29396@freescale.com>
 <201112202047.10308.marek.vasut@gmail.com>
In-Reply-To: <201112202047.10308.marek.vasut@gmail.com>
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
> From: Marek Vasut [mailto:marek.vasut@gmail.com]
> Sent: Wednesday, December 21, 2011 3:47 AM
> To: linux-arm-kernel@lists.infradead.org
> Cc: Dong Aisheng-B29396; linux-kernel@vger.kernel.org;
> linus.walleij@stericsson.com; s.hauer@pengutronix.de; w.sang@pengutronix.de;
> rob.herring@calxeda.com; grant.likely@secretlab.ca; kernel@pengutronix.de;
> cjb@laptop.org; devicetree-discuss@lists.ozlabs.org; Guo Shawn-R65073
> Subject: Re: [RFC PATCH v3 1/5] dt: add of_get_child_count helper function
> Importance: High
> 
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
> > ---
> >  include/linux/of.h |   16 ++++++++++++++++
> >  1 files changed, 16 insertions(+), 0 deletions(-)
> >
> > diff --git a/include/linux/of.h b/include/linux/of.h index
> > 4948552..d0d91a1 100644
> > --- a/include/linux/of.h
> > +++ b/include/linux/of.h
> > @@ -189,6 +189,17 @@ extern struct device_node
> > *of_get_next_child(const struct device_node *node, for (child =
> > of_get_next_child(parent, NULL); child != NULL; \
> >  	     child = of_get_next_child(parent, child))
> >
> > +static inline int of_get_child_count(const struct device_node *np) {
> > +	struct device_node *child = NULL;
> > +	int num = 0;
> > +
> > +	while ((child = of_get_next_child(np, child)))
> 
> The assignment in this condition really looks eerie, maybe just rewrite it to do
> { } while () ? Also, aren't the parenthesis unnecessary?
> 
Yes, one more parenthesis. I will remove it. Thanks.
For the condition, it's a little trick but I guess for a helper function
it's ok right? And there're already many places using like this.

Regards
Dong Aisheng

> M
> > +		num++;
> > +
> > +	return num;
> > +}
> > +
> >  extern struct device_node *of_find_node_with_property(
> >  	struct device_node *from, const char *prop_name);
> >  #define for_each_node_with_property(dn, prop_name) \
> > @@ -262,6 +273,11 @@ static inline bool of_have_populated_dt(void)
> >  #define for_each_child_of_node(parent, child) \
> >  	while (0)
> >
> > +static inline int of_get_child_count(const struct device_node *np)
> > +{
> > +	return -ENOSYS;
> > +}
> > +
> >  static inline int of_device_is_compatible(const struct device_node
> > *device, const char *name)
> >  {


