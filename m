Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935758Ab2JYOI3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 10:08:29 -0400
Received: from multi.imgtec.com ([194.200.65.239]:7319 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935708Ab2JYOI0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 10:08:26 -0400
Message-ID: <5089479F.6070608@imgtec.com>
Date: Thu, 25 Oct 2012 15:07:27 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Jonas Bonn <jonas@southpole.se>
CC: Arnd Bergmann <arnd@arndb.de>, <linux-arch@vger.kernel.org>,
        <linux@openrisc.net>, <linux-kernel@vger.kernel.org>,
        <uclinux-dist-devel@blackfin.uclinux.org>,
        <linux-xtensa@linux-xtensa.org>, Chris Zankel <chris@zankel.net>,
        Max Filippov <jcmvbkbc@gmail.com>,
        "Mike Frysinger" <vapier@gentoo.org>,
        Chen Liqin <liqin.chen@sunplusct.com>, Lennox Wu <lennox.wu@gmail.com>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>
Subject: Re: [PATCH] asm-generic/io.h: remove asm/cacheflush.h include
References: <1350984117-17369-1-git-send-email-james.hogan@imgtec.com> <1351172416.6232.70.camel@jerome.southpole.se>
In-Reply-To: <1351172416.6232.70.camel@jerome.southpole.se>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2012_10_25_15_08_13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 25/10/12 14:40, Jonas Bonn wrote:
> On Tue, 2012-10-23 at 10:21 +0100, James Hogan wrote:
>> Including <asm/cacheflush.h> from <asm-generic/io.h> prevents 
>> cacheflush.h being able to use I/O functions like readl and
>> writel due to circular include dependencies. It doesn't appear as
>> if anything from cacheflush.h is actually used by the generic
>> io.h, so remove the include.
>> 
>> I've compile tested a defconfig compilation of blackfin, openrisc
>> (which needed <asm/pgtable.h> including from it's <asm/io.h> to
>> get the PAGE_* definitions), and xtensa.
>> 
>> Other architectures which use asm-generic/io.h are score and
>> unicore32, and looking at their io.h I don't see any obvious
>> problems.
> 
> Acked-by: Jonas Bonn <jonas@southpole.se> for OpenRISC

Thanks Jonas

> Who's tree should this go via.  I can take it via the openrisc
> tree, but it would be good to get some Ack's that this isn't going
> to break things for the other arch's (in particular score and
> unicore32, since they are untested).

Yeh I'd like some acks from score and unicore32 if possible, since I
didn't notice I needed the openrisc bit until I tried compiling it.

Cheers
James
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQiUefAAoJEKHZs+irPybfly0P/3RZDS5sxivx513plCPNMucV
rXmZnEGh87Iw9c8htjV0WFH5dAtmUQ88wkExGEWPdK57AYhMLwKN+soycq3XGS6E
156EFDpp602K9bwZ5bTodJco2FalaQrUh+GQqWOBGhi0NPwnt0pwEpUC/F5Vn71d
rekQ9er/fKWhF74ONKh+/K3fSTHl6/S2Krt3izsPH9a+7aYpWNVNvfrhyS43A+AR
xa3tE0Q5sHvaRTYp+42p/7CHwOzAerXs3Cvp7QYrwErV8cB6IvkVh+b7RYkawYAq
czVIjbi45ouJlRek7EO3ZlcDFtiuoQZxzdVDNUwMuKWv7e9ASQ1StTHbh67DDlGK
cZsFMnuO0ddkdzs8ya/HWdA9+hZmrigPmst4rKUvM4idJ/N7zpO4G74fCwVDLng1
GIUrPrZTbcgpZyGepJfH9jGmwRJBcS8nYiep3quz21p3oGafeIVdv7WsPcHC0/HA
BOW2NcGDihtiJjooVWAiRhEPO4jxBCpY187YuoKJXCFdm5CfJ7ZdCIjeEt/cWVQs
yNfoGeVtHgRxKEJFsKAIto92iT18JY0qZWJL7WAqFDD4qB13RmJbmUOE4LCChFKK
Jui/Fi46j6uWdau6mujMlYKx3RMHjB/Lw09WRL78gEB6JaxpzVh4iShu4BI8G50P
Ye3bZ/gyfOLBRBky14FJ
=xH4e
-----END PGP SIGNATURE-----

