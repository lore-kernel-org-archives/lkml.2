Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753103Ab1EHUcj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 16:32:39 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52921 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810Ab1EHUci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 16:32:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=i0wXwPDPZLz5EnBwVZFPh0QTugQ+dykwvOj5w4gksLlsW1CjUsmmfLcQmR/eET1QTg
         ynBJGWfZ0tfpIGFKoNT0BuyPwz3t6UWtgwvKC1vt09CY78gQ3rp1ihTbEqCftT8exGvz
         MxeqaYOQXnBCsnXJFgUzqHgnUJxqCX5/MI4Os=
Subject: Re: [PATCH 1/4] MFD: TWL6025: add phoenix lite support to twl6030
From: Liam Girdwood <lrg@kernel.org>
To: balbi@ti.com
Cc: Graeme Gregory <gg@slimlogic.co.uk>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, sameo@linux.intel.com,
        broonie@opensource.wolfsonmicro.com
In-Reply-To: <20110427104001.GX13227@legolas.emea.dhcp.ti.com>
References: <1303897191-14792-1-git-send-email-gg@slimlogic.co.uk>
	 <1303897191-14792-2-git-send-email-gg@slimlogic.co.uk>
	 <20110427104001.GX13227@legolas.emea.dhcp.ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 08 May 2011 21:32:33 +0100
Message-ID: <1304886753.3246.22.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-27 at 13:40 +0300, Felipe Balbi wrote: 
> On Wed, Apr 27, 2011 at 10:39:48AM +0100, Graeme Gregory wrote:


> > +	/* TWL6025 LDO regulators */
> > +	struct regulator_init_data		*ldo1;
> > +	struct regulator_init_data		*ldo2;
> > +	struct regulator_init_data		*ldo3;
> > +	struct regulator_init_data		*ldo4;
> > +	struct regulator_init_data		*ldo5;
> > +	struct regulator_init_data		*ldo6;
> > +	struct regulator_init_data		*ldo7;
> > +	struct regulator_init_data		*ldoln;
> > +	struct regulator_init_data		*ldousb;
> > +	/* TWL6025 DCDC regulators */
> > +	struct regulator_init_data		*smps3;
> > +	struct regulator_init_data		*smps4;
> > +	struct regulator_init_data		*vio6025;
> 
> this is just becoming really really ugly. You need a more clever way of
> handling this. Maybe passing an array of regulators and the array size
> instead of continuously adding fields to this structure.
> 

Ok, I agree that optimising the platform data here is desirable, but I
think we will have to stick with this atm as the twl driver has some
rather annoying limitations that make optimising things like this a pita
atm.

I guess we should look at fixing the twl driver within TI in order to
make it more adaptable (i.e. support future twl ICs) and also a non
singleton device.

Liam

