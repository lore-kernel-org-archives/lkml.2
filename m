Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017Ab0HWVHL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 17:07:11 -0400
Received: from smtp-out.google.com ([216.239.44.51]:31946 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753713Ab0HWVHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 17:07:08 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=qbsEUcdCgHPYYx04oD0OXilnnJ8lufOQOkTfQUAGCwSdqysNZhTyRxW8cwM/ObzZu
	jLpzKJ7aVZuLxvt6+LttA==
Date: Mon, 23 Aug 2010 14:06:58 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Pekka Enberg <penberg@kernel.org>
cc: gregkh@suse.de, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] tty: Remove __GFP_NOFAIL from tty_add_file()
In-Reply-To: <1282594915-2480-1-git-send-email-penberg@kernel.org>
Message-ID: <alpine.DEB.2.00.1008231405260.20535@chino.kir.corp.google.com>
References: <1282594915-2480-1-git-send-email-penberg@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Aug 2010, Pekka Enberg wrote:

> diff --git a/drivers/char/pty.c b/drivers/char/pty.c
> index c350d01..bc577ac 100644
> --- a/drivers/char/pty.c
> +++ b/drivers/char/pty.c
> @@ -676,7 +676,9 @@ static int ptmx_open(struct inode *inode, struct file *filp)
>  
>  	set_bit(TTY_PTY_LOCK, &tty->flags); /* LOCK THE SLAVE */
>  
> -	tty_add_file(tty, filp);
> +	retval = tty_add_file(tty, filp);
> +	if (retval)
> +		goto out1;
>  
>  	retval = devpts_pty_new(inode, tty->link);
>  	if (retval)

This needs devpts_kill_index() to reverse the successful 
devpts_new_index(), so I think it should be "goto out" and not "goto 
out1".
