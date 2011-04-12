Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757210Ab1DLU0h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 16:26:37 -0400
Received: from mail.academy.zt.ua ([82.207.120.245]:21603 "EHLO
	mail.academy.zt.ua" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757188Ab1DLU0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 16:26:36 -0400
X-MDAV-Processed: mail.academy.zt.ua, Tue, 12 Apr 2011 23:26:34 +0300
X-Spam-Processed: mail.academy.zt.ua, Tue, 12 Apr 2011 23:26:34 +0300
	(not processed: message from trusted or authenticated source)
X-Authenticated-Sender: george@academy.zt.ua
X-Return-Path: george@znau.edu.ua
X-Envelope-From: george@znau.edu.ua
Subject: Re: [RFC][PATCH] axi: add AXI bus driver
From: George Kashperko <george@znau.edu.ua>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: balbi@ti.com, linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        b43-dev@lists.infradead.org,
        Michael =?ISO-8859-1?Q?B=FCsch?= <mb@bu3sch.de>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Arend van Spriel <arend@broadcom.com>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <rmk@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Andy Botting <andy@andybotting.com>,
        linuxdriverproject <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4DA4AC4B.90409@hauke-m.de>
References: <1302566227-23788-1-git-send-email-zajec5@gmail.com>
	 <20110412133633.GR15130@legolas.emea.dhcp.ti.com>
	 <1302634039.14216.10.camel@dev.znau.edu.ua>
	 <BANLkTi=0sM2+nPYyd09G=Uy9rcEvaFErnA@mail.gmail.com>
	 <1302635550.14216.21.camel@dev.znau.edu.ua>
	 <BANLkTi=8mB9ZDTjF4yds6mkx+PmM+B_6Cg@mail.gmail.com>
	 <4DA4AC4B.90409@hauke-m.de>
Content-Type: text/plain
Date: Tue, 12 Apr 2011 23:23:30 +0300
Message-Id: <1302639810.14216.57.camel@dev.znau.edu.ua>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-19.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> The specification for the AMBA AXI Interface is available for free
> download from ARM if you register to their website and accept their license:
> http://infocenter.arm.com/help/index.jsp?topic=/com.arm.doc.set.amba/index.html
> I got it from there without any problems and the license does not look
> too bad for me, by having a quick look at it. I do not know if it will
> help you in any way or if it is completely unrelated.
> 
> Why is the existing support for the amba bus not extended or used in any
> way for this? It exists for some time in drivers/amba/. There already
> was a discussion about this in https://lkml.org/lkml/2011/3/30/186 , but
> with no result as I see.
Existing AMBA bus might is the proper place to publish axi master port
cores but Rafal's implementation manage those internally. Rafal
introduces separate Broadcom-specific bus intended exclusively for
Broadcom-specific devices management. Those devices share common
identification/management techniques which are completely different from
those implemented by other existant kernel buses and amba bus (at least
at it current state) as well. Might be there are good and proper ways to
extend amba bus driver to support axi as well but its a field for guys
and girls confident with closed proprietary arm docs.
Therefore IMHO the bus introduced by Rafal deserves its own driver and
name. But I'm sure that the "axi" tag isn't good one for this bus.

> 
> >>>> Also can't figure out how is this implementation supposed to manage
> >>>> multicore devices.
> >>>
> >>> We have got ideas, but let's first find (wait for) such a device ;)
> >> bcm4716 usb host ? Don't really know if there are any other multicores.
> > 
> > This is SoC, we do not have any problems supporting multiple cores on
> > SoCs. All cores are available at the same time, without any sliding
> > windows.
> > 
> 
> Hauke
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Have nice day,
George


