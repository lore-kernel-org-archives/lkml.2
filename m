Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751706Ab2LUIdS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 03:33:18 -0500
Received: from mail.skyhub.de ([78.46.96.112]:53394 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750906Ab2LUIdG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 03:33:06 -0500
Date: Fri, 21 Dec 2012 09:33:05 +0100
From: Borislav Petkov <bp@alien8.de>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: David Howells <dhowells@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: 3.8 NFS build breakage with !CONFIG_NFS_FSCACHE
Message-ID: <20121221083305.GB15226@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Vineet Gupta <Vineet.Gupta1@synopsys.com>,
	David Howells <dhowells@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <50D3F735.4060506@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <50D3F735.4060506@synopsys.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 21, 2012 at 11:14:21AM +0530, Vineet Gupta wrote:
> Hi David,
> 
> Not sure if this was report/fixed already - but as of today's Linus tree
> (tip has commit 96680d2), I'm seeing a build breakage due to a trivial
> missing def for nfs_fscache_wait_on_invalidate.
> 
> Following fixes it for me.
> 
> diff --git a/fs/nfs/fscache.h b/fs/nfs/fscache.h
> index 277b027..4ecb766 100644
> --- a/fs/nfs/fscache.h
> +++ b/fs/nfs/fscache.h
> @@ -222,6 +222,7 @@ static inline void nfs_readpage_to_fscache(struct
> inode *inode,
>  
>  
>  static inline void nfs_fscache_invalidate(struct inode *inode) {}
> +static inline void nfs_fscache_wait_on_invalidate(struct inode *inode) {}

I see the same thing here. Please write a proper patch and quote the
build error in the commit message:

fs/nfs/inode.c: In function ‘nfs_invalidate_mapping’:
fs/nfs/inode.c:887:2: error: implicit declaration of function ‘nfs_fscache_wait_on_invalidate’ [-Werror=implicit-function-declaration]

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
