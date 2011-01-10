Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600Ab1AJUH6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 15:07:58 -0500
Received: from mms3.broadcom.com ([216.31.210.19]:1333 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754081Ab1AJUHz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 15:07:55 -0500
X-Server-Uuid: B55A25B1-5D7D-41F8-BC53-C57E7AD3C201
Date: Mon, 10 Jan 2011 12:07:44 -0800
From: "Henry Ptasinski" <henryp@broadcom.com>
To: "Ben Hutchings" <ben@decadent.org.uk>
cc: "David Woodhouse" <dwmw2@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Henry Ptasinski" <henryp@broadcom.com>
Subject: Re: [PATCH 1/2] brcm80211: Remove version number from
 filenames, matching the driver
Message-ID: <20110110200744.GA6933@broadcom.com>
References: <1294527372.3283.43.camel@localhost>
 <1294527461.3283.45.camel@localhost>
MIME-Version: 1.0
In-Reply-To: <1294527461.3283.45.camel@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-WSS-ID: 6135B8D01VG3463473-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 08, 2011 at 02:57:41PM -0800, Ben Hutchings wrote:
> The driver generates filenames like this:
> 
>                 sprintf(fw_name, "%s-%d.fw", wl_firmwares[i],
>                         UCODE_LOADER_API_VER);
>                 ...
>                 sprintf(fw_name, "%s_hdr-%d.fw", wl_firmwares[i],
>                         UCODE_LOADER_API_VER);
> 
> which implies the filenames should be:
> 
>     brcm/bcm43xx-0.fw
>     brcm/bcm43xx_hdr-0.fw
> 
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
>  WHENCE                          |    5 +++--
>  brcm/bcm43xx-0-610-809-0.fw     |  Bin 97376 -> 0 bytes
>  brcm/bcm43xx-0.fw               |  Bin 0 -> 97376 bytes
>  brcm/bcm43xx_hdr-0-610-809-0.fw |  Bin 180 -> 0 bytes
>  brcm/bcm43xx_hdr-0.fw           |  Bin 0 -> 180 bytes
>  5 files changed, 3 insertions(+), 2 deletions(-)
>  delete mode 100644 brcm/bcm43xx-0-610-809-0.fw
>  create mode 100644 brcm/bcm43xx-0.fw
>  delete mode 100644 brcm/bcm43xx_hdr-0-610-809-0.fw
>  create mode 100644 brcm/bcm43xx_hdr-0.fw
> 
> diff --git a/WHENCE b/WHENCE
> index 0bc162c..cec7478 100644
> --- a/WHENCE
> +++ b/WHENCE
> @@ -1403,8 +1403,9 @@ Licence:
>  
>  Driver: brcm80211 - Broadcom 802.11n wireless LAN driver.
>  
> -File: brcm/bcm43xx-0-610-809-0.fw
> -File: brcm/bcm43xx_hdr-0-610-809-0.fw
> +File: brcm/bcm43xx-0.fw
> +File: brcm/bcm43xx_hdr-0.fw
> +Version: 610.809.0
>  
>  Licence: Redistributable. See LICENCE.broadcom_bcm43xx for details.
>  
> [binary changes omitted]
> 

The brcmfmac files need renaming as well.  This patch (finally generated
with the -M flag) renames all the firmware files and fixes up the WHENCE:


>From 93e6654ddc60e92fa97726ce3e8acc8ab6ee9e11 Mon Sep 17 00:00:00 2001
From: Henry Ptasinski <henryp@broadcom.com>
Date: Mon, 10 Jan 2011 12:04:55 -0800
Subject: [PATCH] brcm: Removed codeversion from firmware filenames.

The basename-apiversion-codeversion construction for firmware filenames is not
used by most other firmware files, adds complexity, and is not providing any
value.  Renamed the firmware files using just basename-apiversion.  Also, fixed
WHENCE to have correct path to brcmfmac files.

Signed-off-by: Henry Ptasinski <henryp@broadcom.com>
---
 WHENCE                                             |   10 +++++-----
 ...llmac-4-218-248-5.bin => bcm4329-fullmac-4.bin} |  Bin 269595 -> 269595 bytes
 ...llmac-4-218-248-5.txt => bcm4329-fullmac-4.txt} |    0
 brcm/{bcm43xx-0-610-809-0.fw => bcm43xx-0.fw}      |  Bin 97376 -> 97376 bytes
 ...bcm43xx_hdr-0-610-809-0.fw => bcm43xx_hdr-0.fw} |  Bin 180 -> 180 bytes
 5 files changed, 5 insertions(+), 5 deletions(-)
 rename brcm/{bcm4329-fullmac-4-218-248-5.bin => bcm4329-fullmac-4.bin} (100%)
 rename brcm/{bcm4329-fullmac-4-218-248-5.txt => bcm4329-fullmac-4.txt} (100%)
 rename brcm/{bcm43xx-0-610-809-0.fw => bcm43xx-0.fw} (100%)
 rename brcm/{bcm43xx_hdr-0-610-809-0.fw => bcm43xx_hdr-0.fw} (100%)

diff --git a/WHENCE b/WHENCE
index d807e25..6e1c63f 100644
--- a/WHENCE
+++ b/WHENCE
@@ -1413,17 +1413,17 @@ Licence:
 
 Driver: brcm80211 - Broadcom 802.11n wireless LAN driver.
 
-File: brcm/bcm43xx-0-610-809-0.fw
-File: brcm/bcm43xx_hdr-0-610-809-0.fw
+File: brcm/bcm43xx-0.fw
+File: brcm/bcm43xx_hdr-0.fw
 
 Licence: Redistributable. See LICENCE.broadcom_bcm43xx for details.
 
 --------------------------------------------------------------------------
 
-Driver: brcm80211 - Broadcom 802.11n wireless LAN driver.
+Driver: brcmfmac - Broadcom 802.11n wireless LAN driver.
 
-File: bcm4329-fullmac-4-218-248-5.bin
-File: bcm4329-fullmac-4-218-248-5.txt
+File: brcm/bcm4329-fullmac-4.bin
+File: brcm/bcm4329-fullmac-4.txt
 
 Licence: Redistributable. See LICENCE.broadcom_bcm43xx for details.
 
diff --git a/brcm/bcm4329-fullmac-4-218-248-5.txt b/brcm/bcm4329-fullmac-4.txt
similarity index 100%
rename from brcm/bcm4329-fullmac-4-218-248-5.txt
rename to brcm/bcm4329-fullmac-4.txt
-- 
1.7.1



