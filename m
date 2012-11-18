Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473Ab2KRUK6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 15:10:58 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:62305 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220Ab2KRUK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 15:10:57 -0500
MIME-Version: 1.0
In-Reply-To: <20121118182049.GE14643@lunn.ch>
References: <CAMW5UfYUi-Zz2r5K9GeVzShSub2rDJVuoWR56+89+ytaqo_uxQ@mail.gmail.com>
	<20121118174720.GX3290@n2100.arm.linux.org.uk>
	<CAMW5Ufb9D+BYGtZUWPBWKMtk11QMpR1N+2Q1yb4w_GdvV17p+w@mail.gmail.com>
	<20121118182049.GE14643@lunn.ch>
Date: Sun, 18 Nov 2012 15:10:56 -0500
Message-ID: <CAMW5UfYt6xPYEJwUcK9fqHNMPHfTSMM69cvc-un7LGooaFqyjQ@mail.gmail.com>
Subject: Re: [Patch v1 1/1] RTL8712 alignment bug in 3.6.5 on ARM
From: Josh Coombs <josh.coombs@gmail.com>
To: Andrew Lunn <andrew@lunn.ch>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux ARM <linux-arm-kernel@lists.infradead.org>, wlanfae@realtek.com,
        Larry.Finger@lwfinger.net, florian.c.schilhabel@googlemail.com,
        gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Testing now, will re-submit in the correct format once I confirm it
works as intended.

On Sun, Nov 18, 2012 at 1:20 PM, Andrew Lunn <andrew@lunn.ch> wrote:
>> >> diff -ruN a/drivers/staging/rtl8712/rtl871x_sta_mgt.c
>> >> b/drivers/staging/rtl8712/rtl871x_sta_mgt.c
>> >> --- a/drivers/staging/rtl8712/rtl871x_sta_mgt.c 2012-11-05
>> >> 03:57:06.000000000 -0500
>> >> +++ b/drivers/staging/rtl8712/rtl871x_sta_mgt.c 2012-11-13
>> >> 12:54:28.000000000 -0500
>> >> @@ -55,8 +55,8 @@
>> >>     NUM_STA + 4);
>> >>   if (pstapriv->pallocated_stainfo_buf == NULL)
>> >>   return _FAIL;
>> >> - pstapriv->pstainfo_buf = pstapriv->pallocated_stainfo_buf + 4 -
>> >> - ((addr_t)(pstapriv->pallocated_stainfo_buf) & 3);
>> >> + pstapriv->pstainfo_buf = pstapriv->pallocated_stainfo_buf + 8 -
>> >> + ((addr_t)(pstapriv->pallocated_stainfo_buf) & 7);
>> >
>> > Are you sure this is safe?  Is the allocated buffer large enough for
>> > those additional 4 bytes of alignment you're adding?
>>
>> I'm not certain on that, I bumped the allocations at Andrew's
>> suggestion, but don't know enough to certify the changes as 100%
>> correct.
>
> Its not correct.
>
> The original code is:
>
>         pstapriv->pallocated_stainfo_buf = _malloc(sizeof(struct sta_info) *
>                                                    NUM_STA + 4);
>         if (pstapriv->pallocated_stainfo_buf == NULL)
>                 return _FAIL;
>         pstapriv->pstainfo_buf = pstapriv->pallocated_stainfo_buf + 4 -
>                 ((addr_t)(pstapriv->pallocated_stainfo_buf) & 3);
>
> The 4 in the _malloc() also needs increasing to 8.
>
>     Andrew
