Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880Ab1BARWX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 12:22:23 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:40959 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640Ab1BARWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 12:22:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=DKaJ5+vj9b6A6jBUAIUqtVKBOwzCQ8HRmW2AqjZHE8y53uKIwtN26ktfZClJAnLBrA
         aeRTY3Mm0gFSkD8UozxOoLS9AtgtZbs9nKyux+R8Va5q91IeRDLFR84Eq3Jgy1pA+Ut1
         9gFmp9qet4Jxfo8fNJSgqBg/88Ni1P5bmepa0=
MIME-Version: 1.0
In-Reply-To: <0D753D10438DA54287A00B027084269764CEEDAC85@AUSP01VMBX24.collaborationhost.net>
References: <0D753D10438DA54287A00B027084269764CEEDA479@AUSP01VMBX24.collaborationhost.net>
	<20110201080146.GA27955@pengutronix.de>
	<0D753D10438DA54287A00B027084269764CEEDAC85@AUSP01VMBX24.collaborationhost.net>
Date: Tue, 1 Feb 2011 18:22:20 +0100
Message-ID: <AANLkTi=PQzr+6FupmsgzJB3SKJiH83KV9WJu+D=g3rtV@mail.gmail.com>
Subject: Re: [leds-pca9532] Add gpio capability
From: Joachim Eastwood <manabian@gmail.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Wolfram Sang <w.sang@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/1/11, H Hartley Sweeten <hartleys@visionengravers.com> wrote:
> On Tuesday, February 01, 2011 1:02 AM, Wolfram Sang wrote:
>>> From the datasheet:
>>>[...]
>>> So, you should provide both a direction_input and direction_output.
>>
>> He did in V2 of this patch (what made me also download the datasheet ;)).
>
> Ok.  Just looked at the v2 patch.
>
>> +static int pca9532_gpio_direction_input(struct gpio_chip *gc, unsigned
>> offset)
>> +{
>> + struct pca9532_data *data = container_of(gc, struct pca9532_data, gpio);
>> + struct pca9532_led *led = &data->leds[offset];
>> +
>> + /* To use as input ensure pin is not driven */
>> + led->state = PCA9532_OFF;
>> + pca9532_setled(led);
>> +
>> + return 0;
>> +}
>> +
>
> This looks good.  When configured as an input the pin needs to be set
> high-impedance,
> 00 which is PCA9532_OFF).
>
>> +static int pca9532_gpio_direction_output(struct gpio_chip *gc,
>> unsigned offset, int val)
>> +{
>> + return 0;
>> +}
>> +
>
> Not good.  When the pin is configured as an output, the direction_output
> method also
> requests that the pin be set to a desired level.  For this driver that means
> that the
> pca9532_gpio_direction_output function just needs to call
> pca9532_gpio_set_value.

ops, I overlooked the 'val' parameter in the direction_output
function.  I will create a v3.

Seems like I have been a bit careless with the direction setting... I
didn't really think through it since PCA9532 has no explicit direction
register.

Thanks for looking!

regards
Joachim Eastwood

> Regards,
> Hartley
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
