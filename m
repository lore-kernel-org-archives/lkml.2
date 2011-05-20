Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935057Ab1ETQPS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 12:15:18 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:58912 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934628Ab1ETQPQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 12:15:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=VLpMlFyu5l/z/Mobsd7pw8WgL4GqmVF2sLNDGsOEf8pnJ0o9qK5P/pMM+k06LUFe+V
         gz0bD1F9apsPgjbyhevctzPkPIOC6zIK59DXB+4ZoYgvOkLZLBqvOfEYSEQJV20yCXN/
         rgBjqbGsEXAz7LHxPa3BlJ9lGe5L+UslXbKDE=
MIME-Version: 1.0
In-Reply-To: <BANLkTinsSuDj8vMYG-40aAw0UVwLDo2KDQ@mail.gmail.com>
References: <1305321990-22041-1-git-send-email-balbi@ti.com>
 <1305321990-22041-2-git-send-email-balbi@ti.com> <BANLkTinsSuDj8vMYG-40aAw0UVwLDo2KDQ@mail.gmail.com>
From: =?ISO-8859-2?Q?Micha=B3_Miros=B3aw?= <mirqus@gmail.com>
Date: Fri, 20 May 2011 18:14:55 +0200
Message-ID: <BANLkTimOyVHN--NXvje+zVOTxj6ghV+uOA@mail.gmail.com>
Subject: Re: [RFC/PATCH 01/13] net: wl12xx: sdio: id_tables should be __devinitconst
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Felipe Balbi <balbi@ti.com>, Luciano Coelho <coelho@ti.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/20 Ohad Ben-Cohen <ohad@wizery.com>:
> On Sat, May 14, 2011 at 12:26 AM, Felipe Balbi <balbi@ti.com> wrote:
>> That's only needed during init anyway, let's free
>> some space after we're done probing.
> sdio devices are dynamically created whenever the hw is plugged into
> the mmc slot by the user. that can happen anytime while the system is
> up, not only during init.
>> -static const struct sdio_device_id wl1271_devices[] = {
>> +static const struct sdio_device_id wl1271_devices[] __devinitconst = {
> it looks to me that sdio_match_device is going to be surprised if
> ->id_table won't be valid.
>
> i wouldn't do this, unless you have a good explanation otherwise.

devinit sections are not freed if device hotplug is enabled.

Best Regards,
Micha³ Miros³aw
