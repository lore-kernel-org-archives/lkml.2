Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752359Ab1G2QK4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 12:10:56 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:35839 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751636Ab1G2QKz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 12:10:55 -0400
Subject: Re: [PATCH 1/2 RESEND] regulator: aat2870: Fix the logic of
 checking if no id is matched in aat2870_get_regulator
From: Liam Girdwood <lrg@ti.com>
To: "axel.lin@gmail.com" <axel.lin@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jin Park <jinyoungp@nvidia.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>
In-Reply-To: <CAF+7xW=AXA9RgddR0HgFwWdRcy6v1hcDXc7Z7KXb1DTBuzH-Pg@mail.gmail.com>
References: <1309995504.2496.1.camel@phoenix>
	 <CAF+7xW=AXA9RgddR0HgFwWdRcy6v1hcDXc7Z7KXb1DTBuzH-Pg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 29 Jul 2011 17:10:47 +0100
Message-ID: <1311955847.2712.12.camel@CNA0741383>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-29 at 18:05 +0200, Axel Lin wrote:
> hi,
> Seems this 2 patches are not upstream. Should I resend it again?
> Regards,
> Axel

Not required atm thanks, this driver went via mfd so I can apply the fix
after the mfd merge or rc1.

Liam

> 
> 2011/7/7 Axel Lin <axel.lin@gmail.com>:
> > In current implementation, the pointer ri is not NULL if no id is matched.
> > Fix it by checking i == ARRAY_SIZE(aat2870_regulators) if no id is matched.
> >
> > Signed-off-by: Axel Lin <axel.lin@gmail.com>
> > Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> > ---
> >  drivers/regulator/aat2870-regulator.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> >
> > diff --git a/drivers/regulator/aat2870-regulator.c b/drivers/regulator/aat2870-regulator.c
> > index cd41045..11d1ab4 100644
> > --- a/drivers/regulator/aat2870-regulator.c
> > +++ b/drivers/regulator/aat2870-regulator.c
> > @@ -159,7 +159,7 @@ static struct aat2870_regulator *aat2870_get_regulator(int id)
> >                        break;
> >        }
> >
> > -       if (!ri)
> > +       if (i == ARRAY_SIZE(aat2870_regulators))
> >                return NULL;
> >
> >        ri->enable_addr = AAT2870_LDO_EN;
> > --
> > 1.7.4.1
> >
> >
> >
> >


