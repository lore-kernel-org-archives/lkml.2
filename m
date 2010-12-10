Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248Ab0LJVgD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 16:36:03 -0500
Received: from mail-gx0-f180.google.com ([209.85.161.180]:41238 "EHLO
	mail-gx0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193Ab0LJVgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 16:36:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ttaKGTcFMGLv9dD805cMD5ztJP0x7osgkkCFEzhgYKGiT1NzFoj3ZMjqUZOV72VCzp
         PjtOCDVCVRGNU4b35YJ/1XZF8PhBTgj3eNFr6Yz4hoPGbQc34RbnprZj3fwfZ4hUG8aR
         0GzcKq09jlqxJXmGYZNlpb/PBEcRUiUym3yaM=
Date: Fri, 10 Dec 2010 13:35:51 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Azael Avalos <coproscefalo@gmail.com>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthew Garrett <mjg@redhat.com>
Subject: Re: [PATCH] toshiba_acpi: FULL TOS1900 device support
Message-ID: <20101210213551.GE1630@core.coreip.homeip.net>
References: <AANLkTimW5ro7EQBgoqMLSxnEsVrinL2S+USu207-Nbh=@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimW5ro7EQBgoqMLSxnEsVrinL2S+USu207-Nbh=@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Azael,

On Fri, Dec 10, 2010 at 02:13:18PM -0700, Azael Avalos wrote:
>  	error = input_register_device(toshiba_acpi.hotkey_dev);
>  	if (error) {
>  		printk(MY_INFO "Unable to register input device\n");
> -		goto err_remove_notify;
> +		 goto err_free_keymap;

Extra space in indentation.

>  	}
> 
>  	return 0;
> 
> - err_remove_notify:
> -	acpi_remove_notify_handler(toshiba_acpi.handle,
> -				   ACPI_DEVICE_NOTIFY, toshiba_acpi_notify);
> - err_free_keymap:
> -	sparse_keymap_free(toshiba_acpi.hotkey_dev);
> - err_free_dev:
> +err_free_keymap:
> +	if (toshiba_acpi.hci_type == 2)
> +		i8042_remove_filter(toshiba_i8042_filter);
> +err_free_dev:
>  	input_free_device(toshiba_acpi.hotkey_dev);
>  	toshiba_acpi.hotkey_dev = NULL;
>  	return error;

I do not actually see you calling sparse_keymap_free() in the error path
anymore.

Thanks.

-- 
Dmitry
