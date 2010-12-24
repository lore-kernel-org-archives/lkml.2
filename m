Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753056Ab0LXWNp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Dec 2010 17:13:45 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51172 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736Ab0LXWNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Dec 2010 17:13:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=ZdXS9FZma9BxmnpEp/4NkDxY6gkNxIVMEJFNi2D6rdGagK6k2ROGuwwqPyboIEZogc
         qoOUnyfcNgPnwGMstVMBqm/Zl13Eo39CKC4nohYa+fnJko4xksGcV9VxSfkW+BCzitSH
         LNWFQUQjM/vPc/QjIVW2gS4Y06YywHwgV0kfk=
Message-ID: <4D151D13.4060802@gmail.com>
Date: Fri, 24 Dec 2010 23:22:11 +0100
From: Edward Shishkin <edward.shishkin@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Jesper Juhl <jj@chaosbits.net>
CC: reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] reiserfs: Make sure va_end() is always called after va_start().
References: <alpine.LNX.2.00.1012241933390.28973@swampdragon.chaosbits.net>
In-Reply-To: <alpine.LNX.2.00.1012241933390.28973@swampdragon.chaosbits.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesper Juhl wrote:
> Greetings,
>
> A call to va_start() must always be followed by a call to va_end() in the 
> same function. In fs/reiserfs/prints.c::print_block() this is not always 
> the case. If 'bh' is NULL we'll return without calling va_end().
> One could add a call to va_end() before the 'return' statement, but it's 
> nicer to just move the call to va_start() after the test for 'bh' being 
> NULL.
>
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
>   

Acked-by: Edward Shishkin <edward.shishkin@gmail.com>

> ---
>  prints.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/reiserfs/prints.c b/fs/reiserfs/prints.c
> index adbc6f5..45de98b 100644
> --- a/fs/reiserfs/prints.c
> +++ b/fs/reiserfs/prints.c
> @@ -586,13 +586,13 @@ void print_block(struct buffer_head *bh, ...)	//int print_mode, int first, int l
>  	va_list args;
>  	int mode, first, last;
>  
> -	va_start(args, bh);
> -
>  	if (!bh) {
>  		printk("print_block: buffer is NULL\n");
>  		return;
>  	}
>  
> +	va_start(args, bh);
> +
>  	mode = va_arg(args, int);
>  	first = va_arg(args, int);
>  	last = va_arg(args, int);
>
>
>
>   

