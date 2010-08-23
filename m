Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372Ab0HWGsW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 02:48:22 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:43503 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753326Ab0HWGsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 02:48:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=RKNgHKCUOTT+5LpQexC47pzrSd9Z1PgnDO+oRH5yXQR5fr98EMaQ6l1Ydrurplm6nD
         JjbbAvihlRsDUR8RMN43JVEFuQOumb3lxSSHdG+OY+t0bDaAGxRUEFQlW1J5Z0H+QjNL
         6PZR0oOZKmInKp6JQJx6W6hsIzhNXuYJQdr3s=
Date: Mon, 23 Aug 2010 14:52:33 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Andy Shevchenko <ext-andriy.shevchenko@nokia.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH][resend] scripts/mod/modpost.c: fix commentary
 accordingly to last changes
Message-ID: <20100823065233.GM5168@cr0.nay.redhat.com>
References: <1282041400-32667-1-git-send-email-ext-andriy.shevchenko@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282041400-32667-1-git-send-email-ext-andriy.shevchenko@nokia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 17, 2010 at 01:36:40PM +0300, Andy Shevchenko wrote:
>The last commits
> 37ed19d5cce35a40d3913cf9aa208ce9f60db3d7
> 5003bab82d56754b27be01eef24495a02e00039d
>have introduced new behaviour of sec2annotation() method. However, the
>commentary inside the method was left as before. Let's fix it accordingly.
>
>Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
>Cc: Rusty Russell <rusty@rustcorp.com.au>
>Cc: Andrew Morton <akpm@linux-foundation.org>


Acked-by: WANG Cong <xiyou.wangcong@gmail.com>

>---
> scripts/mod/modpost.c |    5 ++++-
> 1 files changed, 4 insertions(+), 1 deletions(-)
>
>diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
>index 1ec7158..33122ca 100644
>--- a/scripts/mod/modpost.c
>+++ b/scripts/mod/modpost.c
>@@ -1208,6 +1208,9 @@ static Elf_Sym *find_elf_symbol2(struct elf_info *elf, Elf_Addr addr,
>  * .cpuinit.data => __cpudata
>  * .memexitconst => __memconst
>  * etc.
>+ *
>+ * The memory of returned value has been allocated on a heap. The user of this
>+ * method should free it after usage.
> */
> static char *sec2annotation(const char *s)
> {
>@@ -1230,7 +1233,7 @@ static char *sec2annotation(const char *s)
> 			strcat(p, "data ");
> 		else
> 			strcat(p, " ");
>-		return r; /* we leak her but we do not care */
>+		return r;
> 	} else {
> 		return strdup("");
> 	}
>-- 
>1.6.3.3
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/
