Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015Ab0KBKdq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 06:33:46 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36658 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642Ab0KBKdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 06:33:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Z5D3dyHnCyOv+kjlCTGc1XQmAvRNf/vvXBiP9MIjkLBfWSJCUKuFrmFbR3+MgOA5EL
         oK+iKYvEQUWSkXh6TeKfoxEeLaSS2g/opXf/AaEmzWjYP46NJnMXC/aoQJ1C1yk/gyPk
         HwFVKagsk0Uf0DxkrJ+6+EKpMyLk+v1aATeTk=
Subject: Re: [PATCH] mxcmmc: Add the ability to bind a regulator to manage
 the MMC card voltage
From: Alberto Panizzo <maramaopercheseimorto@gmail.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Daniel Mack <daniel@caiaq.de>, Andrew Morton <akpm@linux-foundation.org>,
        Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Eric =?ISO-8859-1?Q?B=E9nard?= <eric@eukrea.com>,
        Fabio Estevam <fabioestevam@yahoo.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>
In-Reply-To: <20101102073932.GB6017@pengutronix.de>
References: <1288656337.29881.13.camel@realization>
	 <20101102073932.GB6017@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 02 Nov 2010 11:33:36 +0100
Message-ID: <1288694016.2940.8.camel@realization>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On mar, 2010-11-02 at 08:39 +0100, Sascha Hauer wrote:
> On Tue, Nov 02, 2010 at 01:05:37AM +0100, Alberto Panizzo wrote:
> > This implementation is based on the pxamci.c driver and it will
> > be used to support the mx31_3ds machine.
> > 
> > Signed-off-by: Alberto Panizzo <maramaopercheseimorto@gmail.com>
> 
> Looks good to me
> 
> Acked-by: Sascha Hauer <s.hauer@pengutronix.de>

Tks Sascha, the only difference between the pxa implementations is in 
this part:

> > +static inline void mxcmci_set_power(struct mxcmci_host *host, unsigned int vdd)
> > +{
> > +#ifdef CONFIG_REGULATOR
> > +	if (host->vcc)
> > +		mmc_regulator_set_ocr(host->vcc, vdd);
> > +#endif
> > +	if (host->pdata && host->pdata->setpower)
> > +		host->pdata->setpower(mmc_dev(host->mmc), vdd);
> > +}
> > +

The original one have this test:
	if (!host->vcc && host->pdata && host->pdata->setpower)
		host->pdata->setpower(mmc_dev(host->mmc), vdd);

But removing it, we are able to add further action than only powering
with the right voltage the mmc card.
In the case of the mx31_3ds we are able to enable the external hardware 
buffer only when it is really needed.

-- 
Alberto!

        Be Persistent!
                - Greg Kroah-Hartman (FOSDEM 2010)

