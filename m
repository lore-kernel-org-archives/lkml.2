Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760Ab1L3J5i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Dec 2011 04:57:38 -0500
Received: from [85.183.114.52] ([85.183.114.52]:58692 "EHLO Dublin.logfs.org"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752585Ab1L3J5f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Dec 2011 04:57:35 -0500
X-Greylist: delayed 1327 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 Dec 2011 04:57:35 EST
Date: Fri, 30 Dec 2011 10:36:38 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Roland Dreier <roland@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Steve Hodgson <steve@purestorage.com>
Subject: Re: [PATCH] btree: Export btree_get_prev() so modules can use
	btree_for_each
Message-ID: <20111230093638.GC26473@logfs.org>
References: <1325062439-1325-1-git-send-email-roland@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1325062439-1325-1-git-send-email-roland@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 December 2011 00:53:59 -0800, Roland Dreier wrote:
> 
> From: Steve Hodgson <steve@purestorage.com>
> 
> The btree_for_each API is implemented with macros that internally call
> btree_get_prev(), so if btree_get_prev() isn't exported then modules
> fail to link if they try to use one of the btree_for_each macros.  Since
> the rest of the btree API is exported, we should keep things orthogonal
> and make this work too.
> 
> Cc: Joern Engel <joern@logfs.org>
> Signed-off-by: Roland Dreier <roland@purestorage.com>

Acked-by: Joern Engel <joern@logfs.org>

> ---
>  lib/btree.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/lib/btree.c b/lib/btree.c
> index 2a34392..e5ec1e9 100644
> --- a/lib/btree.c
> +++ b/lib/btree.c
> @@ -357,6 +357,7 @@ miss:
>  	}
>  	return NULL;
>  }
> +EXPORT_SYMBOL_GPL(btree_get_prev);
>  
>  static int getpos(struct btree_geo *geo, unsigned long *node,
>  		unsigned long *key)
> -- 
> 1.7.5.4
> 

Jörn

-- 
"Error protection by error detection and correction."
-- from a university class
