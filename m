Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754947Ab2K3L4g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 06:56:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54794 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751501Ab2K3L4e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 06:56:34 -0500
Date: Fri, 30 Nov 2012 06:56:29 -0500
From: Jeff Layton <jlayton@redhat.com>
To: Joe Perches <joe@perches.com>
Cc: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] cifs: Enable Kconfig control of CIFS_DEBUG
Message-ID: <20121130065629.52c489dc@tlielax.poochiereds.net>
In-Reply-To: <5f5c9196b44908026a27333ef31dd4ebf4314de2.1354217746.git.joe@perches.com>
References: <cover.1354217746.git.joe@perches.com>
	<5f5c9196b44908026a27333ef31dd4ebf4314de2.1354217746.git.joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Nov 2012 11:37:20 -0800
Joe Perches <joe@perches.com> wrote:

> Rather than havign a permanently enabled #define, allow
> control over it.
> 
> This can reduce the size of the module by ~100KB which
> could be useful for embedded systems.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  fs/cifs/Kconfig      |   10 +++++++++-
>  fs/cifs/cifs_debug.h |    5 ++++-
>  2 files changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/cifs/Kconfig b/fs/cifs/Kconfig
> index 2075ddf..21ff76c 100644
> --- a/fs/cifs/Kconfig
> +++ b/fs/cifs/Kconfig
> @@ -122,9 +122,17 @@ config CIFS_ACL
>  	    Allows fetching CIFS/NTFS ACL from the server.  The DACL blob
>  	    is handed over to the application/caller.
>  
> +config CIFS_DEBUG
> +	bool "Enable CIFS debugging routines"
> +	default y
> +	depends on CIFS
> +	help
> +	   Enabling this option adds helpful debugging messages to
> +	   the cifs code which increases the size of the cifs module.
> +	   If unsure, say Y.
>  config CIFS_DEBUG2
>  	bool "Enable additional CIFS debugging routines"
> -	depends on CIFS
> +	depends on CIFS_DEBUG
>  	help
>  	   Enabling this option adds a few more debugging routines
>  	   to the cifs code which slightly increases the size of
> diff --git a/fs/cifs/cifs_debug.h b/fs/cifs/cifs_debug.h
> index 4d12fe4..6867a7f 100644
> --- a/fs/cifs/cifs_debug.h
> +++ b/fs/cifs/cifs_debug.h
> @@ -18,7 +18,10 @@
>   *   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
>   *
>  */
> -#define CIFS_DEBUG		/* BB temporary */
> +
> +#ifdef CONFIG_CIFS_DEBUG
> +#define CIFS_DEBUG
> +#endif
>  
>  #ifndef _H_CIFS_DEBUG
>  #define _H_CIFS_DEBUG

Looks fine, but I'd probably prefer to just get rid of CIFS_DEBUG
altogether here and replace it with CONFIG_CIFS_DEBUG.

While you're at it, /proc/fs/cifs/cifsFYI should probably not be
present when CONFIG_CIFS_DEBUG isn't set. Perhaps we should also
disable traceSMB and its related functions too in that case?

-- 
Jeff Layton <jlayton@redhat.com>
