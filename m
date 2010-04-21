Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957Ab0DUQ07 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 12:26:59 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:45044 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755804Ab0DUQ06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 12:26:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=IDkduaL55KHsSOBHJoN/5KkAF1s6VRXohsZg5llqg/GnN5vjU/FFII+0/R5NG/yRLd
         ldaeACuHl67rmlX0c7gtMcu8T83+6fDbVxIW5DvP5BSovgO2e8/LKFuWuNUC55GzQZKs
         BXt3t7PnZXbAae/uhGOUqCLV61IrUTXMY4WnY=
Date: Thu, 22 Apr 2010 00:31:05 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: GuanJun He <heguanbo@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.34-rc1] fs: fix bad string output
Message-ID: <20100421163105.GC13861@hack>
References: <x2uccf7f6161004210159qe7337037td6054d3e33ce350c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x2uccf7f6161004210159qe7337037td6054d3e33ce350c@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 21, 2010 at 04:59:40PM +0800, GuanJun He wrote:
>fix bad string output,[Bug #15589] 2.6.34-rc1: Badness at fs/proc/generic.c:316
>
>Signed-off-by: Guanjun He <heguanbo@gmail.com>
>

NACK.

This even doesn't pass compiling. Check the prototype of kstrdup().

Also, we already had a patch:

https://patchwork.kernel.org/patch/93658/


>---
>diff -Nupr linux-2.6.34-rc1-orig/fs/proc/generic.c
>linux-2.6.34-rc1/fs/proc/generic.c
>--- linux-2.6.34-rc1-orig/fs/proc/generic.c     2010-04-21
>13:47:18.000000000 +0800
>+++ linux-2.6.34-rc1/fs/proc/generic.c  2010-04-21 16:42:11.000000000 +0800
>@@ -313,7 +313,14 @@ static int __xlate_proc_name(const char
>                                break;
>                }
>                if (!de) {
>-                       WARN(1, "name '%s'\n", name);
>+                       cp = kstrdup(name);
>+                       if (cp) {
>+                               next = cp;
>+                               while(*next) {
>+                                       if (*next == '/')  *next++ = '_';
>+                               }
>+                               WARN(1, "name '%s'\n", cp);
>+                       }
>                        return -ENOENT;
>                }
>                cp += len + 1;
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/

-- 
Live like a child, think like the god.
 
