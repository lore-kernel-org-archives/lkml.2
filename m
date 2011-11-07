Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933066Ab1KGRjU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 12:39:20 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:45773 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754963Ab1KGRjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 12:39:19 -0500
Message-ID: <4EB817C6.5070503@kernel.org>
Date: Mon, 07 Nov 2011 17:39:18 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20111001 Thunderbird/7.0.1
MIME-Version: 1.0
To: guenter.roeck@ericsson.com
CC: "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "khali@linux-fr.org" <khali@linux-fr.org>,
        "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "lars@metafoo.de" <lars@metafoo.de>,
        "maxime.ripard@free-electrons.com" <maxime.ripard@free-electrons.com>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "thomas.petazzoni@free-electrons.com" 
	<thomas.petazzoni@free-electrons.com>,
        "zdevai@gmail.com" <zdevai@gmail.com>,
        Jonathan Cameron <jic23@cam.ac.uk>
Subject: Re: [PATCH 4/5] IIO:hwmon interface client driver.
References: <1320680681-5635-1-git-send-email-jic23@kernel.org>  <1320680681-5635-5-git-send-email-jic23@kernel.org> <1320683392.2309.109.camel@groeck-laptop>
In-Reply-To: <1320683392.2309.109.camel@groeck-laptop>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> +static int __devexit iio_hwmon_remove(struct platform_device *pdev)
>> +{
>> +	struct iio_hwmon_state *st = platform_get_drvdata(pdev);
>> +
>> +	hwmon_device_unregister(st->hwmon_dev);
>> +	sysfs_remove_group(&pdev->dev.kobj, &st->attr_group);
>> +	iio_hwmon_free_attrs(st);
>> +	kfree(st->attrs);
>> +	iio_channel_release_all(st->channels);
>> +
> 
> Either I missed it before, or I am missing something now ... should
> there be kfree(st) here ?
> 
> Thanks,
> Guenter

Gah! you are quite right.  Good spot.  I'll fix that one up and repost
this individual patch.

