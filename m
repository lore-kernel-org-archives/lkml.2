Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751195Ab1IUVMK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 17:12:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56401 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750962Ab1IUVMG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 17:12:06 -0400
Date: Wed, 21 Sep 2011 14:10:07 -0700
From: Greg KH <gregkh@suse.de>
To: "kautuk.c @samsung.com" <consul.kautuk@gmail.com>
Cc: Jiri Kosina <trivial@kernel.org>, jkosina@suse.cz,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Trivial: devtmpfsd: Setting task
 running/interruptible states
Message-ID: <20110921211007.GA13605@suse.de>
References: <1316619573-9104-1-git-send-email-consul.kautuk@gmail.com>
 <20110921155444.GA27121@suse.de>
 <CAFPAmTR1bHBronJqVWh_osjJvsPi_gWqJ50Ls-WgCi7CMAViUA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFPAmTR1bHBronJqVWh_osjJvsPi_gWqJ50Ls-WgCi7CMAViUA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 21, 2011 at 09:54:01PM +0530, kautuk.c @samsung.com wrote:
> Hi Greg,
> 
> On Wed, Sep 21, 2011 at 9:24 PM, Greg KH <gregkh@suse.de> wrote:
> > On Wed, Sep 21, 2011 at 09:09:33PM +0530, Kautuk Consul wrote:
> >> This trivial patch makes the following changes in devtmpfsd() :
> >
> > This is not the definition of "trivial" in that you are changing the
> > logic of the code, not just doing spelling changes.
> 
> Well, I didn't really change the performance/functionality so I called
> it trivial.

You changed the code logic, which is not trivial at all in this area.

And actually unneeded from what I can tell, right?

> >
> >> - Set the state to TASK_INTERRUPTIBLE using __set_current_state
> >>   instead of set_current_state as the spin_unlock is an implicit
> >>   memory barrier.
> >
> > Why?  What is this hurting with the original code?
> 
> Nothing really hurting, that's why I called this patch trivial.
> There is an extra memory barrier we have to go through by way of
> set_current_state, which is mb().
> That would lead to more overhead on the parallel pipelines of the processor
> as they will have to cease being parallel for instructions before and after
> the memory barrier despite the fact that the spin_unlock already covers this.
> We can do without this because as per the Documentation/memory-barriers.txt,
> atomic operations and unlocks give reliable ordering to instructions.

But the current code is correct, and not hurting anything, and it's not
on a "fast path" at all, so I'd prefer to keep it as-is and not change
it for the sake of changing it, so I'm not going to accept this patch,
sorry.

greg k-h
