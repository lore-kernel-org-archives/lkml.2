Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756030Ab2DORHy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 13:07:54 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:37218 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755836Ab2DORHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 13:07:53 -0400
Message-ID: <4F8B2A9E.7060304@xenotime.net>
Date: Sun, 15 Apr 2012 13:07:58 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: reasonable for a Kconfig variable to be tested only for "_MODULE"?
References: <alpine.DEB.2.02.1204120725070.17806@oneiric>
In-Reply-To: <alpine.DEB.2.02.1204120725070.17806@oneiric>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2012 04:30 AM, Robert P. J. Day wrote:

> 
>   playing with my cleanup scripts this morning and ran across this
> output looking for unused CONFIG_ variables under drivers/ata:
> 
> $ ../s/find_unused_configs.sh drivers/ata
> ===== PATA_QDI
> drivers/ata/Kconfig:831:config PATA_QDI
> ===== PATA_WINBOND_VLB
> drivers/ata/Kconfig:865:config PATA_WINBOND_VLB
> $
> 
>   normally, i would flag that as "variables that are defined in a
> Kconfig file but are never tested anywhere", but upon further
> examination:
> 
> $ $ grep -r PATA_QDI *
> drivers/ata/Kconfig:config PATA_QDI
> drivers/ata/pata_legacy.c:#ifdef CONFIG_PATA_QDI_MODULE
> $
> 
> so "CONFIG_PATA_QDI" isn't tested, but "CONFIG_PATA_QDI_MODULE" *is*,
> which is not something i'd considered.  the Kconfig entry:
> 
> config PATA_QDI
>         tristate "QDI VLB PATA support"
>         depends on ISA
>         select PATA_LEGACY
>         help
>           Support for QDI 6500 and 6580 PATA controllers on VESA local bus.
> 
> and the relevant source:
> 
> /* Set to probe QDI controllers */
> #ifdef CONFIG_PATA_QDI_MODULE
> static int qdi = 1;
> #else
> static int qdi;
> #endif
> 
>   is that combination reasonable?  to test *only* for
> "CONFIG_whatever_MODULE"?  if it is, i'll add that check to avoid
> reporting false positives.

Yes, sometimes modules want to behave differently (e.g., initialize
differently) if they are built as a loadable module.
I've seen this other places.


>   all of the above can be said for PATA_WINBOND_VLB as well.
> 
> rday
> 



-- 
~Randy
