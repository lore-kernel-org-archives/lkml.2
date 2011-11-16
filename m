Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752220Ab1KPSzB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 13:55:01 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:57878 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383Ab1KPSzA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 13:55:00 -0500
MIME-Version: 1.0
In-Reply-To: <4EB9E726.2000500@gmail.com>
References: <1320801583-12774-1-git-send-email-grant.likely@secretlab.ca>
 <1320801583-12774-8-git-send-email-grant.likely@secretlab.ca> <4EB9E726.2000500@gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 16 Nov 2011 11:54:38 -0700
X-Google-Sender-Auth: H3GOQ0UxdHwd7ni2uajKlUyl6I4
Message-ID: <CACxGe6u=oph84k4uS6V3EJN=aiQfHxVOGPahOuWB4Vfx-6bEHA@mail.gmail.com>
Subject: Re: [RFC 7/8] arm/clkdev: lookup clocks from OF clock providers
To: Rob Herring <robherring2@gmail.com>
Cc: devicetree-discuss@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org,
        Sascha Hauer <kernel@pengutronix.de>,
        Rob Herring <rob.herring@calxeda.com>,
        Jeremy Kerr <jeremy.kerr@canonical.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 8, 2011 at 7:36 PM, Rob Herring <robherring2@gmail.com> wrote:
> On 11/08/2011 07:19 PM, Grant Likely wrote:
>> From: Jeremy Kerr <jeremy.kerr@canonical.com>
>>
>> Hook the OF clock provider infrastructure to clk_get.
>>
>> Signed-off-by: Jeremy Kerr <jeremy.kerr@canonical.com>
>> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
>> ---
>>  drivers/clk/clkdev.c |    7 +++++++
>>  1 files changed, 7 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/clk/clkdev.c b/drivers/clk/clkdev.c
>> index 6db161f..63f81c9 100644
>> --- a/drivers/clk/clkdev.c
>> +++ b/drivers/clk/clkdev.c
>> @@ -19,6 +19,8 @@
>>  #include <linux/mutex.h>
>>  #include <linux/clk.h>
>>  #include <linux/clkdev.h>
>> +#include <linux/of.h>
>> +#include <linux/of_clk.h>
>>
>>  static LIST_HEAD(clocks);
>>  static DEFINE_MUTEX(clocks_mutex);
>> @@ -78,6 +80,11 @@ EXPORT_SYMBOL(clk_get_sys);
>>  struct clk *clk_get(struct device *dev, const char *con_id)
>>  {
>>       const char *dev_id = dev ? dev_name(dev) : NULL;
>> +     struct clk *clk;
>> +
>
> Need NULL check for dev (and then init clk to NULL):
>
>        if (dev && dev->of_node)
>> +     clk = of_clk_get_by_name(dev->of_node, con_id);
>
>> +     if (clk && __clk_get(clk))
>> +             return clk;

Fixed, thanks.

g.
