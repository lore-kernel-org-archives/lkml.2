Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933284Ab2JTB5U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 21:57:20 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:56086 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759443Ab2JTB5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 21:57:19 -0400
X-AuditID: cbfee61a-b7f976d000001eb9-f7-508204fde86a
Message-id: <508204FC.4030802@samsung.com>
Date: Sat, 20 Oct 2012 10:57:16 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
MIME-version: 1.0
To: anish kumar <anish198519851985@gmail.com>
Cc: gregkh@linuxfoundation.org, myungjoo.ham@samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [PATCH] extcon: driver model release call not needed
References: <1350580326-1574-1-git-send-email-anish198519851985@gmail.com>
In-reply-to: <1350580326-1574-1-git-send-email-anish198519851985@gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGLMWRmVeSWpSXmKPExsVy+t9jAd2/LE0BBncaRS0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGx3X3mAsWcldsn7iKrYFxKWcXIweHhICJxMzDbl2MnECmmMSF
	e+vZuhi5OIQEFjFKfGw7wwzhdDFJbJ7xkx2kildAS+L45rNMIM0sAqoSnQ/0QcJsQOH9L26w
	gYRFBSIkfvVzQFQLSvyYfI8FJCwioCuxaWEKSJgZqGLSq8UsILawgKfEnkvHwYYLCXhJHN7x
	lg3E5hTwlvg9+wcLRL2OxP7WaWwQtrzE5jVvmScwCsxCsmEWkrJZSMoWMDKvYhRNLUguKE5K
	zzXUK07MLS7NS9dLzs/dxAgOvWdSOxhXNlgcYhTgYFTi4ZXoawwQYk0sK67MPcQowcGsJMK7
	dBFQiDclsbIqtSg/vqg0J7X4EKM0B4uSOG+zR0qAkEB6YklqdmpqQWoRTJaJg1OqgdGGv5bx
	fpjv3jdH7XUOvGMybvjixRjCuDuvqP6VqEkTd2Fc8UnzlX2u0216pBy+XpRaPSk23/WttpKv
	M8PHk/EnC/+H7nZxnpvQel99wcb79RX/6zSq7jCf6Lnvc1Vyr2vRzKCttvwVOyboqzWu39ih
	tTX59fRjR3tnCqbrPy05U/yrobg4SYmlOCPRUIu5qDgRAFs0BP05AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/2012 02:12 AM, anish kumar wrote:
> From: anish kumar <anish198519851985@gmail.com>
> 
> We don't need a release call in this file as we are doing
> everything needed in unregister call and we don't have any
> more pointer to free up.
> 
> Signed-off-by: anish kumar <anish198519851985@gmail.com>
> ---
>  drivers/extcon/extcon-class.c |    4 +---
>  1 files changed, 1 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/extcon/extcon-class.c b/drivers/extcon/extcon-class.c
> index 946a318..cf30eb1 100644
> --- a/drivers/extcon/extcon-class.c
> +++ b/drivers/extcon/extcon-class.c
> @@ -585,9 +585,7 @@ static void extcon_cleanup(struct extcon_dev *edev, bool skip)
>  
>  static void extcon_dev_release(struct device *dev)
>  {
> -	struct extcon_dev *edev = (struct extcon_dev *) dev_get_drvdata(dev);
> -
> -	extcon_cleanup(edev, true);
> +	/* We don't have any thing to free here */
>  }
>  
>  static const char *muex_name = "mutually_exclusive";

I can't agree this patch. The extcon_dev_release() function is used
for dev->release. If some case without calling extcon_dev_unregister(),
I think dev->release function is needed to free memory of edev->dev.

The edev->dev->release store the function pointer of extcon_dev_release()
in extcon_dev_register().
edev->dev->parent = dev;
edev->dev->class = extcon_class;
edev->dev->release = extcon_dev_release;


Thanks,
Chanwoo Choi
