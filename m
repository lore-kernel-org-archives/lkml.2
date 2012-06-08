Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965023Ab2FHWEc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 18:04:32 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:46765 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964922Ab2FHWEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 18:04:31 -0400
Date: Fri, 8 Jun 2012 18:04:24 -0400
From: Konrad Rzeszutek Wilk <konrad@darnok.org>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: dan.magenheimer@oracle.com, konrad.wilk@oracle.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/10] minor frontswap cleanups and tracing support
Message-ID: <20120608220422.GA15294@localhost.localdomain>
References: <1339182919-11432-1-git-send-email-levinsasha928@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339182919-11432-1-git-send-email-levinsasha928@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2012 at 09:15:09PM +0200, Sasha Levin wrote:
> Most of these patches are minor cleanups to the mm/frontswap.c code, the big
> chunk of new code can be attributed to the new tracing support.
> 
> 
> Changes in v2:
>  - Rebase to current version
>  - Address Konrad's comments

There was one comment that I am not sure if it was emailed and that
was about adding the "lockdep_assert_held(&swap_lock);".

You added that in two patches, while the git commit only talks about
"move that code" . Please remove it out of the "move the code" patches
and add it as a seperate git commit with an explanation of why it
is added.

Otherwise (well, the compile issue that was spotted) the patches
look great. Could you repost them with those two fixes please?

> 
> Sasha Levin (10):
>   mm: frontswap: remove casting from function calls through ops
>     structure
>   mm: frontswap: trivial coding convention issues
>   mm: frontswap: split out __frontswap_curr_pages
>   mm: frontswap: split out __frontswap_unuse_pages
>   mm: frontswap: split frontswap_shrink further to simplify locking
>   mm: frontswap: make all branches of if statement in put page
>     consistent
>   mm: frontswap: remove unnecessary check during initialization
>   mm: frontswap: add tracing support
>   mm: frontswap: split out function to clear a page out
>   mm: frontswap: remove unneeded headers
> 
>  include/trace/events/frontswap.h |  167 ++++++++++++++++++++++++++++++++++++++
>  mm/frontswap.c                   |  162 +++++++++++++++++++++++-------------
>  2 files changed, 270 insertions(+), 59 deletions(-)
>  create mode 100644 include/trace/events/frontswap.h
> 
> -- 
> 1.7.8.6
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 
