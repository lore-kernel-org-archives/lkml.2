Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113Ab2AWFtc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 00:49:32 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:54396 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300Ab2AWFta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 00:49:30 -0500
Message-ID: <4F1CF4DE.5090207@linux.vnet.ibm.com>
Date: Mon, 23 Jan 2012 11:19:18 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
CC: rjw@sisk.pl, linux-kernel <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>
Subject: Re: [PATCH 3.3-rc1] PM / Sleep: Fix read_unlock_usermodehelper()
 call.
References: <201201230449.q0N4npAa029457@www262.sakura.ne.jp>
In-Reply-To: <201201230449.q0N4npAa029457@www262.sakura.ne.jp>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
x-cbid: 12012220-3568-0000-0000-0000011BF5FB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23/2012 10:19 AM, Tetsuo Handa wrote:

> Commit b298d289
>  "PM / Sleep: Fix freezer failures due to racy usermodehelper_is_disabled()"
> added read_unlock_usermodehelper() but read_unlock_usermodehelper() is called
> without read_lock_usermodehelper() when kmalloc() failed.
> 
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> -----


Acked-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Thanks for catching this!
Regards,
Srivatsa S. Bhat

> diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
> index 26ab358..6c9387d 100644
> --- a/drivers/base/firmware_class.c
> +++ b/drivers/base/firmware_class.c
> @@ -525,8 +525,7 @@ static int _request_firmware(const struct firmware **firmware_p,
>  	if (!firmware) {
>  		dev_err(device, "%s: kmalloc(struct firmware) failed\n",
>  			__func__);
> -		retval = -ENOMEM;
> -		goto out;
> +		return -ENOMEM;
>  	}
> 
>  	if (fw_get_builtin_firmware(firmware, name)) {
> 

