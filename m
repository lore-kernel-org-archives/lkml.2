Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754425Ab1JQUQO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 16:16:14 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:17563 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754103Ab1JQUQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 16:16:13 -0400
From: Dmitry Torokhov <dtor@vmware.com>
Organization: VMware, Inc.
To: Rakib Mullick <rakib.mullick@gmail.com>
Subject: Re: [PATCH] drivers, vmw_balloon.c: Determine page allocation flag can_sleep outside loop.
Date: Mon, 17 Oct 2011 13:16:11 -0700
User-Agent: KMail/1.13.7 (Linux/3.1.0-rc9+; KDE/4.6.5; x86_64; ; )
Cc: David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
References: <1318875227.10091.5.camel@localhost.localdomain> <alpine.DEB.2.00.1110171231030.12560@chino.kir.corp.google.com> <CADZ9YHiurKJPiDjVzhcjGtfOGF2gNPNi5eC1snT0Tw5opBSM8w@mail.gmail.com>
In-Reply-To: <CADZ9YHiurKJPiDjVzhcjGtfOGF2gNPNi5eC1snT0Tw5opBSM8w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201110171316.12057.dtor@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, October 17, 2011 01:10:38 PM Rakib Mullick wrote:
> On Tue, Oct 18, 2011 at 1:31 AM, David Rientjes <rientjes@google.com> 
wrote:
> > On Tue, 18 Oct 2011, Rakib Mullick wrote:
> >> diff --git a/drivers/misc/vmw_balloon.c b/drivers/misc/vmw_balloon.c
> >> index 053d36c..6983d80 100644
> >> --- a/drivers/misc/vmw_balloon.c
> >> +++ b/drivers/misc/vmw_balloon.c
> >> @@ -412,6 +412,7 @@ static int vmballoon_reserve_page(struct
> >> vmballoon *b, bool can_sleep) gfp_t flags;
> >>       unsigned int hv_status;
> >>       bool locked = false;
> >> +     flags = can_sleep ? VMW_PAGE_ALLOC_CANSLEEP :
> >> VMW_PAGE_ALLOC_NOSLEEP;
> >> 
> >>       do {
> >>               if (!can_sleep)
> > 
> > Should be folded in with the declaration of gfp_t flags.
> > 
> > Would you also like to add a might_sleep_if(can_sleep) here?
> 
> I'm not sure. But, I don't think it's needed here. can_sleep tells
> whether alloc_page can sleep or not, which has been determined and
> passed by the callee function.
> 

vmballon_reserve_page() is always called from workqueue context and
thus is always allowed to sleep. I do not see the benefit of adding
might_sleep() here.

Thanks,
Dmitry

> 
> Thanks,
> Rakib
