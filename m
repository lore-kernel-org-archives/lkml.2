Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758236Ab1DLQ6q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 12:58:46 -0400
Received: from void.printf.net ([89.145.121.20]:48441 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758223Ab1DLQ6n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 12:58:43 -0400
From: Chris Ball <cjb@laptop.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-mmc@vger.kernel.org
Subject: Re: [PATCH -next] mmc quirks: fix truncation warnings
References: <20110412151408.b80a3afb.sfr@canb.auug.org.au>
	<20110412091735.f41a3d44.randy.dunlap@oracle.com>
Date: Tue, 12 Apr 2011 13:03:23 -0400
In-Reply-To: <20110412091735.f41a3d44.randy.dunlap@oracle.com> (Randy Dunlap's
	message of "Tue, 12 Apr 2011 09:17:35 -0700")
Message-ID: <m339ln1jxg.fsf@pullcord.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Apr 12 2011, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
>
> Fix data truncation warnings: .manfid is not unsigned long:
>
> drivers/mmc/core/quirks.c:36: warning: large integer implicitly truncated to unsigned type
> drivers/mmc/core/quirks.c:40: warning: large integer implicitly truncated to unsigned type
> drivers/mmc/core/quirks.c:43: warning: large integer implicitly truncated to unsigned type
> drivers/mmc/core/quirks.c:46: warning: large integer implicitly truncated to unsigned type
>
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Cc:	Chris Ball <cjb@laptop.org>
> Cc:	linux-mmc@vger.kernel.org
> ---
>  include/linux/mmc/card.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- linux-next-20110412.orig/include/linux/mmc/card.h
> +++ linux-next-20110412/include/linux/mmc/card.h
> @@ -180,7 +180,7 @@ struct mmc_fixup {
>  	int data;
>  };
>  
> -#define CID_MANFID_ANY (-1ul)
> +#define CID_MANFID_ANY (-1u)
>  #define CID_OEMID_ANY ((unsigned short) -1)
>  #define CID_NAME_ANY (NULL)
>  
>

Thanks very much, Randy, I've pushed this to mmc-next.

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
