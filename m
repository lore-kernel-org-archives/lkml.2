Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752176Ab2FYIEA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 04:04:00 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61955 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275Ab2FYID5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 04:03:57 -0400
Date: Mon, 25 Jun 2012 01:03:48 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, JJ Ding <dgdunix@gmail.com>,
        Roland Stigge <stigge@antcom.de>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH RESEND] input: gpio_keys_polled: convert to dt
Message-ID: <20120625080348.GI13876@core.coreip.homeip.net>
References: <1340192062-10565-1-git-send-email-aletes.xgr@gmail.com>
 <20120621091833.GH2193@core.coreip.homeip.net>
 <CAAAP30GsU1wy87QJjcctpu-=uYH6O0XEikMs5GeGDsz-gvwsZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAAP30GsU1wy87QJjcctpu-=uYH6O0XEikMs5GeGDsz-gvwsZQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 21, 2012 at 08:37:18AM -0300, Alexandre Pereira da Silva wrote:
> On Thu, Jun 21, 2012 at 6:18 AM, Dmitry Torokhov
> <dmitry.torokhov@gmail.com> wrote:
> >> @@ -38,7 +40,7 @@ struct gpio_keys_button_data {
> >>  struct gpio_keys_polled_dev {
> >>       struct input_polled_dev *poll_dev;
> >>       struct device *dev;
> >> -     struct gpio_keys_platform_data *pdata;
> >> +     struct gpio_keys_platform_data pdata;
> >
> > I am not sure why this change is needed. Also it seems that the driver
> > leaks DT-created pdata on unload.
> 
> Pdata is now a member of gpio_keys_polled_dev now and that one is
> kzalloc'ed at probe and kfree'd at the removal and errors. I see no
> leaks there.

Ah, I missed that you used on-stack instance to hold parsed DT data...

> 
> I could kzalloc and kfree gpio_keys_polled_dev independently instead,
> to avoid all those pointer changes if you think it's better.
> 
> This is mostly a clone from the dt handling in gpio_keys, and
> comparing both now,
> I see that it will leak on pdata->buttons, so I will fix that.
> 
> >> +
> >> +#define gpio_keys_polled_of_match NULL
> >
> > Please use of_match_ptr() instead.
> 
> Thanks for the suggestion, I will implement that.

-- 
Dmitry
