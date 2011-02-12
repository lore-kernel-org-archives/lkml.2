Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752910Ab1BLIeY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Feb 2011 03:34:24 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:62263 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801Ab1BLIeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Feb 2011 03:34:16 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Chuanxiao Dong <chuanxiao.dong@intel.com>
Subject: Re: [PATCH v4 2/3]mmc: enable TRIM/ERASE caps for SDHCI host
Date: Sat, 12 Feb 2011 09:34:04 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc2+; KDE/4.5.1; x86_64; ; )
Cc: linux-mmc@vger.kernel.org, cjb@laptop.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, adrian.hunter@nokia.com
References: <20110212062220.GC25519@intel.com>
In-Reply-To: <20110212062220.GC25519@intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102120934.04679.arnd@arndb.de>
X-Provags-ID: V02:K0:E4R35Sndl4dQN+4Jft1tYBQ8Ckawkhkwjf/0X5fRjKB
 0vgundg1q07tABbRUHu4PRBFL6X3yd3d0stS3gAaO9yFE1/6qO
 zeNe11AkNUF6S7HynvOa9XeNA22qrrcmiyDNiZAAR9i9GS/Io6
 tzkw71BNUs6orYUERfp8vLvA78gR3/xPZ/1ZaSizRPKerF92wT
 UtaH0Fgt7/9WLR2fifvZg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 12 February 2011 07:22:20 Chuanxiao Dong wrote:
> SDHCI host controller has TRIM/ERASE capability, enable these caps for erasing
> purpose.
> 
> ERASE command needs R1B response. So for such command with busy signal, before
> sending command, SDHCI host driver will simply set a maximum value for timeout
> control register which is safe to use.
> 
> Signed-off-by: Chuanxiao Dong <chuanxiao.dong@intel.com>

Great stuff! I needed this for a project of mine, but couldn't
get it to work reliably without knowing about the timeout logic.

I think, almost no mmc controllers advertice MMC_CAP_ERASE today,
which is a real shame, given that it's extremely useful for performance.

	Arnd
