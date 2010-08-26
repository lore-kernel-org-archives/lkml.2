Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312Ab0HZSWB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 14:22:01 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56218 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752341Ab0HZSV7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 14:21:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=esbVQsg5ClHN4PX0AqBIP9S31fQlfM2MW2Z7V6Sb4PyPEMK/cXuaJ4ZibvXatAzTgb
         G81+QXezpBE+OCdvacFUdH/01tFHeGhVqxZbKz8sX26cJUJNp2ZGk+Ki/Z38qE9FojTU
         3Gq1caLJPviDF5UnBKVs1LVqMBmYl38rybW8w=
MIME-Version: 1.0
In-Reply-To: <20100826164435.28668.25355.stgit@warthog.procyon.org.uk>
References: <20100826164435.28668.25355.stgit@warthog.procyon.org.uk>
From: Matt Turner <mattst88@gmail.com>
Date: Thu, 26 Aug 2010 14:21:38 -0400
Message-ID: <AANLkTi=J+MfSmheyfOy5cYAwCa0NeT2SmNDOEAu7d9g2@mail.gmail.com>
Subject: Re: [PATCH] Alpha: Fix a missing comma in sys_osf_statfs()
To: David Howells <dhowells@redhat.com>
Cc: hch@lst.de, torvalds@osdl.org, akpm@linux-foundation.com,
        viro@zeniv.linux.org.uk, linux-alpha@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 26, 2010 at 12:44 PM, David Howells <dhowells@redhat.com> wrote:
> Fix a comma that got accidentally deleted from sys_osf_statfs() leading to the
> following warning:
>
>        arch/alpha/kernel/osf_sys.c: In function 'SYSC_osf_statfs':
>        arch/alpha/kernel/osf_sys.c:255: error: syntax error before 'buffer'
>
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
>
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
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-alpha" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Thanks, but Michael Cree already sent an identical patch. I've just
been slow to vacuum it up and send it on to Linus. I'll do this ASAP.

Matt
