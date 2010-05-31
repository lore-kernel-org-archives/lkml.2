Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439Ab0EaWDu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 18:03:50 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:38321 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540Ab0EaWDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 18:03:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=qqrTmN2tdFLFx+qp814IIm1LlKqKchQ6XWYac3sqJEXYrb0iID/56InNLIapOup/Ct
         WpjKtw+D0kDjb8+cJ/u2ZeyYgPVH5AgnGzS1KQ8Wal5O4nJImuGQR2+D6FjOEXfoMX4i
         ShbShuDRU5TUX6Rak5CMzK2ybbBNa7u0TsuBo=
Subject: Re: [Regression] [2.6.35-rc1] ssb_is_sprom_available
From: Eric Dumazet <eric.dumazet@gmail.com>
To: maciej.rutecki@gmail.com
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <201005312155.20602.maciej.rutecki@gmail.com>
References: <201005312155.20602.maciej.rutecki@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Jun 2010 00:03:42 +0200
Message-ID: <1275343422.2478.38.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 31 mai 2010 à 21:55 +0200, Maciej Rutecki a écrit :
> Last known good: 2.6.34
> Failing kernel: 2.6.35-rc1
> 
> subsystem: PCI, USB(?)
> 
> Kernel dies during booting on message "ssb_is_sprom_available", see picture:
> http://www.unixy.pl/maciek/download/kernel/2.6.35-rc1/gumis/DSC_0011.JPG
> 
> Config:
> http://www.unixy.pl/maciek/download/kernel/2.6.35-rc1/gumis/config-2.6.35-rc1
> 
> Regards

You could try following patch :

Followup of commit d53cdbb94a52a920d5420ed64d986c3523a56743
(ssb: do not read SPROM if it does not exist)

diff --git a/drivers/ssb/sprom.c b/drivers/ssb/sprom.c
index 007bc3a..af3cd4d 100644
--- a/drivers/ssb/sprom.c
+++ b/drivers/ssb/sprom.c
@@ -185,6 +185,7 @@ bool ssb_is_sprom_available(struct ssb_bus *bus)
 	/* this routine differs from specs as we do not access SPROM directly
 	   on PCMCIA */
 	if (bus->bustype == SSB_BUSTYPE_PCI &&
+	    bus->chipco.dev &&
 	    bus->chipco.dev->id.revision >= 31)
 		return bus->chipco.capabilities & SSB_CHIPCO_CAP_SPROM;
 





