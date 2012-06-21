Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758681Ab2FUGEq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 02:04:46 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:1533 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758618Ab2FUGEk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 02:04:40 -0400
X-Server-Uuid: 4500596E-606A-40F9-852D-14843D8201B2
Message-ID: <4FE2B96F.9000003@broadcom.com>
Date: Thu, 21 Jun 2012 08:04:31 +0200
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430
 Thunderbird/12.0.1
MIME-Version: 1.0
To: "Stephen Rothwell" <sfr@canb.auug.org.au>
cc: "John W. Linville" <linville@tuxdriver.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Pieter-Paul Giesberts" <pieterpg@broadcom.com>,
        "Franky (Zhenhui) Lin" <frankyl@broadcom.com>
Subject: Re: linux-next: build failure after merge of the final tree
 (wireless-next tree related)
References: <20120621155911.713748370d898a113e054693@canb.auug.org.au>
In-Reply-To: <20120621155911.713748370d898a113e054693@canb.auug.org.au>
X-Enigmail-Version: 1.5pre
X-WSS-ID: 63FC66C250S2417571-01-01
Content-Type: text/plain;
 charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/2012 07:59 AM, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the final tree, today's linux-next build (powerpc 
> allyesconfig) failed like this:
> 
> drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c: In function
> 'brcmf_sdio_dump_console': 
> drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c:3085:3: error:
> implicit declaration of function 'vzalloc'
> [-Werror=implicit-function-declaration] 
> drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c:3085:10:
> warning: assignment makes pointer from integer without a cast
> [enabled by default] 
> drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c:3113:2: error:
> implicit declaration of function 'vfree'
> [-Werror=implicit-function-declaration]
> 
> Caused by commit 4fc0d0160d59 ("brcmfmac: introduce checkdied
> debugfs functionality") from the wireless-next tree. Forgot to
> include vmalloc.h ?

That seems the likely problem.

> I have reverted that commit for today.

I will fix it today.

Gr. AvS

