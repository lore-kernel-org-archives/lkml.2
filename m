Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751917Ab0DFFPf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 01:15:35 -0400
Received: from mga11.intel.com ([192.55.52.93]:58061 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751318Ab0DFFP3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 01:15:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.51,370,1267430400"; 
   d="scan'208";a="786720576"
Date: Tue, 6 Apr 2010 13:15:20 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Dave Jones <davej@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] /dev/mem: Allow rewinding
Message-ID: <20100406051520.GA18059@localhost>
References: <1270499041.9013.15.camel@edumazet-laptop> <1270501448.9013.23.camel@edumazet-laptop> <1270502345.9013.31.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1270502345.9013.31.camel@edumazet-laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 06, 2010 at 05:19:05AM +0800, Eric Dumazet wrote:
> Le lundi 05 avril 2010 à 23:04 +0200, Eric Dumazet a écrit :
> > Andrew, commit dcefafb6ac90ece8d68a6c203105f3d313e52da4 seems to be the
> > problem. 
> > 
> > It breaks rewinds (negative offsets to lseek (... SEEK_CUR))
> > 
> 
> Here is a patch to make rewind working again on /dev/mem

Looks good to me. Thanks for the fix!

Thanks,
Fengguang

> [PATCH] /dev/mem: Allow rewinding
> 
> commit dcefafb6 (/dev/mem: dont allow seek to last page)
> inadvertently disabled rewinding on /dev/mem.
> 
> This broke x86info for example.
> 
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> ---
> diff --git a/drivers/char/mem.c b/drivers/char/mem.c
> index 1f3215a..3973a1d 100644
> --- a/drivers/char/mem.c
> +++ b/drivers/char/mem.c
> @@ -710,11 +710,6 @@ static loff_t memory_lseek(struct file *file, loff_t offset, int orig)
>  	switch (orig) {
>  	case SEEK_CUR:
>  		offset += file->f_pos;
> -		if ((unsigned long long)offset <
> -		    (unsigned long long)file->f_pos) {
> -			ret = -EOVERFLOW;
> -			break;
> -		}
>  	case SEEK_SET:
>  		/* to avoid userland mistaking f_pos=-9 as -EBADF=-9 */
>  		if ((unsigned long long)offset >= ~0xFFFULL) {
> 
> 
