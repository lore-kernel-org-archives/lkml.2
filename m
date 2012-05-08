Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159Ab2EHSTC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 14:19:02 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59001 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752489Ab2EHSTA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 14:19:00 -0400
Message-ID: <4FA9637B.1060609@zytor.com>
Date: Tue, 08 May 2012 11:18:35 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH 2/3] pty: Lock the devpts bits privately
References: <20120503212151.568.91854.stgit@bob.linux.org.uk> <20120503212205.568.25804.stgit@bob.linux.org.uk>
In-Reply-To: <20120503212205.568.25804.stgit@bob.linux.org.uk>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/2012 02:22 PM, Alan Cox wrote:
> From: Alan Cox <alan@linux.intel.com>
> 
> This is a private pty affair, we don't want to tangle it with the tty_lock
> any more as we know all the other non tty locking is now handled by the vfs
> so we too can move.
> 
> Signed-off-by: Alan Cox <alan@linux.intel.com>

> +		        mutex_lock(&devpts_mutex);
>  			devpts_pty_kill(tty->link);
> +		        mutex_unlock(&devpts_mutex);

> +	mutex_lock(&devpts_mutex);
> +	tty = devpts_get_tty(pts_inode, idx);
> +	mutex_unlock(&devpts_mutex);

> +	mutex_lock(&devpts_mutex);
>  	tty = tty_init_dev(ptm_driver, index);
> +	mutex_unlock(&devpts_mutex);

Conceptually this seems fine, but it would seem cleaner to me to push
this mutex into the called functions in devpts; I suspect the lock could
be eliminated or at least be made per instance there (which would make
massive-container people happy...)

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

