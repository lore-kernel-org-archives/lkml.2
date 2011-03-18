Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932201Ab1CRJBb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 05:01:31 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:53942 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756487Ab1CRJBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 05:01:25 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Roger Quadros <roger.quadros@nokia.com>
Subject: Re: RFC: Platform data for onboard USB assets
Date: Fri, 18 Mar 2011 10:01:17 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Greg KH <greg@kroah.com>, Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>, andy.green@linaro.org,
        Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
References: <20110311161421.GA7843@kroah.com> <201103172311.36246.arnd@arndb.de> <4D831AEF.3020109@nokia.com>
In-Reply-To: <4D831AEF.3020109@nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103181001.17308.arnd@arndb.de>
X-Provags-ID: V02:K0:4zGcB8u5MrD3YsLvAVdhtmpAE/aqEcJdjKrd6hhPuBH
 QGr3DhWAL9SlBP7evo0rZrbEHatyUk2LNc8SzrlcmGQPLGcz30
 O+9kI2pLUQt6xeFRYh0bNQ54bWR1nF/m9OOsWNf7j5b8RFMgZi
 WvbC08rgGUisWloKAUdQBabhCa30dhYmp0NPxH1rtSd2j5Iv/l
 T8/klq56QuSNCuPX9VKpA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 March 2011, Roger Quadros wrote:
> Just curious, how do Panda boards manage to get the MAC address? Is it
> programmed in some other flash memory?
> 
> The LAN9514 datasheet says
> "If a properly configured EEPROM is not detected, it is the
> responsibility of the Host LAN Driver to set the IEEE addresses."
> 
> So how does the Host LAN driver know what MAC address it should use?

This is the problem we're trying to work out. The EEPROM is not
present, and user space has no way of knowing which MAC address
to set to which device. Note that there might be multiple
USB devices of the same type that are indistinguishable to user
space, so setting the MAC address there would not be completely
safe.

	Arnd
