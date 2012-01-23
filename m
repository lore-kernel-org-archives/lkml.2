Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020Ab2AWUAk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 15:00:40 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:56741 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753803Ab2AWUAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 15:00:39 -0500
Date: Tue, 24 Jan 2012 00:00:34 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, mtk.man-pages@gmail.com
Subject: Re: [patch] Fix argument check for PR_SET_MM
Message-ID: <20120123200034.GJ1907@moon>
References: <4F1DBA56.7070903@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F1DBA56.7070903@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 24, 2012 at 08:51:50AM +1300, Michael Kerrisk wrote:
> From: Michael Kerrisk <mtk.manpages@gmail.com>
> 
> Cyrill,
> 
> I imagine that the small operator fix below gives the behavior you intended.
> Please apply.
> 
> Thanks,
> 
> Michael
> 
> Signed-off-by: Michael Kerrisk <mtk.manpages@gmail.com>
> 
> --- kernel/sys.c.orig	2012-01-24 07:26:44.986370466 +1300
> +++ kernel/sys.c	2012-01-24 07:27:52.202703776 +1300
> @@ -1703,7 +1703,7 @@ static int prctl_set_mm(int opt, unsigne
>  	int error = 0;
>  	struct mm_struct *mm = current->mm;
>  
> -	if (arg4 | arg5)
> +	if (arg4 || arg5)
>  		return -EINVAL;
>  
>  	if (!capable(CAP_SYS_ADMIN))
> 

Hi Michael, thanks. But actually (arg4 | arg5) will give nonzero result
if any of operands is not a zero ;) So no error here. From readability pov
sure this will be clear. Thanks, I'll update.

	Cyrill
