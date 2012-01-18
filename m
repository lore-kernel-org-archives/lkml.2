Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805Ab2ARKeW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 05:34:22 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:64328 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752719Ab2ARKeU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 05:34:20 -0500
MIME-Version: 1.0
In-Reply-To: <56cc3c5d40a8653b7d9bef856ff02d909b98f36f.1326803859.git.leonid.moiseichuk@nokia.com>
References: <cover.1326803859.git.leonid.moiseichuk@nokia.com>
	<56cc3c5d40a8653b7d9bef856ff02d909b98f36f.1326803859.git.leonid.moiseichuk@nokia.com>
Date: Wed, 18 Jan 2012 12:34:19 +0200
X-Google-Sender-Auth: p_tDbwuKA_4Vmtc2IlZ3vozC5_U
Message-ID: <CAOJsxLHfHHrFyhfkSe8mbsnJHBkgKtksCZZDwN6K3d7KJqfzkQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] Making si_swapinfo exportable
From: Pekka Enberg <penberg@kernel.org>
To: Leonid Moiseichuk <leonid.moiseichuk@nokia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cesarb@cesarb.net,
        kamezawa.hiroyu@jp.fujitsu.com, emunson@mgebm.net, aarcange@redhat.com,
        riel@redhat.com, mel@csn.ul.ie, rientjes@google.com, dima@android.com,
        gregkh@suse.de, rebecca@android.com, san@google.com,
        akpm@linux-foundation.org, vesa.jaaskelainen@nokia.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 17, 2012 at 3:22 PM, Leonid Moiseichuk
<leonid.moiseichuk@nokia.com> wrote:
> If we will make si_swapinfo() exportable it could be called from modules.
> Otherwise modules have no interface to obtain information about swap usage.
> Change made in the same way as si_meminfo() declared.
>
> Signed-off-by: Leonid Moiseichuk <leonid.moiseichuk@nokia.com>
> ---
>  mm/swapfile.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
>
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index b1cd120..192cc25 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -5,10 +5,12 @@
>  *  Swap reorganised 29.12.95, Stephen Tweedie
>  */
>
> +#include <linux/export.h>
>  #include <linux/mm.h>
>  #include <linux/hugetlb.h>
>  #include <linux/mman.h>
>  #include <linux/slab.h>
> +#include <linux/kernel.h>
>  #include <linux/kernel_stat.h>
>  #include <linux/swap.h>
>  #include <linux/vmalloc.h>
> @@ -2177,6 +2179,7 @@ void si_swapinfo(struct sysinfo *val)
>        val->totalswap = total_swap_pages + nr_to_be_unused;
>        spin_unlock(&swap_lock);
>  }
> +EXPORT_SYMBOL(si_swapinfo);

FWIW, I'm completely OK with this export:

  Acked-by: Pekka Enberg <penberg@kernel.org>
