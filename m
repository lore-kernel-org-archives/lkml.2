Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757329Ab2HVHe2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 03:34:28 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:40578 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755983Ab2HVHeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 03:34:25 -0400
MIME-Version: 1.0
In-Reply-To: <CABCoZhC5z9Pu19Yq8YCTLw8NJO1pbc3AztD=xmembA8tQiG31Q@mail.gmail.com>
References: <CABCoZhC5z9Pu19Yq8YCTLw8NJO1pbc3AztD=xmembA8tQiG31Q@mail.gmail.com>
From: Vasily Khoruzhick <anarsoul@gmail.com>
Date: Wed, 22 Aug 2012 10:34:04 +0300
Message-ID: <CA+E=qVdOhTr9iXR9w9UdAQ6q0XuqQLunxyaxgcfd0Y1Tn8hzpA@mail.gmail.com>
Subject: Re: Power: s3c_adc_battery.c backup battery query
To: anish kumar <yesanishhere@gmail.com>
Cc: linux-kernel@vger.kernel.org, lars@metafoo.de, cbou@mail.ru,
        dwmw2@infradead.org, kzjeef@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2012 at 8:05 AM, anish kumar <yesanishhere@gmail.com> wrote:
> Hello,

Hi

> I am trying to write a generic batttery driver using IIO and I have
> one some below
> questions:
>
> Why do we have the representation of backup battery in this
> driver(s3c_adc_battery.c) and when does the
> s3c_adc_backup_bat_get_property function gets called?

Because backup battery differs a bit from main battery (for example,
it has no current monitoring capability).
Maybe it was not a good decision, as it's possible to handle it via
platform data info as you suggested.

> As I understand, it is as this:It is called when it is registered
> and when the user wants to know the backup battery status(sysfs)
> and we don't do a workqueue scheduling as it will consume more power.
>
> static struct s3c_adc_bat backup_bat = {
>         .psy = {
>                 .name           = "backup-battery",
>                 .type           = POWER_SUPPLY_TYPE_BATTERY,
>                 .properties     = s3c_adc_backup_bat_props,
>                 .num_properties = ARRAY_SIZE(s3c_adc_backup_bat_props),
>                 .get_property   = s3c_adc_backup_bat_get_property,
>                 .use_for_apm    = 1,
>         },
> };
>
> I am stuck with mulitple *get_property callbacks.As we don't know how many
> batteries system has and consequently we don't know how many *get_property
> callbacks to be implemented.
>
> So below is my plan:
> What I am trying to do is to have a single callback(*get_property) and manage
> everything in this callback and will use the name of the psy to
> distinguish between
> the different batteries which system has and driver will receive this
> information using
> platform data.Hope it makes sense.

Just send a patch for review :)

Regards
Vasily
