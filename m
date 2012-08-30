Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752576Ab2H3HKQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 03:10:16 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:28658 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925Ab2H3HKM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 03:10:12 -0400
X-AuditID: cbfee61a-b7fc66d0000043b7-0b-503f11d358e3
From: Jingoo Han <jg1.han@samsung.com>
To: "'Lars-Peter Clausen'" <lars@metafoo.de>
Cc: "'Thierry Reding'" <thierry.reding@avionic-design.de>,
        linux-kernel@vger.kernel.org, "'Sascha Hauer'" <kernel@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org,
        "'Dmitry Torokhov'" <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, "'Bryan Wu'" <bryan.wu@canonical.com>,
        "'Richard Purdie'" <rpurdie@rpsys.net>, linux-leds@vger.kernel.org,
        "'Florian Tobias Schandinat'" <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org,
        "=?utf-8?Q?'Beno=C3=AEt_Th=C3=A9baudeau'?=" 
	<benoit.thebaudeau@advansee.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <217877237.2758643.1345731587941.JavaMail.root@advansee.com>
 <50364FA4.7000401@metafoo.de>
In-reply-to: <50364FA4.7000401@metafoo.de>
Subject: Re: [PATCH] pwm: Call pwm_enable() before pwm_config()
Date: Thu, 30 Aug 2012 16:10:11 +0900
Message-id: <002001cd867e$7e964130$7bc2c390$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2BR2Mq93YkOxlERIyQgCbVgluCwgFNkDtw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJLMWRmVeSWpSXmKPExsVy+t9jAd3LgvYBBq+eSFuc6PvAanHz0zdW
	i8u75rBZbH2zjtGBxePzJrkAxigum5TUnMyy1CJ9uwSujIefAwoWcFf0NJ9ha2B8wdHFyMkh
	IWAi8bnvFDuELSZx4d56ti5GLg4hgUWMEjumbWOBcH4xSpz8dp4VpIpNQE3iy5fDYB0iAloS
	U7+9ZQUpYhZYzSJx+v9rsISQQIbE698H2UBsTqCirZ33WUBsYQF7iRsr5zCC2CwCqhKTzvaC
	xXkFbCWu7ZvHDmELSvyYfA8ozgE0VF1iypRckDCzgLbEk3cXWEHCEkDhR391QUwRASOJ4yeF
	ISpEJPa9eMc4gVFoFpI5sxDmzEIyZxaSjgWMLKsYRVMLkguKk9JzDfWKE3OLS/PS9ZLzczcx
	ggP8mdQOxpUNFocYBTgYlXh4OTLtAoRYE8uKK3MPMUpwMCuJ8LLz2wcI8aYkVlalFuXHF5Xm
	pBYfYpTmYFES53U6B1QtkJ5YkpqdmlqQWgSTZeLglGpg7K0scns2PYm1dWVB8kOlj43rFmSV
	63x6MiPQ4XlgXNMluad2qgard19k5dy8pyt24VbPjAWflet4xBxevuNQX5YpEyf2+Np0+5op
	8emVmeKynAdXxylM3z41d9uvecwVh0JyzOY6h31ZkH37eKht1yzZve39Vj7LmKcfn3j58OM0
	rZQZ+yXblViKMxINtZiLihMBSqkvQ2wCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, August 24, 2012 12:44 AM, Lars-Peter Clausen wrote:
> 
> On 08/23/2012 04:19 PM, Benoît Thébaudeau wrote:
> > Some PWM drivers enable the clock of the PWM peripheral in pwm_enable(). Hence,
> > for these drivers, a call to pwm_config() does not have any effect before
> > pwm_enable() has been called.
> >
> > This patch fixes the PWM users to make sure that they call pwm_enable() before
> > pwm_config().
> >
> > This fixes the first setting of brightness through sysfs that had no effect with
> > leds-pwm and the i.MX PWM driver.
> 
> But isn't this a bug in the PWM peripheral driver? With this change the PWM
> will start with the old settings first. While this is not so much of a problem
> for a backlight (although it might cause a short flickering) it might cause
> problems for other applications, like using the PWM pin as a timing generator.
> In my opinion it's better to fix the PWM peripheral drivers which have this
> problem instead of trying to work around it in every user of the PWM API.

Hi Lars-Peter Clausen,

I think so.
It would be better to fix the PWM peripheral drivers.


Best regards,
Jingoo Han

> 
> - Lars
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fbdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

