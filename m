Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064Ab2EVH4Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 03:56:16 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:35141 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582Ab2EVH4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 03:56:15 -0400
Message-ID: <4FBB469B.50801@suse.cz>
Date: Tue, 22 May 2012 09:56:11 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120514 Thunderbird/14.0a2
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>
CC: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb-hid-core: Set intfdata to NULL if probe fails
References: <1337629176-1624-1-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1337629176-1624-1-git-send-email-hdegoede@redhat.com>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/21/2012 09:39 PM, Hans de Goede wrote:
> other drivers which rely on frameworks which only call dev_set_drvdata
> on the interface's device if no drvdata has been set

This looks very broken as it relies on an undocumented behavior. If they
want to do that they should:
* set intfdata to NULL
* call some hook that may set intfdata
* set intfdata to whatever they want if it is still NULL

Right?

What are those frameworks?

> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> ---
>  drivers/hid/usbhid/hid-core.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
> index 5bf91db..70d760f 100644
> --- a/drivers/hid/usbhid/hid-core.c
> +++ b/drivers/hid/usbhid/hid-core.c
> @@ -1296,6 +1296,7 @@ err_free:
>  	kfree(usbhid);
>  err:
>  	hid_destroy_device(hid);
> +	usb_set_intfdata(intf, NULL);
>  	return ret;
>  }
>  
> 
-- 
js
suse labs

