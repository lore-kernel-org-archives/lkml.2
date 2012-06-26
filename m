Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756450Ab2FZKhv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 06:37:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48612 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756001Ab2FZKht (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 06:37:49 -0400
Message-ID: <4FE990F5.1020500@suse.cz>
Date: Tue, 26 Jun 2012 12:37:41 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120328 Thunderbird/11.0.1
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Artem Bityutskiy <dedekind1@gmail.com>
Subject: Re: [PATCH 7/8] kbuild: move W=... stuff to Kbuild.arch
References: <20120505080640.GA13773@merkur.ravnborg.org> <1336205926-13946-7-git-send-email-sam@ravnborg.org>
In-Reply-To: <1336205926-13946-7-git-send-email-sam@ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5.5.2012 10:18, Sam Ravnborg wrote:
> Prevent that we eveluate cc-option multiple times for the same
> option by moving the definitions to Kbuild.arch.
> The file is included once only, thus gcc is not invoked once per directory.

Nice.


> Another side-effect of this patch is that KCFLAGS are appended last
> to the list of options. This allows us to better control the options.
> Artem Bityutskiy <dedekind1@gmail.com> noticed this.
> 
> Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
> Cc: Artem Bityutskiy <dedekind1@gmail.com>
> ---
>  scripts/Kbuild.arch    |   51 +++++++++++++++++++++++++++++++++++++++++++++++-
>  scripts/Makefile.build |   51 ------------------------------------------------
>  2 files changed, 50 insertions(+), 52 deletions(-)
> 
> diff --git a/scripts/Kbuild.arch b/scripts/Kbuild.arch
> index 230050f..6ff27c6 100644
> --- a/scripts/Kbuild.arch
> +++ b/scripts/Kbuild.arch
> @@ -76,6 +76,56 @@ ifeq ($(shell $(CONFIG_SHELL) $(srctree)/scripts/gcc-goto.sh $(CC)), y)
>          KBUILD_CFLAGS += -DCC_HAVE_ASM_GOTO
>  endif
>  
> +# make W=... settings

Again a nitpick only, in the comment earlier in this file

# This warning generated too much noise in a regular build.
# Use make W=1 to enable this warning (see scripts/Makefile.build)

the scripts/Makefile.build reference lost its meaning now.

Michal
