Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756503Ab0IUHc2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 03:32:28 -0400
Received: from isrv.corpit.ru ([86.62.121.231]:49805 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753595Ab0IUHc0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 03:32:26 -0400
Message-ID: <4C985F88.1010501@msgid.tls.msk.ru>
Date: Tue, 21 Sep 2010 11:32:24 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.11) Gecko/20100805 Icedove/3.0.6
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: Jeff Garzik <jeff@garzik.org>, Pedro Francisco <pedrogfrancisco@gmail.com>,
        linux-kernel@vger.kernel.org,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: Re: [PATCH #upstream-fixes] ahci: fix module refcount breakage introduced
 by libahci split
References: <201009162256.04765.pedrogfrancisco@gmail.com> <47010.148.87.67.141.1284674336.squirrel@www.xenotime.net> <4C933A8F.2080305@gmail.com> <1284892106.2650.4.camel@sundae-v2> <4C9602E4.4090007@gmail.com> <1284974726.11757.9.camel@sundae-v2> <4C9729D7.70500@gmail.com>  <4C972C60.8010506@gmail.com> <1285015465.26023.10.camel@sundae-v2> <4C97DB80.4060403@gmail.com> <4C97DBE2.8070707@gmail.com> <4C984D44.1080109@msgid.tls.msk.ru> <4C985DFC.7020203@gmail.com>
In-Reply-To: <4C985DFC.7020203@gmail.com>
X-Enigmail-Version: 1.0.1
OpenPGP: id=804465C5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

21.09.2010 11:25, Tejun Heo wrote:
> libata depends on scsi_host_template for module reference counting and
> sht's should be owned by each low level driver.  During libahci split,
> the sht was left with libahci.ko leaving the actual low level drivers
> not reference counted.  This made ahci and ahci_platform always
> unloadable even while they're being actively used.
> 
> Fix it by defining AHCI_SHT() macro in ahci.h and defining a sht for
> each low level ahci driver.
> 
> stable: only applicable to 2.6.35.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-by: Michael Tokarev <mjt@tls.msk.ru>
> Cc: stable@kernel.org
> ---
> Michael, thanks a lot for spotting it and bearing with me.

Um.  All thanks goes to Pedro Francisco please, not to me -
I just verified your patch on my system, it was Pedro who spotted
and reported this.  You may add my

 Tested-Off-By: Michael Tokarev <mjt@tls.msk.ru>

, but not Reported-by... please ;)

Thanks!

/mjt
