Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754607Ab1B1Sin (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 13:38:43 -0500
Received: from pqueueb.post.tele.dk ([193.162.153.10]:37466 "EHLO
	pqueueb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325Ab1B1Sil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 13:38:41 -0500
Date: Mon, 28 Feb 2011 19:38:16 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Borislav Petkov <bp@alien8.de>, Michal Marek <mmarek@suse.cz>,
        torvalds@linux-foundation.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        linux-kbuild@vger.kernel.org, bp@amd64.org
Subject: Re: [PATCH -v4] kbuild: Add extra gcc checks
Message-ID: <20110228183816.GA1759@merkur.ravnborg.org>
References: <20110221110322.GA9819@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110221110322.GA9819@liondog.tnic>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 21, 2011 at 12:03:22PM +0100, Borislav Petkov wrote:
> 
> Add a 'W=1' Makefile switch which adds additional checking per build
> object.
> 
> The idea behind this option is targeted at developers who, in the
> process of writing their code, want to do the occasional
> 
> make W=1 [target.o]
> 
> and let gcc do more extensive code checking for them. Then, they
> could eyeball the output for valid gcc warnings about various
> bugs/discrepancies which are not reported during the normal build
> process.
> 
> For more background information and a use case, read through this
> thread: http://marc.info/?l=kernel-janitors&m=129802065918147&w=2
> 
> -v4: Enable this for gcc only. Also, check for options which are not
> supported by every gcc version we use to build the kernel. Adding those
> checks for _every_ option slows down the build noticeably so be sensible
> here and add it only when your gcc version chokes on a particular
> option.
> 
> -v[2..3]: move to Makefile.build
> 
> Cc: Michal Marek <mmarek@suse.cz>
> Cc: Sam Ravnborg <sam@ravnborg.org>
> Cc: linux-kbuild@vger.kernel.org
> Acked-by: Ingo Molnar <mingo@elte.hu>
> Signed-off-by: Borislav Petkov <bp@alien8.de>
> ---
>  Makefile               |    6 ++++++
>  scripts/Makefile.build |   37 ++++++++++++++++++++++++++++++++++++-
>  2 files changed, 42 insertions(+), 1 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index c9c8c8f..c3bca9c 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -102,6 +102,11 @@ ifeq ("$(origin O)", "command line")
>    KBUILD_OUTPUT := $(O)
>  endif
>  
> +ifeq ("$(origin W)", "command line")
> +  KBUILD_ENABLE_EXTRA_GCC_CHECKS = 1
> +  export KBUILD_ENABLE_EXTRA_GCC_CHECKS
> +endif

It is simpler to just write:
export KBUILD_ENABLE_EXTRA_GCC_CHECKS := 1


> +#
> +# make W=1 settings
> +#
> +# $(call cc-option... ) handles gcc -W.. options which
> +# are not supported by all versions of the compiler
> +ifdef KBUILD_ENABLE_EXTRA_GCC_CHECKS

> +ifneq ($(call cc-version),)
This check looks redundant.

You introduce a new environment variable "KBUILD_ENABLE_EXTRA_GCC_CHECKS".
We actually ty to document these in Documentation/kbuild/kbuild.txt

Fix the above and you can add my:
Acked-by: Sam Ravnborg <sam@ravnborg.org>

	Sam
