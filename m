Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752983Ab1EIMkU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 08:40:20 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45465 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752142Ab1EIMkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 08:40:18 -0400
Date: Mon, 9 May 2011 14:40:23 +0200
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ashish Jangam <Ashish.Jangam@kpitcummins.com>
Cc: "sameo@openedhand.com" <sameo@openedhand.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dajun Chen <Dajun.Chen@diasemi.com>
Subject: Re: [PATCHv2 -next] MFD: MFD module of DA9052 PMIC driver
Message-ID: <20110509124022.GD3225@opensource.wolfsonmicro.com>
References: <E2CAE7F7B064EA49B5CE7EE9A4BB167D151BA5AFBA@KCINPUNHJCMS01.kpit.com>
 <20110503144441.GS1762@opensource.wolfsonmicro.com>
 <E2CAE7F7B064EA49B5CE7EE9A4BB167D151BB713DB@KCINPUNHJCMS01.kpit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E2CAE7F7B064EA49B5CE7EE9A4BB167D151BB713DB@KCINPUNHJCMS01.kpit.com>
X-Cookie: You will never know hunger.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 09, 2011 at 04:03:41PM +0530, Ashish Jangam wrote:

> > > +static void da9052_irq_sync_unlock(struct irq_data *data)
> > > +{
> > > +       struct da9052 *da9052 = irq_data_get_irq_chip_data(data);
> > > +       struct da9052_irq_data *irq_data = irq_to_da9052_irq(da9052,
> > > +                                               data->irq);
> > > +
> > > +       da9052_mask_events(da9052, irq_data->event);
> > > +       mutex_unlock(&da9052->irq_lock);

> > What happens if an event was enabled while the bus was locked?

Fix your MUA to word wrap within paragraphs.

> Event stays in the hardware till it's not explicitly cleared. Hence
> there won't be any event loss.

You're missing the point here.  You've not understood what the purpose
of the lock and unlock are - they should be syncing back changes to the
mask state that were made while the lock was held.  This is doing
something totally different.
