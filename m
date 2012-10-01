Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752204Ab2JALhK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 07:37:10 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:48876 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328Ab2JALhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 07:37:08 -0400
Date: Mon, 1 Oct 2012 13:36:43 +0200
From: Daniel Kiper <daniel.kiper@oracle.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: andrew.cooper3@citrix.com, xen-devel <xen-devel@lists.xen.org>,
        konrad.wilk@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/11] kexec: introduce kexec_ops struct
Message-ID: <20121001113046.GA2942@host-192-168-1-59.local.net-space.pl>
References: <1348769198-29580-1-git-send-email-daniel.kiper@oracle.com>
 <1348769198-29580-2-git-send-email-daniel.kiper@oracle.com>
 <5065729C020000780009E63B@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5065729C020000780009E63B@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 08:49:16AM +0100, Jan Beulich wrote:
> >>> On 27.09.12 at 20:06, Daniel Kiper <daniel.kiper@oracle.com> wrote:
> > Some kexec/kdump implementations (e.g. Xen PVOPS) on different archs could
> > not use default functions or require some changes in behavior of kexec/kdump
> > generic code. To cope with that problem kexec_ops struct was introduced.
> > It allows a developer to replace all or some functions and control some
> > functionality of kexec/kdump generic code.
>
> I'm not convinced that doing this at the architecture independent
> layer is really necessary/desirable. Nevertheless, if that's the right
> place, then everything else looks good to me, except for a
> cosmetic thing:

I do not like this patch, too. However, this is the simplest
solution. If you do not do that in that way then you must
duplicate most of kernel/kexec.c functionality in architecture
depndent files.

> > @@ -392,7 +435,7 @@ static void kimage_free_page_list(struct list_head *list)
> >
> >  		page = list_entry(pos, struct page, lru);
> >  		list_del(&page->lru);
> > -		kimage_free_pages(page);
> > +		(*kexec_ops.kimage_free_pages)(page);
>
> These constructs are generally better readable without the
> explicit yet redundant indirection:
>
> 		kexec_ops.kimage_free_pages(page);

I have done that in that way because during my work on memory hotplug
Andrew Morton aligned my patches to that syntax. However,
I do not insist on staying with it.

Daniel
