Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138Ab1GFPdc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 11:33:32 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:41320 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753910Ab1GFPdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 11:33:31 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=BVKybfWPAghZU81U6zt/nsjHjB6NU2vUPNNLSaPfr2iOBF8ElpaHrF76fAA8Toa4lMkwyvBUuRNEbMZIazdBqbw0hBZvvBdCECWq0QdaVMS3rUDhIncPtOsx0zguCxY9;
Date: Wed, 6 Jul 2011 08:33:29 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Peter Foley <pefoley2@verizon.net>, Michal Marek <mmarek@suse.cz>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel: prevent unnecessary rebuilding due to
 config_data.gz
Message-Id: <20110706083329.9755dc70.rdunlap@xenotime.net>
In-Reply-To: <alpine.LNX.2.00.1107051741390.20637@linux>
References: <alpine.LNX.2.00.1107051741390.20637@linux>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 05 Jul 2011 19:42:18 -0400 (EDT) Peter Foley wrote:

> When IKCONFIG is built-in make oldconfig will cause the kernel to be 
> relinked even if .config didn't change. This happens because of a 
> config_data.gz dependency on .config. This patch changes the if_changed to 
> a filechk so that config_data.h is only rebuilt when the contents 
> have actually changed.
> 
> Signed-off-by: Peter Foley <pefoley2@verizon.net>

Michal,
If this looks OK to you, please merge it.

Thanks.

> ---
>  kernel/Makefile |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/Makefile b/kernel/Makefile
> index 2d64cfc..d06467f 100644
> --- a/kernel/Makefile
> +++ b/kernel/Makefile
> @@ -125,11 +125,10 @@ targets += config_data.gz
>  $(obj)/config_data.gz: $(KCONFIG_CONFIG) FORCE
>  	$(call if_changed,gzip)
>  
> -quiet_cmd_ikconfiggz = IKCFG   $@
> -      cmd_ikconfiggz = (echo "static const char kernel_config_data[] __used = MAGIC_START"; cat $< | scripts/bin2c; echo "MAGIC_END;") > $@
> +      filechk_ikconfiggz = (echo "static const char kernel_config_data[] __used = MAGIC_START"; cat $< | scripts/bin2c; echo "MAGIC_END;")
>  targets += config_data.h
>  $(obj)/config_data.h: $(obj)/config_data.gz FORCE
> -	$(call if_changed,ikconfiggz)
> +	$(call filechk,ikconfiggz)
>  
>  $(obj)/time.o: $(obj)/timeconst.h
>  
> -- 


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
