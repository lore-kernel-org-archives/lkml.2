Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774Ab2GWUUZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 16:20:25 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:39926 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754160Ab2GWUUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 16:20:23 -0400
X-Greylist: delayed 438 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Jul 2012 16:20:23 EDT
Message-ID: <500DB0CB.1000600@metafoo.de>
Date: Mon, 23 Jul 2012 22:15:07 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120613 Icedove/3.0.11
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: "Philip, Avinash" <avinashphilip@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, nsekhar@ti.com, gururaja.hebbar@ti.com
Subject: Re: [PATCH] PWM: Add support for configuring polarity of PWM
References: <1342616053-7793-1-git-send-email-avinashphilip@ti.com> <20120723083032.GA12868@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20120723083032.GA12868@avionic-0098.mockup.avionic-design.de>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2012 10:30 AM, Thierry Reding wrote:
> On Wed, Jul 18, 2012 at 06:24:13PM +0530, Philip, Avinash wrote:
>>[...]
>> diff --git a/include/linux/pwm.h b/include/linux/pwm.h
>> index 21d076c..2e4e960 100644
>> --- a/include/linux/pwm.h
>> +++ b/include/linux/pwm.h
>> @@ -21,6 +21,16 @@ void pwm_free(struct pwm_device *pwm);
>>   */
>>  int pwm_config(struct pwm_device *pwm, int duty_ns, int period_ns);
>>  
>> +enum {
>> +	PWM_POLARITY_NORMAL,	/* ON period depends on duty_ns */
>> +	PWM_POLARITY_INVERSE,	/* OFF period depends on duty_ns */
>> +};
> 
> You should name this enumeration so that it can actually be used as a
> type (enum pwm_polarity). Also you can drop the comments because they
> only apply to the specific use-case of simulating duty-cycle inversion

I think we should make it very explicit what normal polarity and inverse
polarity is. There are certain applications where it is important. E.g. one
such application would be using it in the IIO framework to generate a trigger
pulse to synchronize devices. If we do not specify how each of these modes
should behave drivers may interpret and implement them differently.

I'd vote for the following definitions:
PWM_POLARITY_NORMAL: A high signal for the duration of duty_ns, followed by a
low signal for the duration of (period_ns - duty_ns).
PWM_POLARITY_INVERSE: A low signal for the duration duty_ns, followed by a high
signal for the duration of (period_ns - duty_ns).

Maybe even rename them to PWM_POLARITY_ACTIVE_HIGH and PWM_POLARITY_ACTIVE_LOW
since it is a bit more explicit on how the waveform should look like. "NORMAL"
and "INVERSE" sort of depend on what you consider to be normal.

- Lars
