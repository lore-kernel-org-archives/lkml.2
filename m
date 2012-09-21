Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756383Ab2IULuz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 07:50:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50586 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755804Ab2IULuw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 07:50:52 -0400
Date: Fri, 21 Sep 2012 13:50:51 +0200
From: Michal Marek <mmarek@suse.cz>
To: Jeff Mahoney <jeffm@suse.de>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, linux-kbuild@vger.kernel.org,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86/kbuild: archscripts depends on scripts_basic
Message-ID: <20120921115051.GB10385@sepie.suse.cz>
References: <505A02F8.4040804@suse.de>
 <505A03EC.8090502@linux.intel.com>
 <505B281D.80405@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <505B281D.80405@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2012 at 10:28:45AM -0400, Jeff Mahoney wrote:
> While building the SUSE kernel packages, which build the scripts,
> make clean, and then build everything, we have been running into spurious
> build failures. We tracked them down to a simple dependency issue:
> 
> $ make mrproper
>   CLEAN   arch/x86/tools
>   CLEAN   scripts/basic
> $ cp patches/config/x86_64/desktop .config
> $ make archscripts
>   HOSTCC  arch/x86/tools/relocs
> /bin/sh: scripts/basic/fixdep: No such file or directory
> make[3]: *** [arch/x86/tools/relocs] Error 1
> make[2]: *** [archscripts] Error 2
> make[1]: *** [sub-make] Error 2
> make: *** [all] Error 2
> 
> This was introduced by commit
> 6520fe55 (x86, realmode: 16-bit real-mode code support for relocs),
> which added the archscripts dependency to archprepare.
> 
> This patch adds the scripts_basic dependency to the x86 archscripts.
> 
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>

Applied to kbuild.git#rc-fixes, thanks.

Michal
