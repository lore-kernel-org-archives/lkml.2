Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933769Ab1AMUkk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 15:40:40 -0500
Received: from webmail.exar.com ([204.154.183.83]:55076 "EHLO smtp1.exar.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757421Ab1AMUkc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 15:40:32 -0500
X-Greylist: delayed 316 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Jan 2011 15:40:32 EST
From: Ramkrishna Vepa <Ramkrishna.Vepa@exar.com>
To: Jesper Juhl <jj@chaosbits.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jon Mason <Jon.Mason@exar.com>,
        Sivakumar Subramani <Sivakumar.Subramani@exar.com>,
        Sreenivasa Honnur <Sreenivasa.Honnur@exar.com>
Date: Thu, 13 Jan 2011 12:35:14 -0800
Subject: RE: [PATCH] vxge: Remember to release firmware after upgrading
 firmware {nodisc}
Thread-Topic: [PATCH] vxge: Remember to release firmware after upgrading
 firmware {nodisc}
Thread-Index: AcuzYAJIm1fBKj/iRiScw9wHn3KDrAAAPpUg
Message-ID: <FCA91A92EE52B041906A0358FC28FCC38EFB6B2F34@FRE1EXCH02.hq.exar.com>
References: <alpine.LNX.2.00.1101132119080.11347@swampdragon.chaosbits.net>
In-Reply-To: <alpine.LNX.2.00.1101132119080.11347@swampdragon.chaosbits.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Regardless of whether the firmware update being performed by
> vxge_fw_upgrade() is a success or not we must still remember to always
> release_firmware() before returning.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  vxge-main.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/vxge/vxge-main.c b/drivers/net/vxge/vxge-main.c
> index 1ac9b56..c81a651 100644
> --- a/drivers/net/vxge/vxge-main.c
> +++ b/drivers/net/vxge/vxge-main.c
> @@ -4120,6 +4120,7 @@ int vxge_fw_upgrade(struct vxgedev *vdev, char
> *fw_name, int override)
>  	       "hotplug event.\n");
> 
>  out:
> +	release_firmware(fw);
>  	return ret;
>  }
Thanks!

Acked-by: Ram Vepa <ram.vepa@exar.com>
