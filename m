Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752299Ab0CVPKM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 11:10:12 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:36063 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838Ab0CVPKJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 11:10:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=bgT6grlPN9QheaSeeWNELexlif1M+Nb/8A4Tpf3VqEP/gIqEmv4jdTrKklJFKitXPr
         GEHe9YMqca02UWbIKBZbzNJi5YP94rhRGxDPsHJHwnXWKfOQIZjZPKUPezEmQH1b0M2B
         J4oZCR1FH0kT3bgAAgAdRck3wTj7SOcE5pKU4=
MIME-Version: 1.0
In-Reply-To: <201003221601.36559.linux@rainbow-software.org>
References: <201003221601.36559.linux@rainbow-software.org>
Date: Mon, 22 Mar 2010 16:10:07 +0100
Message-ID: <a32f33a41003220810r3da5a8d3mb4e884fdef03eb89@mail.gmail.com>
Subject: Re: [rt2x00-users] [PATCH RFC] rt2500usb: disable broken HW 
	encryption by default
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: rt2x00 Users List <users@rt2x00.serialmonkey.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 22, 2010 at 4:01 PM, Ondrej Zary <linux@rainbow-software.org> wrote:
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
>
> --- linux-2.6.34-rc2-orig/drivers/net/wireless/rt2x00/rt2500usb.c       2010-03-20 02:17:57.000000000 +0100
> +++ linux-2.6.34-rc2/drivers/net/wireless/rt2x00/rt2500usb.c    2010-03-22 15:40:39.000000000 +0100
> @@ -36,11 +36,11 @@
>  #include "rt2500usb.h"
>
>  /*
> - * Allow hardware encryption to be disabled.
> + * Allow hardware encryption to be enabled.
>  */
> -static int modparam_nohwcrypt = 0;
> -module_param_named(nohwcrypt, modparam_nohwcrypt, bool, S_IRUGO);
> -MODULE_PARM_DESC(nohwcrypt, "Disable hardware encryption.");
> +static int modparam_hwcrypt = 0;
> +module_param_named(hwcrypt, modparam_hwcrypt, bool, S_IRUGO);
> +MODULE_PARM_DESC(hwcrypt, "Enable hardware encryption.");

Large patch for something which can be done much simpler. How about:

static int modparam_nohwcrypt = 1

That way the module parameter does not have to be renamed, so current
configurations and documentation do not have to be changed. The name
remains consistent with the other rt2x00 modules (and the other
mac80211 modules for that matter).

But I though it was mentioned that disabling HW crypto didn't solve
the issue due to a second bug in a later kernel?

Ivo
