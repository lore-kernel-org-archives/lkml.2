Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759377Ab2FULhV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 07:37:21 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:35427 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759351Ab2FULhT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 07:37:19 -0400
MIME-Version: 1.0
In-Reply-To: <20120621091833.GH2193@core.coreip.homeip.net>
References: <1340192062-10565-1-git-send-email-aletes.xgr@gmail.com>
	<20120621091833.GH2193@core.coreip.homeip.net>
Date: Thu, 21 Jun 2012 08:37:18 -0300
Message-ID: <CAAAP30GsU1wy87QJjcctpu-=uYH6O0XEikMs5GeGDsz-gvwsZQ@mail.gmail.com>
Subject: Re: [PATCH RESEND] input: gpio_keys_polled: convert to dt
From: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, JJ Ding <dgdunix@gmail.com>,
        Roland Stigge <stigge@antcom.de>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 21, 2012 at 6:18 AM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
>> @@ -38,7 +40,7 @@ struct gpio_keys_button_data {
>>  struct gpio_keys_polled_dev {
>>       struct input_polled_dev *poll_dev;
>>       struct device *dev;
>> -     struct gpio_keys_platform_data *pdata;
>> +     struct gpio_keys_platform_data pdata;
>
> I am not sure why this change is needed. Also it seems that the driver
> leaks DT-created pdata on unload.

Pdata is now a member of gpio_keys_polled_dev now and that one is
kzalloc'ed at probe and kfree'd at the removal and errors. I see no
leaks there.

I could kzalloc and kfree gpio_keys_polled_dev independently instead,
to avoid all those pointer changes if you think it's better.

This is mostly a clone from the dt handling in gpio_keys, and
comparing both now,
I see that it will leak on pdata->buttons, so I will fix that.

>> +
>> +#define gpio_keys_polled_of_match NULL
>
> Please use of_match_ptr() instead.

Thanks for the suggestion, I will implement that.
