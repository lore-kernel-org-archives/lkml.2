Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757418Ab2FYQPx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 12:15:53 -0400
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:46573 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757234Ab2FYQPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 12:15:52 -0400
Message-ID: <4FE88E9A.4040605@xenotime.net>
Date: Mon, 25 Jun 2012 09:15:22 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
CC: Artem Bityutskiy <dedekind1@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ubifs: Fix build warning
References: <1340637580-12711-1-git-send-email-aletes.xgr@gmail.com>
In-Reply-To: <1340637580-12711-1-git-send-email-aletes.xgr@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2012 08:19 AM, Alexandre Pereira da Silva wrote:

> Fix:
> fs/ubifs/dir.c: In function 'ubifs_rename':
> fs/ubifs/dir.c:972:15: warning: 'saved_nlink' may be used uninitialized
> in this function
> 
> Initilize saved_nlink to 0

Does nlink need to be init at all?  is the warning bogus or valid?

If the warning is bogus, the preferred solution is:

#include <linux/compiler-gcc.h>
...
	unsigned int uninitialized_var(nlink);


> Signed-off-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
> ---
>  fs/ubifs/dir.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ubifs/dir.c b/fs/ubifs/dir.c
> index a6d42ef..d5b8cb1e 100644
> --- a/fs/ubifs/dir.c
> +++ b/fs/ubifs/dir.c
> @@ -969,7 +969,7 @@ static int ubifs_rename(struct inode *old_dir, struct dentry *old_dentry,
>  	struct ubifs_budget_req ino_req = { .dirtied_ino = 1,
>  			.dirtied_ino_d = ALIGN(old_inode_ui->data_len, 8) };
>  	struct timespec time;
> -	unsigned int saved_nlink;
> +	unsigned int saved_nlink = 0;
>  
>  	/*
>  	 * Budget request settings: deletion direntry, new direntry, removing



-- 
~Randy
