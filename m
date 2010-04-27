Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752228Ab0D0FyM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 01:54:12 -0400
Received: from mail-qy0-f179.google.com ([209.85.221.179]:59944 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077Ab0D0FyK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 01:54:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=L33TI1r9bKDj3BR/YKGMGhSjWRwJYIn+H5q+iPPmf9/Igd0fLzrFHM/O2PElElWeZV
         IsWiE0oOmmTOGfPPVfcnsUlzqqCdBDubGOQihC39vPJEm8K+EN7efpMyr8Fu3HM41XrH
         JngwM9H6QjPCq+qDjLGwNVG+hn5/gXt83UnBk=
MIME-Version: 1.0
In-Reply-To: <1272315374-11951-1-git-send-email-jason.wessel@windriver.com>
References: <1272315374-11951-1-git-send-email-jason.wessel@windriver.com>
Date: Tue, 27 Apr 2010 13:54:09 +0800
Message-ID: <p2p2375c9f91004262254v20e361aexf508b81350e03ec1@mail.gmail.com>
Subject: Re: [PATCH] Correctly deal with make that has an argument which 
	contains an "s"
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kbuild@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 27, 2010 at 4:56 AM, Jason Wessel
<jason.wessel@windriver.com> wrote:
> When using remake, which is based on gnumake, if you invoke
> an example build as shown below, the build will become silent
> due to the top level make file incorrectly guessing that
> the end user wants a silent build because an argument that
> contained an "s" was used.
>
> remake --no-extended-errors
>
> Fix up the top level Makefile to use filter with a list of
> options that mean silent with the various revisions of gnumake,
> instead of findstring.
>
> Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
> CC: Michal Marek <mmarek@suse.cz>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: linux-kbuild@vger.kernel.org


Acked-by: WANG Cong <xiyou.wangcong@gmail.com>

Thanks.


> ---
>  Makefile |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/Makefile b/Makefile
> index fa1db90..91ae299 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -294,7 +294,7 @@ endif
>  # If the user is running make -s (silent mode), suppress echoing of
>  # commands
>
> -ifneq ($(findstring s,$(MAKEFLAGS)),)
> +ifneq ($(filter s% -s% --silent --quiet,$(MAKEFLAGS)),)
>   quiet=silent_
>  endif
>
> --
> 1.6.3.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
