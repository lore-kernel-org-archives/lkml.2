Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488Ab2DSNyx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 09:54:53 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:62564 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752965Ab2DSNyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 09:54:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/9] ARM: OMAP2+: SmartReflex: move the driver specific macros in include/linux/power
Date: Thu, 19 Apr 2012 13:54:38 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: Trilok Soni <tsoni@codeaurora.org>, Jean Pihet <jean.pihet@newoldbits.com>,
        Kevin Hilman <khilman@ti.com>, "Cousson, Benoit" <b-cousson@ti.com>,
        gregkh@linuxfoundation.org, LKML <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-omap@vger.kernel.org,
        Jean Pihet <j-pihet@ti.com>
References: <1332173578-27422-1-git-send-email-j-pihet@ti.com> <CAORVsuVt5uj5NAsqsce+7f=xMXC9-nck5cPUCOEC8QP3VkxYyA@mail.gmail.com> <4F7D6746.9020504@codeaurora.org>
In-Reply-To: <4F7D6746.9020504@codeaurora.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201204191354.38874.arnd@arndb.de>
X-Provags-ID: V02:K0:RHluUbO3HvXG3MjHkXMK3ghiYH75oYHYLVm03cqQRB6
 m2X8UXvBKGUGOLkfi+zBrXIUkQz22BIae81HAdsLpqhwjIJDLq
 TByDX063xRsCVFc/wzliCyiaquLAHOknCWla31ItAPUXVPzhYv
 VWx4TFzRoDimE7AxAliIFQ8dBVmw8bTBo+/rxdD65f6c0JciPE
 0nUZrgSc5lB7LGTX3kjUkO3f7IFKC2Yms+xU0vQeeKBLS5BJLa
 ijG4h20vKfJ0upJzXHShdlXHFxBYyymFstsR83kUkGzJX7Qdkh
 Ov8vy1EME2KqejC0JUUe/7VH9U0/tKpdmxrkaTRpb2fVCA8hYl
 oKNDFXGRK+GgLNriciAk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 05 April 2012, Trilok Soni wrote:
> >> Couple of suggestions:
> >>
> >> drivers/platform/omap/avs?
> >> drivers/misc/omap/avs?
> >>

I would definitely prefer something under drivers/power,
drivers/regulators or a new top-level directory under
drivers.

> >>> IIRC, David Brownell was referring to the rule of three for such case.
> >>> Meaning that it worth having a generic fmwk when at least three
> >>> different drivers are doing the same kind of things.
> >
> > Do OMAP v1 and OMAP v2 implementations count as 2 drivers? ;-)
> > More seriously, the OMAP code for SmartReflex is far from complete in
> > mainline. There is a plan to provide the following features:
> > - OMAP v1 IP,
> > - OMAP v2 IP,
> > - class 1.5,
> > - class 3,
> > - class 3.5,
> > - and more support for the upcoming chipsets.
> 
> I don't understand much of these versions right now, but hopefully after 
> going through all these docs. My only contention point is to not create 
> any directory into the drivers/power, unless it is generic fwk and then 
> build up "client" drivers on top of it. Meanwhile we could move this 
> driver into above options as I have suggested.

I think creating the directory in the place where we want the files
to stay in the long run is ok, if the plan is to add more drivers and
make the base code more generic. We don't have to wait until it's too
late and we absolutely need a framework ;-)

The part I don't understand is how this relates to the regulator framework.
Is there any overlap between the functionality provided by the
smartreflex framework and the regulator framework? If so, would it be
better to extend the existing framework so it can do smartreflex as well?

	Arnd
