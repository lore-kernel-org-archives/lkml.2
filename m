Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757580Ab0FBDed (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 23:34:33 -0400
Received: from 64-131-60-146.usfamily.net ([64.131.60.146]:56998 "EHLO
	mail.sandeen.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755467Ab0FBDec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 23:34:32 -0400
Message-ID: <4C05D145.6080602@sandeen.net>
Date: Tue, 01 Jun 2010 22:34:29 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.24 (Macintosh/20100228)
MIME-Version: 1.0
To: Julia Lawall <julia@diku.dk>
CC: Alex Elder <aelder@sgi.com>, xfs-masters@oss.sgi.com, xfs@oss.sgi.com,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [xfs-masters] [PATCH 11/17] fs/xfs/quota: Add missing mutex_unlock
References: <Pine.LNX.4.64.1005261757050.23743@ask.diku.dk>
In-Reply-To: <Pine.LNX.4.64.1005261757050.23743@ask.diku.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> Add a mutex_unlock missing on the error path.  The use of this lock is
> balanced elsewhere in the file.
> 
> The semantic match that finds this problem is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> expression E1;
> @@
> 
> * mutex_lock(E1,...);
>   <+... when != E1
>   if (...) {
>     ... when != E1
> *   return ...;
>   }
>   ...+>
> * mutex_unlock(E1,...);
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> ---
> The use of ENOMEM rather than -ENOMEM is also a bit odd.

All the xfs core code uses positive errors, it's an irix holdover.

As things bubble up to the vfs interface, signs get switched.

Yeah, it's a bit odd, but nobody dares change it ;)

Maybe semantic patching could fix it ;)

-Eric

