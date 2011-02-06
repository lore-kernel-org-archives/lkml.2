Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751688Ab1BFHZd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 02:25:33 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43985 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474Ab1BFHZb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 02:25:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=B24YVN75n2pkDPELJfd4YNUvanDk3NeCHLHhgWCFz6ng3i3PZimNE7uqQapDD4Idq5
         ZVquMRr7fjUsrvKpbCeMP1nkwL42g7bHF4rsb8o/yij0Zu3sW4fcgrQOzXsfcHIxRkl7
         uNRtPyf/3qsxknKxj2I0ZA9urwTWcTpbOjUzU=
MIME-Version: 1.0
In-Reply-To: <20110205093632.b76be846.randy.dunlap@oracle.com>
References: <201102042349.p14NnQEm025834@imap1.linux-foundation.org>
	<20110205093632.b76be846.randy.dunlap@oracle.com>
Date: Sun, 6 Feb 2011 09:25:28 +0200
Message-ID: <AANLkTikt=Ytey-n-YYGuXzJWNprEb-_zjuP5YjJGuvgK@mail.gmail.com>
Subject: Re: [PATCH -mmotm] staging/easycap: fix build when SND is not enabled
From: Tomas Winkler <tomasw@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: akpm@linux-foundation.org, rmthomas@sciolus.org,
        driverdevel <devel@driverdev.osuosl.org>,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 5, 2011 at 7:36 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
>
> Fix easycap build when CONFIG_SOUND is enabled but CONFIG_SND is
> not enabled.
>
> These functions are only built when CONFIG_SND is enabled, so the
> driver should depend on SND.
> This means that having SND enabled is required for the (obsolete)
> EASYCAP_OSS config option.

Actually SND enabled is needed when EASYCAP_OSS is NOT set.
I'm not sure, though how to force it in Kconfig,
I didn't want to use choice ALSA, OSS as the OSS will be removed later.

Unfortunately I cannot do something like
if EASYCAP_OSS == n
    select SND
endif

I will try to come with proper fix

Thanks
Tomas




>
> drivers/built-in.o: In function `easycap_usb_disconnect':
> easycap_main.c:(.text+0x2aba20): undefined reference to `snd_card_free'
> drivers/built-in.o: In function `easycap_alsa_probe':
> (.text+0x2b784b): undefined reference to `snd_card_create'
> drivers/built-in.o: In function `easycap_alsa_probe':
> (.text+0x2b78fb): undefined reference to `snd_pcm_new'
> drivers/built-in.o: In function `easycap_alsa_probe':
> (.text+0x2b7916): undefined reference to `snd_pcm_set_ops'
> drivers/built-in.o: In function `easycap_alsa_probe':
> (.text+0x2b795b): undefined reference to `snd_card_register'
> drivers/built-in.o: In function `easycap_alsa_probe':
> (.text+0x2b79d8): undefined reference to `snd_card_free'
> drivers/built-in.o: In function `easycap_alsa_probe':
> (.text+0x2b7a78): undefined reference to `snd_card_free'
> drivers/built-in.o: In function `easycap_alsa_complete':
> (.text+0x2b7e68): undefined reference to `snd_pcm_period_elapsed'
> drivers/built-in.o:(.data+0x2cae8): undefined reference to `snd_pcm_lib_ioctl'
>
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Cc: R.M. Thomas <rmthomas@sciolus.org>
> ---
>  drivers/staging/easycap/Kconfig |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- mmotm-2011-0204-1515.orig/drivers/staging/easycap/Kconfig
> +++ mmotm-2011-0204-1515/drivers/staging/easycap/Kconfig
> @@ -1,6 +1,6 @@
>  config EASYCAP
>        tristate "EasyCAP USB ID 05e1:0408 support"
> -       depends on USB && VIDEO_DEV && SOUND
> +       depends on USB && VIDEO_DEV && SND
>
>        ---help---
>          This is an integrated audio/video driver for EasyCAP cards with
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/devel
>
