Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933775Ab1J1XC1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 19:02:27 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:11085 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932722Ab1J1XC0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 19:02:26 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-5.tower-132.messagelabs.com!1319842944!43425763!1
X-Originating-IP: [216.166.12.32]
X-StarScan-Version: 6.3.6; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>, "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "joe@perches.com" <joe@perches.com>,
        "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
        "jkosina@suse.cz" <jkosina@suse.cz>
Date: Fri, 28 Oct 2011 18:02:22 -0500
Subject: RE: [PATCH 3/3] Staging: hv: mousevsc: Use the KBUILD_MODNAME macro
Thread-Topic: [PATCH 3/3] Staging: hv: mousevsc: Use the KBUILD_MODNAME macro
Thread-Index: AcyVwElEjB2U8jNVRAOfq4V52gZOLAAAbvPg
Message-ID: <ADE657CA350FB648AAC2C43247A983F001F39DEE70F6@AUSP01VMBX24.collaborationhost.net>
References: <1319839847-28959-1-git-send-email-kys@microsoft.com>
	<1319839888-29000-1-git-send-email-kys@microsoft.com>
 <1319839888-29000-3-git-send-email-kys@microsoft.com>
In-Reply-To: <1319839888-29000-3-git-send-email-kys@microsoft.com>
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

On Friday, October 28, 2011 3:11 PM, K. Y. Srinivasan wrote:
> 
> Use the KBUILD_MODNAME macro.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> ---
>  drivers/staging/hv/hv_mouse.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/staging/hv/hv_mouse.c b/drivers/staging/hv/hv_mouse.c
> index c22f729..2c2e1b4 100644
> --- a/drivers/staging/hv/hv_mouse.c
> +++ b/drivers/staging/hv/hv_mouse.c
> @@ -578,7 +578,7 @@ static const struct hv_vmbus_device_id id_table[] = {
>  MODULE_DEVICE_TABLE(vmbus, id_table);
>  
>  static struct  hv_driver mousevsc_drv = {
> -	.name = "mousevsc",
> +	.name = KBUILD_MODNAME,
>  	.id_table = id_table,
>  	.probe = mousevsc_probe,
>  	.remove = mousevsc_remove,

It's just my opinion, but I'm not sure this is better.

By changing the name to KBUILD_MODNAME you can no longer grep the source to
find the driver based on it's name:

$ grep -r name * | grep mousevsc
drivers/staging/hv/hv_mouse.c:  .name = "mousevsc",

Also, doesn't this change the name of the driver from "mousevsc" to "hv_mouse"?
Does anything else need modified to handle the name change or is the matching
handled strictly by the id_table?

Regards,
Hartley

