Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925Ab0GEL7I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 07:59:08 -0400
Received: from poutre.nerim.net ([62.4.16.124]:64754 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751759Ab0GEL7F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 07:59:05 -0400
Date: Mon, 5 Jul 2010 13:59:00 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Ethan Lawrence <e.law87@yahoo.com>, Jim Cromie <jim.cromie@gmail.com>,
       H Hartley Sweeten <hsweeten@visionengravers.com>,
       Iain <selsinork@gmail.com>,
       "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "lars4910@hotmail.com" <lars4910@hotmail.com>,
       "birdie@permonline.ru" <birdie@permonline.ru>,
       "jadcock@cox.net" <jadcock@cox.net>,
       "binximeng@gmail.com" <binximeng@gmail.com>
Subject: Re: [PATCH v4 1/2] hwmon: w83627ehf driver cleanup
Message-ID: <20100705135900.457764e7@hyperion.delvare>
In-Reply-To: <20100704135010.GA21500@ericsson.com>
References: <1278195202-2683-1-git-send-email-guenter.roeck@ericsson.com>
	<1278195202-2683-2-git-send-email-guenter.roeck@ericsson.com>
	<20100704132442.07a5ef40@hyperion.delvare>
	<20100704135010.GA21500@ericsson.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter,

On Sun, 4 Jul 2010 06:50:10 -0700, Guenter Roeck wrote:
> On Sun, Jul 04, 2010 at 07:24:42AM -0400, Jean Delvare wrote:
> > I'm skeptical. data->has_fan refers to fan inputs, not fan outputs.
> > There is no guarantee that pwm1 is mapped to fan1, etc., so you can't
> > use data->has_fan to discard fan outputs.
>
> Maybe, but they are treated as 1:1 for fan4 when creating the pwm files,
> and the pwm files for fan4 are not created if the matching bit isn't set.
> This applies to all chips supported by this driver. And for fan1..3, the
> mapping is supposed to be 1:1 per the driver documentation.

The driver documentation was written by ourselves, I wouldn't trust it ;)

Oh well, I hadn't noticed that sysfs file creation already assumes a
1:1 fan to pwm mapping. I am still unsure if it is correct, but it might
be good enough on practice, and your patch isn't changing it anyway, so
it's not the time to discuss it.

> I figured that it does not make sense to read the registers for a non-existing
> attribute file.

I agree that we want to skip register reads when possible (not that it
matters as much as when reading over slow SMBus though.) 

I have no further objections to your patch, so I'll apply it now. Then
I'll publish the patches and update the stand-alone driver, and we can
call for testers.

-- 
Jean Delvare
