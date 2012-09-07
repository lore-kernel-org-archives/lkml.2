Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933121Ab2IGMCn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 08:02:43 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:40896 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760437Ab2IGMCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 08:02:39 -0400
Date: Fri, 7 Sep 2012 16:02:34 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Michal Marek <mmarek@suse.cz>, "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH 2/2] checksyscalls: ignore kcmp system call
Message-ID: <20120907120234.GB2121@moon>
References: <1347017491-11354-1-git-send-email-heiko.carstens@de.ibm.com>
 <1347017491-11354-2-git-send-email-heiko.carstens@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347017491-11354-2-git-send-email-heiko.carstens@de.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 07, 2012 at 01:31:31PM +0200, Heiko Carstens wrote:
> Now that the checksyscalls script works again it will warn about the missing
> "kcmp" system call on all architectures but x86.
> Since according to git commit d97b46a6 "syscalls, x86: add __NR_kcmp syscall"
> only x86 is currently supported don't emit any warning for this system call.
> 
> Cc: Cyrill Gorcunov <gorcunov@openvz.org>
> Cc: Michal Marek <mmarek@suse.cz>
> Cc: H. Peter Anvin <hpa@linux.intel.com>
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> ---
>  scripts/checksyscalls.sh |    3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/scripts/checksyscalls.sh b/scripts/checksyscalls.sh
> index fd8fa9a..c7cda79 100755
> --- a/scripts/checksyscalls.sh
> +++ b/scripts/checksyscalls.sh
> @@ -194,6 +194,9 @@ cat << EOF
>  #define __IGNORE_getpmsg
>  #define __IGNORE_putpmsg
>  #define __IGNORE_vserver
> +
> +/* kcmp is currently x86 only */
> +#define __IGNORE_kcmp
>  EOF
>  }

Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>
