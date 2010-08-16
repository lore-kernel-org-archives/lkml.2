Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752505Ab0HPKoE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 06:44:04 -0400
Received: from ozlabs.org ([203.10.76.45]:55117 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750795Ab0HPKoD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 06:44:03 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jon Masters <jcm@jonmasters.org>
Subject: Re: [PATCH] modules: don't call depmod when overriding external module install path
Date: Mon, 16 Aug 2010 20:13:45 +0930
User-Agent: KMail/1.13.2 (Linux/2.6.32-24-generic; KDE/4.4.2; i686; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org
References: <1281945814-9720-1-git-send-email-jcm@jonmasters.org>
In-Reply-To: <1281945814-9720-1-git-send-email-jcm@jonmasters.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201008162013.46252.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Aug 2010 05:33:34 pm Jon Masters wrote:
> Recent kernels include an additional call to depmod during the installation
> of external kernel modules as a convenience, in order to ensure that those
> modules are picked up by the module loading tools/initramfs scripts, etc.
> Although this call is potentially of some value, it should not be made
> when explicitly setting INSTALL_MOD_PATH to a different location. This
> avoids creating extraneous modules.* files that will never be used.
> 
> Signed-off-by: Jon Masters <jcm@jonmasters.org>

Acked-by: Rusty Russell <rusty@rustcorp.com.au>

I leave the Makefile stuff to the kbuild people...

> ---
>  Makefile |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index f3bdff8..2b904f2 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -1325,7 +1325,9 @@ _emodinst_:
>  
>  PHONY += _emodinst_post
>  _emodinst_post: _emodinst_
> +ifeq ($(INSTALL_MOD_PATH),)
>  	$(call cmd,depmod)
> +endif
>  
>  clean-dirs := $(addprefix _clean_,$(KBUILD_EXTMOD))

Thanks,
Rusty.
