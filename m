Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758224Ab0JELkR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 07:40:17 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:37619 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815Ab0JELkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 07:40:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=HojMyjIrs0S8wDo+h8PRFCrtIdOFK2Uac+1ijjorc+Jv5EWVO66Sgte0+G38IXvLIq
         3sBG/2YZc5KOtagKL+Z7P59gMFBk0bs4onYvJCTM0lf+/WUv7XjGA3J1Thi7gXL9v4nW
         rsFF1Dlk7mG99/a7uwR/5zs3ENulS5HTJevtY=
Date: Tue, 5 Oct 2010 19:44:49 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Evgeny Kuznetsov <EXT-Eugeny.Kuznetsov@nokia.com>
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
        phillip@lougher.demon.co.uk, hsweeten@visionengravers.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] initramfs: strcpy destination string overflow
Message-ID: <20101005114449.GI5170@cr0.nay.redhat.com>
References: <cover.1286193211.git.EXT-Eugeny.Kuznetsov@nokia.com>
 <b6cdf32448371a89fdab2f3875ac5b32365bf518.1286193211.git.EXT-Eugeny.Kuznetsov@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6cdf32448371a89fdab2f3875ac5b32365bf518.1286193211.git.EXT-Eugeny.Kuznetsov@nokia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 05, 2010 at 12:44:17PM +0400, Evgeny Kuznetsov wrote:
>From: Evgeny Kuznetsov <ext-eugeny.kuznetsov@nokia.com>
>
>Function "strcpy()" is used without check for maximum allowed
>source string length and could cause destination string overflow.
>"strcpy()" is replaced by "strlcpy()" to prevent destination
>string overflow.
>
>Signed-off-by: Evgeny Kuznetsov <EXT-Eugeny.Kuznetsov@nokia.com>


Looks good to me,

Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>

>---
> init/initramfs.c |    2 +-
> 1 files changed, 1 insertions(+), 1 deletions(-)
>
>diff --git a/init/initramfs.c b/init/initramfs.c
>index 4b9c202..3e68568 100644
>--- a/init/initramfs.c
>+++ b/init/initramfs.c
>@@ -56,7 +56,7 @@ static char __init *find_link(int major, int minor, int ino,
> 	q->minor = minor;
> 	q->ino = ino;
> 	q->mode = mode;
>-	strcpy(q->name, name);
>+	strlcpy(q->name, name, sizeof(q->name));
> 	q->next = NULL;
> 	*p = q;
> 	return NULL;
>-- 
>1.6.3.3
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/
