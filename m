Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957Ab0HPLle (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 07:41:34 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:36919 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114Ab0HPLld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 07:41:33 -0400
Date: Mon, 16 Aug 2010 13:41:31 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jan Beulich <JBeulich@novell.com>, Michal Marek <mmarek@suse.cz>,
        linux-kbuild <linux-kbuild@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org, Andrew Benton <b3nton@gmail.com>
Subject: Re: [PATCH] fixes for using make 3.82
Message-ID: <20100816114131.GA7122@merkur.ravnborg.org>
References: <4C6936120200007800010064@vpn.id2.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C6936120200007800010064@vpn.id2.novell.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added: Michael Marek (kbuild maintainer) + linux-kbuild.

I assume this fixes firmware build reported by Andrew Benton (cc:ed).

	Sam

On Mon, Aug 16, 2010 at 11:58:58AM +0100, Jan Beulich wrote:
> It doesn't like pattern and explicit rules to be on the same line,
> and it seems to be more picky when matching file (or really directory)
> names with different numbers of trailing slashes.
> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>

Acked-by: Sam Ravnborg <sam@ravnborg.org>
> 
> ---
>  firmware/Makefile  |    2 +-
>  scripts/mkmakefile |    4 +++-
>  2 files changed, 4 insertions(+), 2 deletions(-)
> 
> --- linux-2.6.36-rc1/firmware/Makefile
> +++ 2.6.36-rc1-make-3.82-fixes/firmware/Makefile
> @@ -142,7 +142,7 @@ fw-shipped-$(CONFIG_YAM) += yam/1200.bin
>  fw-shipped-all := $(fw-shipped-y) $(fw-shipped-m) $(fw-shipped-)
>  
>  # Directories which we _might_ need to create, so we have a rule for them.
> -firmware-dirs := $(sort $(patsubst %,$(objtree)/$(obj)/%/,$(dir $(fw-external-y) $(fw-shipped-all))))
> +firmware-dirs := $(sort $(addprefix $(objtree)/$(obj)/,$(dir $(fw-external-y) $(fw-shipped-all))))
>  
>  quiet_cmd_mkdir = MKDIR   $(patsubst $(objtree)/%,%,$@)
>        cmd_mkdir = mkdir -p $@
> --- linux-2.6.36-rc1/scripts/mkmakefile
> +++ 2.6.36-rc1-make-3.82-fixes/scripts/mkmakefile
> @@ -44,7 +44,9 @@ all:
>  
>  Makefile:;
>  
> -\$(all) %/: all
> +\$(all): all
>  	@:
>  
> +%/: all
> +	@:
>  EOF
> 
> 
