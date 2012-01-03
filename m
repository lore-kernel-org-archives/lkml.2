Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070Ab2ACQ13 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 11:27:29 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:33697 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753947Ab2ACQ12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 11:27:28 -0500
Date: Tue, 3 Jan 2012 10:27:20 -0600
From: Jonathan Nieder <jrnieder@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        rtc-linux@googlegroups.com, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        John Stultz <john.stultz@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        "Antonio-M. Corbi Bellot" <antonio.corbi@ua.es>,
        Marco Santos <marco.santos@waynext.com>,
        Christophe Vu-Brugier <cvubrugier@yahoo.fr>
Subject: Re: [096/104] rtc: Disable the alarm in the hardware
Message-ID: <20120103162720.GA22050@elie.hsd1.il.comcast.net>
References: <20111207161246.GA10995@kroah.com>
 <20111207161222.676101253@clark.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111207161222.676101253@clark.kroah.org>
User-Agent: Mutt/1.5.21+51 (9e756d1adb76) (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Greg KH wrote:

> 3.1-stable review patch.  If anyone has any objections, please let me know.
>
> ------------------
>
> From: Rabin Vincent <rabin.vincent@stericsson.com>
>
> commit c0afabd3d553c521e003779c127143ffde55a16f upstream.
>
> Currently, the RTC code does not disable the alarm in the hardware.
>
> This means that after a sequence such as the one below (the files are in the
> RTC sysfs), the box will boot up after 2 minutes even though we've
> asked for the alarm to be turned off.
[...]
> Fix this by disabling the alarm when there are no timers to run.

Seems to cause a regression.  On the affected kernels (e.g., 3.1.5,
3.1.6, and 3.2-rc7) the patch has exactly the opposite of what you'd
expect --- the affected machines automatically power on a few minutes
after shutdown if and only if the patch is applied.

The affected machines all seem to be Toshiba Portege laptops.

 Antonio-M. Corbi Bellot: Toshiba Portege R500
 Marco Santos: Toshiba Portege Z830
 Christophe Vu-Brugier: Toshiba Portege R830

Christophe tried reverting the above patch and the symptoms went away.
See http://bugs.debian.org/652869 for details.  Please consider
reverting the patch from stable until this is resolved.

Thanks,
Jonathan
