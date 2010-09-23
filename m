Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355Ab0IWNVm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 09:21:42 -0400
Received: from mtagate1.de.ibm.com ([195.212.17.161]:60095 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753401Ab0IWNVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 09:21:41 -0400
Date: Thu, 23 Sep 2010 15:21:36 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ds2760_battery: add HAS_IOMEM dependency
Message-ID: <20100923152136.07195b3b@mschwide.boeblingen.de.ibm.com>
In-Reply-To: <20100923105727.GA22890@oksana.dev.rtsoft.ru>
References: <20100923124445.5309c100@mschwide.boeblingen.de.ibm.com>
	<20100923105727.GA22890@oksana.dev.rtsoft.ru>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Sep 2010 14:57:27 +0400
Anton Vorontsov <cbouatmailru@gmail.com> wrote:

> On Thu, Sep 23, 2010 at 12:44:45PM +0200, Martin Schwidefsky wrote:
> > From: Martin Schwidefsky <schwidefsky@de.ibm.com>
> > 
> > Fix this Kconfig warning on allmodconfig for s390:
> > 
> > warning: (BATTERY_DS2760 && POWER_SUPPLY) selects W1 which has unmet direct dependencies (HAS_IOMEM)
> > 
> > Cc: Anton Vorontsov <cbou@mail.ru>
> > Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
> > ---
> > 
> >  drivers/power/Kconfig |    1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff -urpN linux-2.6/drivers/power/Kconfig linux-2.6-patched/drivers/power/Kconfig
> > --- linux-2.6/drivers/power/Kconfig	2010-09-23 08:47:36.000000000 +0200
> > +++ linux-2.6-patched/drivers/power/Kconfig	2010-09-23 08:47:39.000000000 +0200
> > @@ -64,6 +64,7 @@ config TEST_POWER
> >  
> >  config BATTERY_DS2760
> >  	tristate "DS2760 battery driver (HP iPAQ & others)"
> > +	depends on HAS_IOMEM
> >  	select W1
> >  	select W1_SLAVE_DS2760
> 
> I think the better fix would be to turn this into 'depends on W1',
> and remove these selects.

That would work as well. Dunno what is better, W1 is a bus for a certain
class of devices. The bus is only needed if at least one driver that uses
it is configured. Which would argue for the select method but that has
the dependency problem. Anyway, either method is fine with me. If you
prefer the "depends on W1" lets do it that way.
--
[PATCH] ds2760_battery: fix W1 and W1_SLAVE_DS2760 dependency

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

Fix this Kconfig warning on allmodconfig for s390:

warning: (BATTERY_DS2760 && POWER_SUPPLY) selects W1 which has unmet direct dependencies (HAS_IOMEM)

Cc: Anton Vorontsov <cbou@mail.ru>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/power/Kconfig |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -urpN linux-2.6/drivers/power/Kconfig linux-2.6-patched/drivers/power/Kconfig
--- linux-2.6/drivers/power/Kconfig	2010-09-23 15:18:00.000000000 +0200
+++ linux-2.6-patched/drivers/power/Kconfig	2010-09-23 15:18:46.000000000 +0200
@@ -64,8 +64,7 @@ config TEST_POWER
 
 config BATTERY_DS2760
 	tristate "DS2760 battery driver (HP iPAQ & others)"
-	select W1
-	select W1_SLAVE_DS2760
+	depends on W1 && W1_SLAVE_DS2760
 	help
 	  Say Y here to enable support for batteries with ds2760 chip.
 

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

