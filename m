Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116Ab0LTCpA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 21:45:00 -0500
Received: from thunk.org ([69.25.196.29]:47090 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751576Ab0LTCo7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 21:44:59 -0500
Date: Sun, 19 Dec 2010 21:44:55 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andreas Dilger <adilger.kernel@dilger.ca>
Subject: Re: ext4: Take advantage of kmem_cache_zalloc() in
 ext4_init_io_end()
Message-ID: <20101220024455.GB24990@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>, Jesper Juhl <jj@chaosbits.net>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Andreas Dilger <adilger.kernel@dilger.ca>
References: <alpine.LNX.2.00.1012092257290.25880@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1012092257290.25880@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 09, 2010 at 12:17:34PM -0000, Jesper Juhl wrote:
> Take advantage of kmem_cache_zalloc(). Save a memset() call in 
> ext4_init_io_end() and save a few bytes.
> 
> Before:
>  [jj@dragon linux-2.6]$ size fs/ext4/page-io.o
>     text    data     bss     dec     hex filename
>     3016       0     624    3640     e38 fs/ext4/page-io.o
> After:
>  [jj@dragon linux-2.6]$ size fs/ext4/page-io.o
>     text    data     bss     dec     hex filename
>     3000       0     624    3624     e28 fs/ext4/page-io.o
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

Thanks, added to the ext4 patch queue.

						- Ted
