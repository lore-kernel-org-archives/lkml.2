Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313Ab2LQPah (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 10:30:37 -0500
Received: from mail-qa0-f53.google.com ([209.85.216.53]:45847 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665Ab2LQPaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 10:30:35 -0500
MIME-Version: 1.0
In-Reply-To: <1355737085-6671-1-git-send-email-bp@alien8.de>
References: <1355737085-6671-1-git-send-email-bp@alien8.de>
Date: Mon, 17 Dec 2012 09:30:33 -0600
Message-ID: <CAH2r5mt=4ZoGR_4hP52uHsZabXpPfh1sa1X0GSg6W4=fawNFnA@mail.gmail.com>
Subject: Re: [PATCH] cifs: Do not enable debugging code by default
From: Steve French <smfrench@gmail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Joe Perches <joe@perches.com>,
        Jeff Layton <jlayton@redhat.com>, Steve French <sfrench@samba.org>,
        linux-cifs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't think taking out debugging makes sense - we need debugging a
lot more often than expected even to diagnose user errors (usually
relating to session establishment failures, since we are very limited
in how much information can be passed back in mount).   If we had
dynamic trace points for cifs and for common vfs entry points, or if
the distros shipped dual cifs modules (one with debugging and one
without), I wouldn't mind disabling it - but multiple times a month we
have to diagnose user problems (sometimes user errors, sometimes
server bugs etc.) by enabling debugging.

On Mon, Dec 17, 2012 at 3:38 AM, Borislav Petkov <bp@alien8.de> wrote:
> Debugging code is generally disabled in the configurator since it is
> only for devs and testers and not for the majority of the installations.
>
> Cc: Joe Perches <joe@perches.com>
> Cc: Jeff Layton <jlayton@redhat.com>
> Cc: Steve French <sfrench@samba.org>
> Cc: linux-cifs@vger.kernel.org
> Signed-off-by: Borislav Petkov <bp@alien8.de>
> ---
>  fs/cifs/Kconfig | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/fs/cifs/Kconfig b/fs/cifs/Kconfig
> index 21ff76c22a17..241a0e2853c5 100644
> --- a/fs/cifs/Kconfig
> +++ b/fs/cifs/Kconfig
> @@ -124,7 +124,6 @@ config CIFS_ACL
>
>  config CIFS_DEBUG
>         bool "Enable CIFS debugging routines"
> -       default y
>         depends on CIFS
>         help
>            Enabling this option adds helpful debugging messages to
> --
> 1.8.1.rc2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,

Steve
