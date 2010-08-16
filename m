Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068Ab0HPNHM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 09:07:12 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57884 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740Ab0HPNHK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 09:07:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=xbOq9aSXYNq8Xd45D5wvZubCYctUXvY+BnRlxMA3yfuuaSFvnljW8UwbYMP6bUd8kJ
         rs2B9NiWhj6VY4Qv6fOQOIWHAsDsURCnPi70m/LolAOkqanbbB7a5icOE7vXKj6Xaw2U
         HLXdqGUCe6VGx9C+xrHdUZwsmttzZG7kwaApo=
MIME-Version: 1.0
In-Reply-To: <1281946680-23497-1-git-send-email-mcree@orcon.net.nz>
References: <1281946680-23497-1-git-send-email-mcree@orcon.net.nz>
From: Matt Turner <mattst88@gmail.com>
Date: Mon, 16 Aug 2010 09:06:49 -0400
Message-ID: <AANLkTi=bbu2HSzZTc5_aBeS_emoXB0YO4KUSgwwTEnuH@mail.gmail.com>
Subject: Re: [PATCH] alpha: Fix compile error due to typo in call of do_osf_statfs()
To: Michael Cree <mcree@orcon.net.nz>
Cc: linux-kernel@vger.kernel.org, Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@lst.de>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-alpha@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 16, 2010 at 4:18 AM, Michael Cree <mcree@orcon.net.nz> wrote:
> Typo, i.e., missing comma in argument list of call of do_osf_statfs(),
> was introduced by commit ebabe9a9001af0af56c0c2780ca1576246e7a74b.
>
> Signed-off-by: Michael Cree <mcree@orcon.net.nz>
> ---
>  arch/alpha/kernel/osf_sys.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/arch/alpha/kernel/osf_sys.c b/arch/alpha/kernel/osf_sys.c
> index fb58150..5d1e6d6 100644
> --- a/arch/alpha/kernel/osf_sys.c
> +++ b/arch/alpha/kernel/osf_sys.c
> @@ -252,7 +252,7 @@ SYSCALL_DEFINE3(osf_statfs, const char __user *, pathname,
>
>        retval = user_path(pathname, &path);
>        if (!retval) {
> -               retval = do_osf_statfs(&path buffer, bufsiz);
> +               retval = do_osf_statfs(&path, buffer, bufsiz);
>                path_put(&path);
>        }
>        return retval;
> --
> 1.7.1

Thanks Michael. Will apply.
