Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760954Ab2EIUGR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 16:06:17 -0400
Received: from mga14.intel.com ([143.182.124.37]:58847 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760879Ab2EIUGP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 16:06:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="141041138"
Message-ID: <4FAACE2C.1050405@linux.intel.com>
Date: Wed, 09 May 2012 13:06:04 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
CC: "H. Peter Anvin" <h.peter.anvin@intel.com>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        Sam Ravnborg <sam@ravnborg.org>,
        Joseph Cihula <joseph.cihula@intel.com>,
        Shane Wang <shane.wang@intel.com>
Subject: Re: [PATCH 02/23] x86, realmode: realmode.bin infrastructure
References: <1336501366-28617-1-git-send-email-jarkko.sakkinen@intel.com> <1336501366-28617-3-git-send-email-jarkko.sakkinen@intel.com> <4FAA9207.8070709@intel.com> <alpine.DEB.2.02.1205092256240.31031@jsakkine-mobl1.(null)>
In-Reply-To: <alpine.DEB.2.02.1205092256240.31031@jsakkine-mobl1.(null)>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09/2012 12:57 PM, Jarkko Sakkinen wrote:
> 
> diff --git a/arch/x86/realmode/Makefile b/arch/x86/realmode/Makefile
> index f22a4f8..615878e 100644
> --- a/arch/x86/realmode/Makefile
> +++ b/arch/x86/realmode/Makefile
> @@ -15,6 +15,3 @@ $(obj)/rmpiggy.o: $(obj)/rm/realmode.relocs
> $(obj)/rm/realmode.bin
> 
>  $(obj)/rm/realmode.bin: FORCE
>         $(Q)$(MAKE) $(build)=$(obj)/rm $@
> -
> -$(obj)/rm/realmode.relocs: FORCE
> -       $(Q)$(MAKE) $(build)=$(obj)/rm $@
> diff --git a/arch/x86/realmode/rm/Makefile b/arch/x86/realmode/rm/Makefile
> index de40bc4..1c1d3d3 100644
> --- a/arch/x86/realmode/rm/Makefile
> +++ b/arch/x86/realmode/rm/Makefile
> @@ -48,7 +48,7 @@ $(obj)/realmode.elf: $(obj)/realmode.lds
> $(REALMODE_OBJS) FORCE
> 
>  OBJCOPYFLAGS_realmode.bin := -O binary
> 
> -$(obj)/realmode.bin: $(obj)/realmode.elf
> +$(obj)/realmode.bin: $(obj)/realmode.elf $(obj)/realmode.relocs
>         $(call if_changed,objcopy)
> 
>  quiet_cmd_relocs = RELOCS  $@
> 
> Would this resolve the existing issues or not?
> 

That should would work, although it is definitely a hack.  It all really
comes down to make not having a good way to deal with a single process
generating more than one output.  I discussed this about a decade(!) ago
with the GNU make maintainers, and they said that make *can* be made to
do the right thing by doing a pattern rule:

%.foo %.bar: %.baz

... as pattern rules with multiple targets are handled differently than
non-pattern rules with multiple targets.  They were -- and still are --
reluctant to actually fix the problem since it wouldn't be backwards
compatible, but of course that is true with any new Make feature.

Not sure how to use the pattern rule in this case, so I guess we might
as well go with the hack.  Can you send it as a proper patch (with a
description and Signed-off-by:), please?

	-hpa

