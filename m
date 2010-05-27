Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757438Ab0E0OcP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 10:32:15 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:55023 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754518Ab0E0OcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 10:32:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=m/yj5qG6Xb/ljqharKfQlqoY1gGrBrSzNeFcleDSPGbCIHNCfZAJRtsaATGK/2WAqA
         wgqLFMrgFqz0cAZzYI6S9q0GQU3yHnryMwNjobtMihbLpdsU7E+QclBUPQYS81r8e/TJ
         xCascRzzm59Gvdfkj51ne8BoJv/mxC47JUyM4=
Date: Thu, 27 May 2010 23:31:34 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Rik van Riel <riel@redhat.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Mel Gorman <mel@csn.ul.ie>,
       Andrea Arcangeli <aarcange@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: Re: [PATCH 5/5] extend KSM refcounts to the anon_vma root
Message-ID: <20100527143134.GA9505@barrios-desktop>
References: <20100526153819.6e5cec0d@annuminas.surriel.com>
 <20100526154124.04607d04@annuminas.surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100526154124.04607d04@annuminas.surriel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 26, 2010 at 03:41:24PM -0400, Rik van Riel wrote:
> Subject: extend KSM refcounts to the anon_vma root
> 
> KSM reference counts can cause an anon_vma to exist after the processe
> it belongs to have already exited.  Because the anon_vma lock now lives
> in the root anon_vma, we need to ensure that the root anon_vma stays
> around until after all the "child" anon_vmas have been freed.
> 
> The obvious way to do this is to have a "child" anon_vma take a
> reference to the root in anon_vma_fork.  When the anon_vma is freed
> at munmap or process exit, we drop the refcount in anon_vma_unlink
> and possibly free the root anon_vma.
> 
> The KSM anon_vma reference count function also needs to be modified
> to deal with the possibility of freeing 2 levels of anon_vma.  The
> easiest way to do this is to break out the KSM magic and make it
> generic.
> 
> When compiling without CONFIG_KSM, this code is compiled out.
> 
> Signed-off-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

Now I understand this patch. 
Thanks, Rik. 
-- 
Kind regards,
Minchan Kim
