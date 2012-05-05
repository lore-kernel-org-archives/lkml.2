Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758804Ab2EEChq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 22:37:46 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:50265 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432Ab2EEChp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 22:37:45 -0400
Date: Fri, 4 May 2012 19:36:22 -0700
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] max17042_battery: fix driver exit function
Message-ID: <20120505023620.GB812@lizard>
References: <1332756506-6905-1-git-send-email-ramakrishna.pallala@intel.com>
 <D854C92F57B1B347B57E531E78D05EAD1071B1@BGSMSX102.gar.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <D854C92F57B1B347B57E531E78D05EAD1071B1@BGSMSX102.gar.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Ramakrishna,

On Tue, Apr 10, 2012 at 05:20:33AM +0000, Pallala, Ramakrishna wrote:
[...]
> >  	power_supply_unregister(&chip->battery);
> > +	if (client->irq)
> > +		free_irq(client->irq, chip);
> > +	i2c_set_clientdata(client, NULL);
> > +
> >  	return 0;
> >  }
> 
> I have not received any comments for this patch.
> Can I assume that this patch is in your merge queue?

Applied, but I removed i2c_set_clientdata(client, NULL) line in this
patch. It is not be required nowadays, I2C core does it by itself.

Plus, I changed the order of the calls: we should free irq first, then
unregister the power supply (btw, you might want to fix probe function
as well: it should request irq only after power supply object is
fully usable).

Thanks!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
