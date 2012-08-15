Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217Ab2HOIPj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 04:15:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32954 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751288Ab2HOIPg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 04:15:36 -0400
Date: Wed, 15 Aug 2012 10:15:29 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: =?ISO-8859-15?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org
Subject: Re: [PATCH 6/7] HID: picoLCD: disable version check during probe
In-Reply-To: <20120730213859.063173c1@neptune.home>
Message-ID: <alpine.LNX.2.00.1208151015220.7026@pobox.suse.cz>
References: <20120730213656.0a9f6d30@neptune.home> <20120730213859.063173c1@neptune.home>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jul 2012, Bruno Prémont wrote:

> Commit 4ea5454203d991ec85264f64f89ca8855fce69b0
> [HID: Fix race condition between driver core and ll-driver] introduced
> new locking around proce/remove functions that prevent any report/reply
> from hardware to reach driver until it returned from probe.
> 
> As such, the ask-reply way to checking picoLCD firmware version during
> probe is bound to timeout and let probe fail.
> 
> Disabling the check lets driver sucessfully probe again.
> 
> Signed-off-by: Bruno Prémont <bonbons@linux-vserver.org>
> ---
>  drivers/hid/hid-picolcd_core.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/hid/hid-picolcd_core.c b/drivers/hid/hid-picolcd_core.c
> index 2d7ef68..42d0791 100644
> --- a/drivers/hid/hid-picolcd_core.c
> +++ b/drivers/hid/hid-picolcd_core.c
> @@ -478,13 +478,13 @@ static int picolcd_probe_lcd(struct hid_device *hdev, struct picolcd_data *data)
>  {
>  	int error;
>  
> -	error = picolcd_check_version(hdev);
> +/*	error = picolcd_check_version(hdev);
>  	if (error)
>  		return error;
>  
>  	if (data->version[0] != 0 && data->version[1] != 3)
>  		hid_info(hdev, "Device with untested firmware revision, please submit /sys/kernel/debug/hid/%s/rdesc for this device.\n",
> -			 dev_name(&hdev->dev));
> +			 dev_name(&hdev->dev)); */

Please just remove it altogether, I don't see a reason to keep the 
commented-out code in the in-tree driver.

Once the locking mess is sorted out, we can re-introduce it again as 
necessary.

Thanks.

-- 
Jiri Kosina
SUSE Labs
