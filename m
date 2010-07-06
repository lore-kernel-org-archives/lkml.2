Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827Ab0GFSbO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 14:31:14 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56442 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752498Ab0GFSbM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 14:31:12 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Michal Marek <mmarek@suse.cz>
Subject: Re: Linux 2.6.35-rc4 - CONFIG_LOCALVERSION ignored?
Date: Tue, 6 Jul 2010 20:29:34 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc4; KDE/4.4.4; x86_64; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <20100705214304.GA24291@sepie.suse.cz>
In-Reply-To: <20100705214304.GA24291@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007062029.34535.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, July 05, 2010, Michal Marek wrote:
> On Mon, Jul 05, 2010 at 11:25:56PM +0200, Rafael J. Wysocki wrote:
> > Hmm.  Am I dong anything particularly wrong, or is CONFIG_LOCALVERSION ignored
> > now, as it seems?
> 
> (also reported by Stephen earlier that day)
> 
> On Mon, Jul 05, 2010 at 10:39:41AM +1000, Stephen Rothwell wrote:
> > After merging the libata tree, today's linux-next build produced this
> > warning (but it should be a failure ...):
> > 
> > /bin/sh: scripts/setlocalversion: No such file or directory
> > 
> > Probably introduced by commit 0a564b2645c8766a669c55bde1f1ef5b0518caec
> > ("kbuild: Propagate LOCALVERSION= down to scripts/setlocalversion").
> > 
> > That commit really isn't ready for inclusion in Linus' tree ...
> 
> 
> Oops, I'm an idiot. The below patch should fix localversion again:

Yes, it helps here.

Thanks,
Rafael


> From: Michal Marek <mmarek@suse.cz>
> Subject: [PATCH] kbuild: Fix path to scripts/setlocalversion
> 
> Commit 0a564b2 broke LOCALVERSION for O=... builds. Ouch.
> 
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Reported-by: Rafael J. Wysocki <rjw@sisk.pl>
> Signed-off-by: Michal Marek <mmarek@suse.cz>
> 
> diff --git a/Makefile b/Makefile
> index 12ab175..df16c4f 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -886,7 +886,7 @@ $(vmlinux-dirs): prepare scripts
>  # Store (new) KERNELRELASE string in include/config/kernel.release
>  include/config/kernel.release: include/config/auto.conf FORCE
>  	$(Q)rm -f $@
> -	$(Q)echo "$(KERNELVERSION)$$($(CONFIG_SHELL) scripts/setlocalversion $(srctree))" > $@
> +	$(Q)echo "$(KERNELVERSION)$$($(CONFIG_SHELL) $(srctree)/scripts/setlocalversion $(srctree))" > $@
>  
>  
>  # Things we need to do before we recursively start building the kernel
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 

