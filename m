Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573Ab1KUV1G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 16:27:06 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:43898 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508Ab1KUV1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 16:27:05 -0500
Date: Mon, 21 Nov 2011 22:26:53 +0100
From: Jean Delvare <khali@linux-fr.org>
To: guenter.roeck@ericsson.com
Cc: "Frank T. Lofaro Jr." <ftlofaro@yahoo.com>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Drivers: hwmon: it87: Add support for ITE 8728
Message-ID: <20111121222653.5441b63f@endymion.delvare>
In-Reply-To: <1320688845.2309.122.camel@groeck-laptop>
References: <1320381858.22997.YahooMailNeo@web161601.mail.bf1.yahoo.com>
	<1320688845.2309.122.camel@groeck-laptop>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Nov 2011 10:00:45 -0800, Guenter Roeck wrote:
> On Fri, 2011-11-04 at 00:44 -0400, Frank T. Lofaro Jr. wrote:
> > This patch allows the ITE 8728 chip to be detected and used.
> > The chip appears to be compatible with the 8721.

Frank, can we see the output of "sensors" on your system with your
patch applied?

> Can anyone confirm that those chips are actually compatible ?

The datasheet is not publicly available, unfortunately. The info I have
is that temperature and fan parts are likely to be compatible. Not so
sure about the voltages, although the ADC resolution is the same (12
mV.)

> > @@ -1603,6 +1605,7 @@ static int __init it87_find(unsigned short
> > *address,
> >                 sio_data->type = it8720;
> >                 break;
> >         case IT8721F_DEVID:
> > +       case IT8728F_DEVID:
> >                 sio_data->type = it8721;
> >                 break;
> >         case 0xffff:    /* No device at all */

One thing for sure: I want to play it safe and introduce a separate
chip type for the IT8728F. Two advantages: we can tell who has an
IT8728F from user reports easily, and we can add chip tweaks later
easily without breaking user configurations.

-- 
Jean Delvare
