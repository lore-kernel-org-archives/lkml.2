Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577Ab1LDLYN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 06:24:13 -0500
Received: from caiajhbdcaib.dreamhost.com ([208.97.132.81]:42117 "EHLO
	homiemail-a6.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752393Ab1LDLYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 06:24:08 -0500
Subject: Re: [PATCH] lguest: move the lguest tool to the tools directory
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: lguest@lists.ozlabs.org, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <87k46eqm1x.fsf@rustcorp.com.au>
References: <1322862759.3264.2.camel@offbook>
	 <87k46eqm1x.fsf@rustcorp.com.au>
Content-Type: text/plain; charset="UTF-8"
Organization: GNU
Date: Sun, 04 Dec 2011 12:24:04 +0100
Message-ID: <1322997844.3130.1.camel@offbook>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-12-03 at 15:38 +1030, Rusty Russell wrote:
> On Fri, 02 Dec 2011 22:52:39 +0100, Davidlohr Bueso <dave@gnu.org> wrote:
> > From: Davidlohr Bueso <dave@gnu.org>
> > 
> > This is a better location instead of having it in Documentation.
> > 
> > Signed-off-by: Davidlohr Bueso <dave@gnu.org>
> 
> Applied, thanks!  This has been on my TODO list for ages.  Almost since
> tools/ was created.
> 
> Weird that your patch didn't come through as a simple move and slight
> mod though: this way it's a pain to read :(  I checked, you didn't
> change anything.
> 
> But unfortunately that's a problem:
> $ make
> cc -m32 -Wall -Wmissing-declarations -Wmissing-prototypes -O3 -U_FORTIFY_SOURCE    lguest.c   -o lguest
> lguest.c:52:52: fatal error: ../../../include/linux/lguest_launcher.h: No such file or directory
> compilation terminated.
> make: *** [lguest] Error 1
> 
> You need this as well:
> 
> From: Rusty Russell <rusty@rustcorp.com.au>
> Subject: lguest: move the lguest tool to the tools directory (fixes)
> 
> Fixup complilation breakage from move.
> 
> Signed-off-by: Davidlohr Bueso <dave@gnu.org>
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> ---
>  drivers/lguest/Makefile |    2 +-
>  tools/lguest/lguest.c   |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/lguest/Makefile b/drivers/lguest/Makefile
> --- a/drivers/lguest/Makefile
> +++ b/drivers/lguest/Makefile
> @@ -18,7 +18,7 @@ Mastery: PREFIX=M
>  Beer:
>  	@for f in Preparation Guest Drivers Launcher Host Switcher Mastery; do echo "{==- $$f -==}"; make -s $$f; done; echo "{==-==}"
>  Preparation Preparation! Guest Drivers Launcher Host Switcher Mastery:
> -	@sh ../../Documentation/virtual/lguest/extract $(PREFIX) `find ../../* -name '*.[chS]' -wholename '*lguest*'`
> +	@sh ../../tools/lguest/extract $(PREFIX) `find ../../* -name '*.[chS]' -wholename '*lguest*'`
>  Puppy:
>  	@clear
>  	@printf "      __  \n (___()'\`;\n /,    /\`\n \\\\\\\"--\\\\\\   \n"
> diff --git a/tools/lguest/lguest.c b/tools/lguest/lguest.c
> --- a/tools/lguest/lguest.c
> +++ b/tools/lguest/lguest.c
> @@ -49,7 +49,7 @@
>  #include <linux/virtio_rng.h>
>  #include <linux/virtio_ring.h>
>  #include <asm/bootparam.h>
> -#include "../../../include/linux/lguest_launcher.h"
> +#include "../../include/linux/lguest_launcher.h"

Maybe because my git foo sucks but I had made that change and certainly
thought it was included in the patch, sorry about that.

Thanks,
Davidlohr

>  /*L:110
>   * We can ignore the 43 include files we need for this program, but I do want
>   * to draw attention to the use of kernel-style types.
> 


