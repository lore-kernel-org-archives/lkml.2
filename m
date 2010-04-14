Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751960Ab0DNEoX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 00:44:23 -0400
Received: from mail-yw0-f194.google.com ([209.85.211.194]:62597 "EHLO
	mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162Ab0DNEoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 00:44:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=xo2JJpreSllrxKdxKZTDLrFdjY+Ki+AZAIa0ftNyjsVYIqhIWyqt9PTbTzdiETCYQu
         qzgul2dqBlzKs258BlHIB8Gs7NAeev2m9lFX2VRypB3D33uApMy39W4xUOpR1zTPUKTl
         U6LCAiFmVtvTSTRf3U41IAeENhl/fvhKbI/Ic=
Date: Wed, 14 Apr 2010 12:48:05 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: Huang Shijie <shijie8@gmail.com>
Cc: akpm@linux-foundation.org, viro@zeniv.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH][resend] namei.c : update mnt when it needed
Message-ID: <20100414044805.GE3919@cr0.nay.redhat.com>
References: <1271211369-27419-1-git-send-email-shijie8@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271211369-27419-1-git-send-email-shijie8@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 14, 2010 at 10:16:09AM +0800, Huang Shijie wrote:
>update the mnt of the path when it is not equal to the new one.
>
>Signed-off-by: Huang Shijie <shijie8@gmail.com>


This change is trivial, and it looks fine for me.

Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>

Thanks!


>---
> fs/namei.c |    5 +++--
> 1 files changed, 3 insertions(+), 2 deletions(-)
>
>diff --git a/fs/namei.c b/fs/namei.c
>index a7dce91..9c3a040 100644
>--- a/fs/namei.c
>+++ b/fs/namei.c
>@@ -523,9 +523,10 @@ static void path_put_conditional(struct path *path, struct nameidata *nd)
> static inline void path_to_nameidata(struct path *path, struct nameidata *nd)
> {
> 	dput(nd->path.dentry);
>-	if (nd->path.mnt != path->mnt)
>+	if (nd->path.mnt != path->mnt) {
> 		mntput(nd->path.mnt);
>-	nd->path.mnt = path->mnt;
>+		nd->path.mnt = path->mnt;
>+	}
> 	nd->path.dentry = path->dentry;
> }
> 
>-- 
>1.6.6
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/
