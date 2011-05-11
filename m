Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908Ab1EKRaq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 13:30:46 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49570 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753754Ab1EKRam convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 13:30:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=d0rnT2f1QqhKharQFD2KcxwIT8+ghvFYZuIvJoiRuvUpwuZU1cGKgbVtY03wGwXyzG
         EdjCXqWw+K5OUNGiUIgWEcMcdIBo3TOoe1Ne7ji6Qlc1cf04Y14Sb1vdU5JhZyITlGz7
         6T1RquPVKEzxyVdOF+kUFFcAQigEfgyMWTRaA=
MIME-Version: 1.0
In-Reply-To: <1303837564-18062-1-git-send-email-rabin@rab.in>
References: <1303837564-18062-1-git-send-email-rabin@rab.in>
From: Rabin Vincent <rabin@rab.in>
Date: Wed, 11 May 2011 23:00:01 +0530
X-Google-Sender-Auth: mz5RZSEtNeXt3vaSuxIMLuBzap4
Message-ID: <BANLkTimLre+UY1fY6+HXEsJicyh_oMnWdA@mail.gmail.com>
Subject: Re: [PATCH] kbuild: make KBUILD_NOCMDDEP=1 handle empty built-in.o
To: mmarek@suse.cz
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        Rabin Vincent <rabin@rab.in>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 26, 2011 at 22:36, Rabin Vincent <rabin@rab.in> wrote:
> Fix building with KBUILD_NOCMDDEP=1, which currently does not work
> because it does not build built-in.o with no dependencies:
>
>  LD      fs/notify/built-in.o
> ld: cannot find fs/notify/dnotify/built-in.o: No such file or directory
> ld: cannot find fs/notify/inotify/built-in.o: No such file or directory
> ld: cannot find fs/notify/fanotify/built-in.o: No such file or directory
>
> Signed-off-by: Rabin Vincent <rabin@rab.in>

Any comments on this patch?  I found KBUILD_NOCMDDEP useful
when hunting down a bug that appeared only in a certain compiler
version.  Used it to build some files using one compiler and the rest
using the other.  It would be nice if it worked out of the box; it will
after this patch.

> ---
>  scripts/Kbuild.include |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
>
> diff --git a/scripts/Kbuild.include b/scripts/Kbuild.include
> index ed2773e..fd31781 100644
> --- a/scripts/Kbuild.include
> +++ b/scripts/Kbuild.include
> @@ -187,6 +187,10 @@ ifneq ($(KBUILD_NOCMDDEP),1)
>  # User may override this check using make KBUILD_NOCMDDEP=1
>  arg-check = $(strip $(filter-out $(cmd_$(1)), $(cmd_$@)) \
>                     $(filter-out $(cmd_$@),   $(cmd_$(1))) )
> +else
> +# Ensure that files with no dependencies are built.
> +built-check = $(filter $(origin cmd_$@), undefined)
> +arg-check = $(if $(strip $(obj-y)),,$(built-check))
>  endif
>
>  # >'< substitution is for echo to work,
> --
> 1.7.4.1
>
>
