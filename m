Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727Ab0CVPlA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 11:41:00 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:40052 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062Ab0CVPk7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 11:40:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=oNDUxWEhqX2nHIkvu+BvqRkJY+VJQa0ek/Dm6MSnYLeGOtDIAHDu/UVHZjvliTm8JI
         XrrwfZqnKtpqX4ArysiUzYygeVpfK9Al+2wV5LPw2C3F13lQU+9yBRPQrnFgt3f9DxCS
         OzBRYnUqtHBmnYlzjTmEnCSEu25slafXtUHfM=
MIME-Version: 1.0
In-Reply-To: <201003221630.47510.linux@rainbow-software.org>
References: <201003221601.36559.linux@rainbow-software.org>
	 <a32f33a41003220810r3da5a8d3mb4e884fdef03eb89@mail.gmail.com>
	 <201003221630.47510.linux@rainbow-software.org>
Date: Mon, 22 Mar 2010 16:40:57 +0100
Message-ID: <a32f33a41003220840p7e3c3ba5j70d85950e4646b3c@mail.gmail.com>
Subject: Re: [rt2x00-users] [PATCH RFC] rt2500usb: disable broken HW 
	encryption by default
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: rt2x00 Users List <users@rt2x00.serialmonkey.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> But I though it was mentioned that disabling HW crypto didn't solve
>> the issue due to a second bug in a later kernel?
>
> That was a false positive. Probably because the device was not unplugged
> between the tests (and looks like the driver does not initialize the chip completely).
> It's not reliable, it sometimes stops working after reboot.

Ah well that at least simplifies the problem. I'll have to retest rt2500usb soon
to see why the HW crypto failed. I am sure I had it working for WEP,
WPA and WPA2
before I submitted the patch.

> Since HW encryption was added to rt2500usb in 2.6.29, the driver does not
> work. It has been discussed before but never solved:
> http://rt2x00.serialmonkey.com/phpBB/viewtopic.php?f=4&t=4834
> https://bugzilla.redhat.com/show_bug.cgi?id=484888
>
> The problem is caused by this patch:
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=dddfb478b26e29a2b47f655ec219e743b8111015
>
> Disable HW encryption by default to fix it.
>
> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
>
> --- linux-2.6.34-rc2-orig/drivers/net/wireless/rt2x00/rt2500usb.c       2010-03-20 02:17:57.000000000 +0100
> +++ linux-2.6.34-rc2/drivers/net/wireless/rt2x00/rt2500usb.c    2010-03-22 16:16:55.000000000 +0100
> @@ -36,11 +36,11 @@
>  #include "rt2500usb.h"
>
>  /*
> - * Allow hardware encryption to be disabled.
> + * Allow hardware encryption to be enabled.
>  */
> -static int modparam_nohwcrypt = 0;
> +static int modparam_nohwcrypt = 1;
>  module_param_named(nohwcrypt, modparam_nohwcrypt, bool, S_IRUGO);
> -MODULE_PARM_DESC(nohwcrypt, "Disable hardware encryption.");
> +MODULE_PARM_DESC(nohwcrypt, "Hardware encryption disabled by default, use nohwcrypt=0 to enable.");

Actually could you just change the default value and nothing else?
The meaning of the module parameter doesn't change. So the Module
parameter description doesn't need to be updated as far as I am
concerned

Thanks,

Ivo
