Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757404Ab2JQQWU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 12:22:20 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52056 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756394Ab2JQQWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 12:22:18 -0400
Date: Wed, 17 Oct 2012 13:22:11 -0300
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Michal Marek <mmarek@suse.cz>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [ 074/147] kbuild: Do not package /boot and /lib in make tar-pkg
Message-ID: <20121017162210.GC2954@herton-Z68MA-D2H-B3>
References: <20121014143533.742627615@decadent.org.uk>
 <20121014143543.836365515@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121014143543.836365515@decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 14, 2012 at 03:36:47PM +0100, Ben Hutchings wrote:
> 3.2-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Michal Marek <mmarek@suse.cz>
> 
> commit fe04ddf7c2910362f3817c8156e41cbd6c0ee35d upstream.
> 
> There were reports of users destroying their Fedora installs by a kernel
> tarball that replaces the /lib -> /usr/lib symlink. Let's remove the
> toplevel directories from the tarball to prevent this from happening.
> 
> Reported-by: Andi Kleen <andi@firstfloor.org>
> Suggested-by: Ben Hutchings <ben@decadent.org.uk>
> Signed-off-by: Michal Marek <mmarek@suse.cz>
> [bwh: Backported to 3.2: drop redundant changes]
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
>  scripts/Makefile.fwinst  |    4 ++--
>  scripts/package/buildtar |    2 +-
>  3 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/scripts/Makefile.fwinst b/scripts/Makefile.fwinst
> index 4d908d1..c3f69ae 100644
> --- a/scripts/Makefile.fwinst
> +++ b/scripts/Makefile.fwinst
> @@ -42,7 +42,7 @@ quiet_cmd_install = INSTALL $(subst $(srctree)/,,$@)
>  $(installed-fw-dirs):
>  	$(call cmd,mkdir)
>  
> -$(installed-fw): $(INSTALL_FW_PATH)/%: $(obj)/% | $(INSTALL_FW_PATH)/$$(dir %)
> +$(installed-fw): $(INSTALL_FW_PATH)/%: $(obj)/% | $$(dir $(INSTALL_FW_PATH)/%)
>  	$(call cmd,install)

Pulling Linus tree today, I noticed commit
3ce9e53e788881da0d5f3912f80e0dd6b501f304 ("kbuild: Fix accidental revert
in commit fe04ddf"). This change to Makefile.fwinst is unrelated and
shouldn't be applied. This hunk was suspicious, could be dropped if not
too late. Otherwise, just picking 3ce9e53e7 later would be fine as well.

-- 
[]'s
Herton
