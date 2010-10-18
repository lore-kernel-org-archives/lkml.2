Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753135Ab0JRDrl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 23:47:41 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63042 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526Ab0JRDrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 23:47:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=GHF6JPUgvhDWySsdhHQdtBOAoqB4jc/pKB4KZ7wb8RLw35FMUXqR+bvsPgVQyb6yRQ
         HdMEYUu/q5QmCuNXMz6X8Onc+ASIFImYvatanlCpYMWm608U00n2s0QJeWJFJ0u5odQ+
         ivBfDeauAdfWnBa9/RmsTa/bKVtFw+8mi/mTY=
Subject: Re: [PATCH 3/3] fs/jffs2/dir.c: Use kmemdup
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Julia Lawall <julia@diku.dk>
Cc: Joe Perches <joe@perches.com>, David Woodhouse <dwmw2@infradead.org>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.1010172155240.394@ask.diku.dk>
References: <1287341311-11161-1-git-send-email-julia@diku.dk>
	 <1287341311-11161-4-git-send-email-julia@diku.dk>
	 <1287341849.20968.62.camel@Joe-Laptop>
	 <Pine.LNX.4.64.1010172155240.394@ask.diku.dk>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Oct 2010 06:43:34 +0300
Message-ID: <1287373414.1972.25.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-10-17 at 21:56 +0200, Julia Lawall wrote:
> Convert a sequence of kmalloc and memcpy to use kmemdup.
> 
> The semantic patch that performs this transformation is:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> expression a,flag,len;
> expression arg,e1,e2;
> statement S;
> @@
> 
>   a =
> -  \(kmalloc\|kzalloc\)(len,flag)
> +  kmemdup(arg,len,flag)
>   <... when != a
>   if (a == NULL || ...) S
>   ...>
> - memcpy(a,arg,len+1);
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> ---
>  fs/jffs2/dir.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Picked this one and put to l2-mtd-2.6.git, thanks.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

