Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753723Ab0FCMqF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 08:46:05 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:56190 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753644Ab0FCMqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 08:46:03 -0400
Date: Thu, 3 Jun 2010 13:45:44 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Cc: Dan Carpenter <error27@gmail.com>, Matthew Wilcox <matthew@wil.cx>,
       Andrew Morton <akpm@linux-foundation.org>,
       Oleg Nesterov <oleg@redhat.com>, Jens Axboe <jens.axboe@oracle.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] fcntl: return -EFAULT if copy_to_user fails
Message-ID: <20100603124544.GX31073@ZenIV.linux.org.uk>
References: <20100603100402.GR5483@bicker>
 <4C07826A.6060302@oss.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C07826A.6060302@oss.ntt.co.jp>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 03, 2010 at 07:22:34PM +0900, Takuya Yoshikawa wrote:
> (2010/06/03 19:04), Dan Carpenter wrote:
> >copy_to_user() returns the number of bytes remaining, but we want to
> >return -EFAULT.
> >
> >	ret = fcntl(fd, F_SETOWN_EX, NULL);
> >
> >With the original code ret would be 8 here.
> >
> >Signed-off-by: Dan Carpenter<error27@gmail.com>
> 
> How about f_getown_ex() ?
> 
> 	if (!ret)
> 		ret = copy_to_user(owner_p, &owner, sizeof(owner));
> 	return ret;
> 
> Fixing this too would be better, I think.
> 
>   Takuya

Applied, will push today.
