Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399Ab2KUQyq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 11:54:46 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:33987 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755336Ab2KUQyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 11:54:44 -0500
Date: Wed, 21 Nov 2012 08:54:39 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, patches@linaro.org
Subject: Re: [PATCH 1/1] tty: vt: Remove redundant null check before kfree.
Message-ID: <20121121165439.GA4421@kroah.com>
References: <1353475147-28308-1-git-send-email-sachin.kamat@linaro.org>
 <20121121144624.GA21766@kroah.com>
 <CAK9yfHy9Pnaoc-bdynFAE=U7=Njz00T8FRdLXTRvhopSxXS9Ng@mail.gmail.com>
 <20121121151604.GA21983@kroah.com>
 <CAK9yfHw=AjCQ+1VsXLZa=wtNopoZxSsd3xSa+_UDNYOOohY2dg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK9yfHw=AjCQ+1VsXLZa=wtNopoZxSsd3xSa+_UDNYOOohY2dg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 21, 2012 at 08:59:08PM +0530, Sachin Kamat wrote:
> On 21 November 2012 20:46, Greg KH <gregkh@linuxfoundation.org> wrote:
> > On Wed, Nov 21, 2012 at 08:21:40PM +0530, Sachin Kamat wrote:
> >> On 21 November 2012 20:16, Greg KH <gregkh@linuxfoundation.org> wrote:
> >> > On Wed, Nov 21, 2012 at 10:49:07AM +0530, Sachin Kamat wrote:
> >> >> kfree on a NULL pointer is a no-op.
> >> >>
> >> >> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> >> >> ---
> >> >>  drivers/tty/vt/consolemap.c |    6 ++----
> >> >>  1 files changed, 2 insertions(+), 4 deletions(-)
> >> >>
> >> >> diff --git a/drivers/tty/vt/consolemap.c b/drivers/tty/vt/consolemap.c
> >> >> index 2aaa0c2..248381b 100644
> >> >> --- a/drivers/tty/vt/consolemap.c
> >> >> +++ b/drivers/tty/vt/consolemap.c
> >> >> @@ -410,10 +410,8 @@ static void con_release_unimap(struct uni_pagedir *p)
> >> >>               kfree(p->inverse_translations[i]);
> >> >>               p->inverse_translations[i] = NULL;
> >> >>       }
> >> >> -     if (p->inverse_trans_unicode) {
> >> >> -             kfree(p->inverse_trans_unicode);
> >> >> -             p->inverse_trans_unicode = NULL;
> >> >> -     }
> >> >> +     kfree(p->inverse_trans_unicode);
> >> >> +     p->inverse_trans_unicode = NULL;
> >> >
> >> > kfree with NULL is a no-op, but the line after that just caused a kernel
> >> > crash if it was NULL, so I can't accept this type of thing.
> >> >
> >> > Please be more careful.
> >>
> >> My mistake. Apologies for the same.
> >>
> >> Do we need to assign the pointer to NULL after freeing?
> >
> > It depends if it is checked later on, is it?
> 
> I will re-send this patch after deleting the assignment?

You tell me, please determine if it really is correct or not, before
sending a patch.  You did test this, right?

greg k-h
