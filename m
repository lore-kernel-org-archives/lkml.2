Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076Ab1EXMZ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 08:25:59 -0400
Received: from usmamail.tilera.com ([206.83.70.75]:38459 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754247Ab1EXMZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 08:25:58 -0400
Message-ID: <4DDBA3AE.6080608@tilera.com>
Date: Tue, 24 May 2011 08:25:18 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the final tree (tile
 tree related)
References: <20110524134203.62d859c0.sfr@canb.auug.org.au>
In-Reply-To: <20110524134203.62d859c0.sfr@canb.auug.org.au>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/23/2011 11:42 PM, Stephen Rothwell wrote:
> Hi Chris,
>
> After merging the final tree, today's linux-next build (sparc64 defconfig)
> failed like this:
>
> [...]
>
> I added this patch for today:
>
> [...]
>
> diff --git a/include/linux/compat.h b/include/linux/compat.h
> index 644e1a4..ddcb7db 100644
> --- a/include/linux/compat.h
> +++ b/include/linux/compat.h
> @@ -13,6 +13,7 @@
>  #include <linux/socket.h>
>  #include <linux/if.h>
>  #include <linux/fs.h>
> +#include <linux/aio_abi.h>	/* for aio_context_t */
>  
>  #include <asm/compat.h>
>  #include <asm/siginfo.h>

Stephen, thanks for the discovery and the fix.  Apparently the uses in the
"tile" tree already happen to have this header included earlier, so I
didn't trip up against it.  I'll take the change into my tree.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com


