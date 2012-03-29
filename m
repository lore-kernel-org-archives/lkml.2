Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759393Ab2C2UXw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 16:23:52 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:48238 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758862Ab2C2UXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 16:23:48 -0400
Date: Thu, 29 Mar 2012 22:23:45 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Alessio Igor Bogani <abogani@kernel.org>
Cc: Frank Rowand <frank.rowand@am.sony.com>,
        Rowand Frank <Frank_Rowand@sonyusa.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Jan Beulich <jbeulich@novell.com>,
        Kbuild <linux-kbuild@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Tim Bird <Tim.Bird@am.sony.com>,
        Anders Kaseorg <andersk@ksplice.com>,
        Arnaud Lacombe <lacombar@gmail.com>
Subject: Re: [PATCH] Let modpost parses vmlinux instead of vmlinux.o
Message-ID: <20120329202345.GA30158@merkur.ravnborg.org>
References: <4F737193.4030709@am.sony.com> <1333032786-12457-1-git-send-email-abogani@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1333032786-12457-1-git-send-email-abogani@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 29, 2012 at 04:53:06PM +0200, Alessio Igor Bogani wrote:
> Dear Mr. Rowand,
> 
> What do you think about this patch?
> Thanks!
> 
> Ciao,
> Alessio

Hi Alession.

I am not Mr. Rowand - obviously...

The title alone looks like you are doing something wrong.
The difference between vmlinux.o and vmlinux is that the latter
is linked using the linker scripts. So a lot of sections are merged.
And modpost uses these section for the section mismatch analysis.

Then your patch fails to describe why it is needed.
And on top of this I do not understand the patch.

So a lot of things looks bad :-(

	Sam
> 
> ---
>  Makefile                 |    2 +-
>  scripts/Makefile.modpost |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index 123d858..b589d1f 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -876,7 +876,7 @@ quiet_cmd_vmlinux-modpost = LD      $@
>  define rule_vmlinux-modpost
>  	:
>  	+$(call cmd,vmlinux-modpost)
> -	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.modpost $@
> +	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.modpost $*

I do not see where the stem is coming from - and why this is needed.


>  	$(Q)echo 'cmd_$@ := $(cmd_vmlinux-modpost)' > $(dot-target).cmd
>  endef
>  
> diff --git a/scripts/Makefile.modpost b/scripts/Makefile.modpost
> index 56dfafc..ca0db29 100644
> --- a/scripts/Makefile.modpost
> +++ b/scripts/Makefile.modpost
> @@ -93,7 +93,7 @@ __modpost: $(modules:.ko=.o) FORCE
>  quiet_cmd_kernel-mod = MODPOST $@
>        cmd_kernel-mod = $(modpost) $@
>  
> -vmlinux.o: FORCE
> +vmlinux vmlinux.o: FORCE
>  	$(call cmd,kernel-mod)
It looks like you process both of vmlinux.o and vmlinux?!?!
