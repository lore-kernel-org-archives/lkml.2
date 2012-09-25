Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903Ab2IYSBw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 14:01:52 -0400
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:52257 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750831Ab2IYSBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 14:01:51 -0400
MIME-Version: 1.0
In-Reply-To: <20120925175255.GA13823@sirena.org.uk>
References: <1346844964-24839-1-git-send-email-sourav.poddar@ti.com>
	<20120925175255.GA13823@sirena.org.uk>
Date: Tue, 25 Sep 2012 23:31:07 +0530
Message-ID: <CAKdam576mtUpe0UdFPCiB_9OVv4pVOc=fw5Qs-1TeGmkEmw8Pw@mail.gmail.com>
Subject: Re: [PATCHv2 1/4] mfd: smsc: Add support for smsc gpio io/keypad driver
From: "Poddar, Sourav" <sourav.poddar@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: devicetree-discuss@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, b-cousson@ti.com, balbi@ti.com,
        santosh.shilimkar@ti.com, sameo@linux.intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Sep 25, 2012 at 11:22 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Wed, Sep 05, 2012 at 05:06:04PM +0530, Sourav Poddar wrote:
>
>> +static struct regmap_config smsc_regmap_config = {
>> +             .reg_bits = 8,
>> +             .val_bits = 8,
>> +             .max_register = SMSC_MAX_REGISTER - 1;
>> +             .cache_type = REGCACHE_COMPRESSED,
>> +};
>
> That definition of max_register looks wrong - why are we subtracting 1
> from a macro called MAX_REGISTER to get it?
>
Yes, my bad.
Actually, I have define in .h file something like this..
#define SMSC_MAX_REG                                    (SMSC_VEN_ID_H
+ 1) where
SMSC_VEN_ID_H is the last register address which this chip supports.

I think I should directly assign max_address to SMSC_VEN_ID_H.   ?
+
+
> Indentation here is a bit odd too.
>
Will rectify.
>> +static int smsc_i2c_remove(struct i2c_client *i2c)
>> +{
>> +     return 0;
>> +}
>
> Remove empty functions.
Ok.
