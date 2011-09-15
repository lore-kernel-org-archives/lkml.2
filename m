Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752104Ab1IOA10 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 20:27:26 -0400
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:38881 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751095Ab1IOA1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 20:27:22 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/qAx/J9RTxqVsyl9k8yXxV
Date: Wed, 14 Sep 2011 17:27:19 -0700
From: Tony Lindgren <tony@atomide.com>
To: "Koyamangalath, Abhilash" <abhilash.kv@ti.com>
Cc: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] OMAP3: powerdomains: Match silicon revision to
 select the correct "core_pwrdm" definition
Message-ID: <20110915002719.GB30941@atomide.com>
References: <1310730250-10920-1-git-send-email-abhilash.kv@ti.com>
 <FCCFB4CDC6E5564B9182F639FC3560870370A4D985@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <FCCFB4CDC6E5564B9182F639FC3560870370A4D985@dbde02.ent.ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Koyamangalath, Abhilash <abhilash.kv@ti.com> [110812 00:12]:
> Hi 
> 
> > @@ -58,6 +59,24 @@ static struct powerdomain *_pwrdm_lookup(const char *name)
> > 
> >         list_for_each_entry(temp_pwrdm, &pwrdm_list, node) {
> >                 if (!strcmp(name, temp_pwrdm->name)) {
> > +                       if (!strcmp(name, "core_pwrdm") && cpu_is_omap3630()) {
> > +                               if (omap_rev() > OMAP3630_REV_ES1_0) {
> > +                                       /*
> > +                                        * match omap_chip info for OMAP3630
> > +                                        * Rev ES1.1, ES1.2 or higher
> > +                                        */
> > +                                       if (!(temp_pwrdm->omap_chip.oc
> > +                                               & CHIP_GE_OMAP3630ES1_1))
> > +                                               continue;
> > +                               } else {
> > +                                       /* match omap_chip info for OMAP3630
> > +                                        * Rev ES1.0
> > +                                        */
> > +                                       if (!(temp_pwrdm->omap_chip.oc
> > +                                                & CHIP_IS_OMAP3630ES1))
> > +                                               continue;
> > +                               }
> > +                       }
> >                         pwrdm = temp_pwrdm;
> >                         break;
> >                 }
>
> Any comments ?

Can you please check if this is still needed after Paul's
CHIP_IS removal patches? You can find them at:

git://git.pwsan.com/linux-2.6 omap_chip_remove_cleanup_3.2

Regards,

Tony
