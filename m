Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756456Ab0CaCl7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 22:41:59 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:65480 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756064Ab0CaCl5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 22:41:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=oNlsO8jPRlsMyivWoJQGpy+AtM2u5mV1kHW5NKVZejQ0Z5Wwj2Mt2o790iLIb08bIq
         tkgYHj2UWqr4vzMryx+fyGevT1JEGH7Bzj1ShowORgMksJhxwOcgtvIdAsg0Wl02upmo
         HIJlyKh6pKzjbyDK9E8JXVc2L2F4lk15PqI+o=
MIME-Version: 1.0
In-Reply-To: <20100330160257.e5f978a9.akpm@linux-foundation.org>
References: <90b950fc1003252024i5ba8989bg95f0a81e8e5e708e@mail.gmail.com>
	 <20100330160257.e5f978a9.akpm@linux-foundation.org>
Date: Wed, 31 Mar 2010 11:41:54 +0900
Message-ID: <90b950fc1003301941r69dc5ce1ida64b590646049a7@mail.gmail.com>
Subject: Re: [PATCH] added S6E63M0 AMOLED LCD Panel driver.
From: InKi Dae <daeinki@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pavel Machek <pavel@ucw.cz>, linux-fbdev-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, kyungmin.park@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

all the calls to s6e63m0_panel_send_sequence() would return -EINVAL.
by api_async() of driver/spi/spi.c
so I think that those return values aren't changed to other.

and final step is to check only whether the return value is 0 or not.
if you still think that this code has minor problem or you want it to
be corrected
then I will patch this code to be corrected anytime.

Thank you.

2010/3/31 Andrew Morton <akpm@linux-foundation.org>:
> On Fri, 26 Mar 2010 12:24:24 +0900
> InKi Dae <daeinki@gmail.com> wrote:
>
>> +static int s6e63m0_ldi_init(struct s6e63m0 *lcd)
>> +{
>> +     int ret;
>> +
>> +     ret = s6e63m0_panel_send_sequence(lcd, SEQ_PANEL_CONDITION_SET);
>> +     ret |= s6e63m0_panel_send_sequence(lcd, SEQ_DISPLAY_CONDITION_SET);
>> +     ret |= s6e63m0_panel_send_sequence(lcd, SEQ_GAMMA_SETTING);
>> +     ret |= s6e63m0_panel_send_sequence(lcd, SEQ_ETC_CONDITION_SET);
>> +     ret |= s6e63m0_panel_send_sequence(lcd, SEQ_ACL_ON);
>> +     ret |= s6e63m0_panel_send_sequence(lcd, SEQ_ELVSS_ON);
>> +
>> +     return ret;
>> +}
>
> Well.  If one call to s6e63m0_panel_send_sequence() returns -ENOMEM and
> another call returns -EIO (for example), this function will return some
> other, incorrect errno.
>
> Which is a rather minor problem, unless some caller is explicitly
> looking for some particular error code, which doesn't happen often.
>
