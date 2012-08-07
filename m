Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756624Ab2HGUvk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 16:51:40 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:56277 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756431Ab2HGUvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 16:51:38 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 0/5] mfd: replace IORESOURCE_IO by IORESOURCE_MEM
Date: Tue, 7 Aug 2012 20:51:25 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Russell King <rmk@arm.linux.org.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>, sameo@linux.intel.com,
        rpurdie@rpsys.net, bryan.wu@canonical.com,
        linux-kernel@vger.kernel.org
References: <20120806195352.GC16199@opensource.wolfsonmicro.com> <20120807115140.GH24257@flint.arm.linux.org.uk> <CAMuHMdUezhMNL19JUK9-uSqTr3=bU7yAci0ovFd5dSdksW1etQ@mail.gmail.com>
In-Reply-To: <CAMuHMdUezhMNL19JUK9-uSqTr3=bU7yAci0ovFd5dSdksW1etQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201208072051.25681.arnd@arndb.de>
X-Provags-ID: V02:K0:3jae7f4/l6Wp4mvLz/Yb+6O0VSntgLq0Tc0O++1bLT2
 AtK6fV7Sc+LUz5L8R4dv1KcIVLdWld+X7WV5PuatD0GgsWzbBX
 ypcPItHZBFeOSsI0opV3UNP90w8c4IpJhN4OcDDVVTtF0Ho/tD
 sLUDiAhUB+fL639Zcs6/JPYA4LQWC4inaULGg/7IBzp3OugPrJ
 qWPTyhBjMHd+wLjKPKdYsF1mh61xG/nUWTM9wCOsdthz4ngAbH
 LUZr0IktPv/gsB0dJsnBn8u1/q/pbxM3JQ3dHzE9BftDYg4YK6
 i/m2AcZtxpZLyA2UiP4Hd7WVGZOhIDxt2OODxsLpCXQwHASI/0
 yls5gQNrWlzdJK0yMw6Y=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 August 2012, Geert Uytterhoeven wrote:
>Don't you need an extra file in /proc, too (cfr. /proc/ioports and /proc/iomem)?
>
> And as Arnd pointed out, if resources will be used for various new buses,
> "IORESOURCE_FOO" or "IORESOURCE_OTHER" is a bit vague.
> What about conflicts where one driver means i2c addresses and another
> one means gpio addresses? The resource system will reject them?

The platform code currently only inserts the resources of type IO or
MEM. For the new type, we would not insert them to any resource
tree and they consequently are not available in any /proc file.

No driver should ever try to request access to those resources either.
The only thing we do with them is attach them to a platform device
in the mfd driver and take them out of it again in the child driver.

	Arnd
