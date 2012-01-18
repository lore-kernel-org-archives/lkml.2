Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757620Ab2AROJY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 09:09:24 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60820 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757578Ab2AROJW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 09:09:22 -0500
Date: Wed, 18 Jan 2012 06:09:04 -0800
From: Greg KH <gregkh@suse.de>
To: Pekka Enberg <penberg@kernel.org>
Cc: Leonid Moiseichuk <leonid.moiseichuk@nokia.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, cesarb@cesarb.net,
        kamezawa.hiroyu@jp.fujitsu.com, emunson@mgebm.net, aarcange@redhat.com,
        riel@redhat.com, mel@csn.ul.ie, rientjes@google.com, dima@android.com,
        rebecca@android.com, san@google.com, akpm@linux-foundation.org,
        vesa.jaaskelainen@nokia.com
Subject: Re: [PATCH v2 1/2] Making si_swapinfo exportable
Message-ID: <20120118140904.GB13817@suse.de>
References: <cover.1326803859.git.leonid.moiseichuk@nokia.com>
 <56cc3c5d40a8653b7d9bef856ff02d909b98f36f.1326803859.git.leonid.moiseichuk@nokia.com>
 <CAOJsxLHfHHrFyhfkSe8mbsnJHBkgKtksCZZDwN6K3d7KJqfzkQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOJsxLHfHHrFyhfkSe8mbsnJHBkgKtksCZZDwN6K3d7KJqfzkQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 18, 2012 at 12:34:19PM +0200, Pekka Enberg wrote:
> On Tue, Jan 17, 2012 at 3:22 PM, Leonid Moiseichuk
> <leonid.moiseichuk@nokia.com> wrote:
> > If we will make si_swapinfo() exportable it could be called from modules.
> > Otherwise modules have no interface to obtain information about swap usage.
> > Change made in the same way as si_meminfo() declared.
> >
> > Signed-off-by: Leonid Moiseichuk <leonid.moiseichuk@nokia.com>
> > ---
> >  mm/swapfile.c |    3 +++
> >  1 files changed, 3 insertions(+), 0 deletions(-)
> >
> > diff --git a/mm/swapfile.c b/mm/swapfile.c
> > index b1cd120..192cc25 100644
> > --- a/mm/swapfile.c
> > +++ b/mm/swapfile.c
> > @@ -5,10 +5,12 @@
> >  *  Swap reorganised 29.12.95, Stephen Tweedie
> >  */
> >
> > +#include <linux/export.h>
> >  #include <linux/mm.h>
> >  #include <linux/hugetlb.h>
> >  #include <linux/mman.h>
> >  #include <linux/slab.h>
> > +#include <linux/kernel.h>
> >  #include <linux/kernel_stat.h>
> >  #include <linux/swap.h>
> >  #include <linux/vmalloc.h>
> > @@ -2177,6 +2179,7 @@ void si_swapinfo(struct sysinfo *val)
> >        val->totalswap = total_swap_pages + nr_to_be_unused;
> >        spin_unlock(&swap_lock);
> >  }
> > +EXPORT_SYMBOL(si_swapinfo);

EXPORT_SYMBOL_GPL() perhaps?
