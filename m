Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933924Ab2C2VyB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 17:54:01 -0400
Received: from am1ehsobe006.messaging.microsoft.com ([213.199.154.209]:58179
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759415Ab2C2Vxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 17:53:54 -0400
X-SpamScore: -17
X-BigFish: VPS-17(zzbb2dI103dK1dbaL1432N98dKzz1202hzzz2fh668h839hd25h)
X-Forefront-Antispam-Report: CIP:160.33.98.74;KIP:(null);UIP:(null);IPV:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
Message-ID: <4F74D9C3.5010907@am.sony.com>
Date: Thu, 29 Mar 2012 14:53:07 -0700
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: <frank.rowand@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Alessio Igor Bogani <abogani@kernel.org>
CC: "Rowand, Frank" <Frank_Rowand@sonyusa.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Jan Beulich <jbeulich@novell.com>,
        Kbuild <linux-kbuild@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Bird, Tim" <Tim.Bird@am.sony.com>,
        Anders Kaseorg <andersk@ksplice.com>,
        Arnaud Lacombe <lacombar@gmail.com>
Subject: Re: [PATCH] Let modpost parses vmlinux instead of vmlinux.o
References: <4F737193.4030709@am.sony.com> <1333032786-12457-1-git-send-email-abogani@kernel.org>
In-Reply-To: <1333032786-12457-1-git-send-email-abogani@kernel.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29/12 07:53, Alessio Igor Bogani wrote:
> Dear Mr. Rowand,

No need to be formal, "Frank" is ok.


> 
> What do you think about this patch?

It does not work for me.  The resulting Module.symvers is empty.

Before applying the Makefile patch, "make V=1" shows the command
to generate Module.symvers is:

  scripts/mod/modpost   -o /a/home/frowand/me/src/linux/kernel-org/build/crest/Module.symvers    -S   vmlinux.o

after applying the patch, the command becomes:

  scripts/mod/modpost   -o /a/home/frowand/me/src/linux/kernel-org/build/crest/Module.symvers    -S   -s


-Frank

> Thanks!
> 
> Ciao,
> Alessio
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
>  
>  # Declare generated files as targets for modpost


