Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933272Ab0JRXim (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 19:38:42 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39519 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932149Ab0JRXik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 19:38:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=SLWDxPPkIXk256lb0kLfZ7s+jS4k2pAZ/fzz4lM4WLis3IBjXXvJFLUjaUx2TIepqB
         aw8ybKMGrzsrUvqViho0vOo5PvWyNwpMVlBU4DqXam4rGHuZmI98KGU/GNf0KznSkPIg
         zGh34yZ4r229lkiQEIm0qltBWutTtRzEK7628=
Date: Tue, 19 Oct 2010 01:38:37 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Brian Gitonga Marete <marete@toshnix.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] [PERF] (Userspace Tools) Fix a compilation error with
	-fstack-protector and -Werror
Message-ID: <20101018233834.GC5370@nowhere>
References: <AANLkTinHc7tMntW5NFAhu40RC7m2=HwbqOBeE-21vL8J@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinHc7tMntW5NFAhu40RC7m2=HwbqOBeE-21vL8J@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 02:24:00AM +0300, Brian Gitonga Marete wrote:
> The following patch fixes compilation of the perf user-space tools on,
> for example, gcc version 4.3.3 (Ubuntu 4.3.3-5ubuntu4) . It should not
> break anything else.



Hi,

What kind of warning have you encountered and why it fixes it?
Can you describe that in your changelog?

Thanks.



> 
> Signed-off-by: Brian Gitonga Marete <marete@toshnix.com>
> ---
>  tools/perf/Makefile |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/tools/perf/Makefile b/tools/perf/Makefile
> index 1950e19..64eb2ea 100644
> --- a/tools/perf/Makefile
> +++ b/tools/perf/Makefile
> @@ -288,7 +288,7 @@ endif
>  -include feature-tests.mak
> 
>  ifeq ($(call try-cc,$(SOURCE_HELLO),-Werror -fstack-protector-all),y)
> -	CFLAGS := $(CFLAGS) -fstack-protector-all
> +	CFLAGS := $(CFLAGS) -fstack-protector-all --param ssp-buffer-size=1
>  endif
> 
> -- 
> Brian Gitonga Marete
> Toshnix Systems
> Tel: +254722151590
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

