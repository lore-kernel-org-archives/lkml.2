Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726Ab1BHWYM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 17:24:12 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:21976 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753295Ab1BHWYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 17:24:10 -0500
Date: Tue, 8 Feb 2011 14:22:14 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, gregkh@suse.de, rmthomas@sciolus.org
Subject: Re: + staging-easycap-fix-build-when-snd-is-not-enabled.patch added
 to -mm tree
Message-Id: <20110208142214.3dc3fb8a.randy.dunlap@oracle.com>
In-Reply-To: <201102082135.p18LZbw3026826@imap1.linux-foundation.org>
References: <201102082135.p18LZbw3026826@imap1.linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4D51C266.01B2:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,
Please drop this patch.  Tomas Winkler has supplied a better one
which I have tested/acked.  (sent only to staging/driver-devel mailing list)


On Tue, 08 Feb 2011 13:35:37 -0800 akpm@linux-foundation.org wrote:

> 
> The patch titled
>      staging/easycap: fix build when SND is not enabled
> has been added to the -mm tree.  Its filename is
>      staging-easycap-fix-build-when-snd-is-not-enabled.patch
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
> 
> See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
> out what to do about this
> 
> The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/
> 
> ------------------------------------------------------
> Subject: staging/easycap: fix build when SND is not enabled
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix easycap build when CONFIG_SOUND is enabled but CONFIG_SND is
> not enabled.
> 
> These functions are only built when CONFIG_SND is enabled, so the
> driver should depend on SND.
> This means that having SND enabled is required for the (obsolete)
> EASYCAP_OSS config option.
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
> Cc: Greg KH <gregkh@suse.de>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  drivers/staging/easycap/Kconfig |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff -puN drivers/staging/easycap/Kconfig~staging-easycap-fix-build-when-snd-is-not-enabled drivers/staging/easycap/Kconfig
> --- a/drivers/staging/easycap/Kconfig~staging-easycap-fix-build-when-snd-is-not-enabled
> +++ a/drivers/staging/easycap/Kconfig
> @@ -1,6 +1,6 @@
>  config EASYCAP
>  	tristate "EasyCAP USB ID 05e1:0408 support"
> -	depends on USB && VIDEO_DEV && SOUND
> +	depends on USB && VIDEO_DEV && SND
>  
>  	---help---
>  	  This is an integrated audio/video driver for EasyCAP cards with
> _


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
