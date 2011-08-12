Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751536Ab1HLUjB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 16:39:01 -0400
Received: from smtp19.mail.ru ([94.100.176.156]:55678 "EHLO smtp19.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751218Ab1HLUjA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 16:39:00 -0400
Date: Sat, 13 Aug 2011 00:38:25 +0400
From: Dmitry Artamonow <mad_soft@inbox.ru>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        Ian Dobson <i.dobson@planet-ian.com>,
        Jean Delvare <khali@linux-fr.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] hwmon: add caseopen detection to w83627ehf driver
Message-ID: <20110812203824.GB32369@rainbow>
References: <1313009786-29885-1-git-send-email-mad_soft@inbox.ru>
 <1313084814.2214.100.camel@groeck-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313084814.2214.100.camel@groeck-laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10:46 Thu 11 Aug     , Guenter Roeck wrote:
> Hi Dmitry,
> 
> please consider the changes suggested below.

[...]

> > +static struct sensor_device_attribute sda_caseopen[] = {
> > +	SENSOR_ATTR(intrusion0_alarm, S_IWUSR | S_IRUGO, show_caseopen,
> > +			clear_caseopen, 0),
> > +	SENSOR_ATTR(intrusion1_alarm, S_IWUSR | S_IRUGO, show_caseopen,
> > +			clear_caseopen, 1),
> 
> 	SENSOR_ATTR_2(intrusion0_alarm, S_IWUSR | S_IRUGO,
> 			show_caseopen, clear_caseopen, 0x80, 0x10),
> 	SENSOR_ATTR_2(intrusion1_alarm, S_IWUSR | S_IRUGO,
> 			show_caseopen, clear_caseopen, 0x40, 0x40),
> 

Oh, yeah! That's much neater with SENSOR_ATTR_2 - thanks for suggestion!
I've seen it while looking to other hwmon drivers, but missed the difference
from plain SENSOR_ATTR...

I've incorporated your suggested changes into v3 of the patch - it will follow
this mail.

-- 
Best regards,
Dmitry "MAD" Artamonow

