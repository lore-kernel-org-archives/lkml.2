Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754198Ab0KIReP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 12:34:15 -0500
Received: from kroah.org ([198.145.64.141]:46804 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754098Ab0KIReM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 12:34:12 -0500
Date: Tue, 9 Nov 2010 09:27:13 -0800
From: Greg KH <greg@kroah.com>
To: Mike Waychison <mikew@google.com>
Cc: Am??rico Wang <xiyou.wangcong@gmail.com>, simon.kagstrom@netinsight.net,
        davem@davemloft.net, nhorman@tuxdriver.com,
        Matt Mackall <mpm@selenic.com>, adurbin@google.com,
        linux-kernel@vger.kernel.org, chavey@google.com,
        akpm@linux-foundation.org, linux-api@vger.kernel.org
Subject: Re: [PATCH v2 12/23] netpoll: Introduce netpoll_target configs
Message-ID: <20101109172713.GA11073@kroah.com>
References: <20101108203120.22479.19708.stgit@crlf.mtv.corp.google.com>
 <20101108203246.22479.60118.stgit@crlf.mtv.corp.google.com>
 <20101109033024.GA5220@cr0.nay.redhat.com>
 <20101109042732.GC5220@cr0.nay.redhat.com>
 <AANLkTingq8R8bc-4fwhBQomdhTgff+fN_vE-pc5zofKX@mail.gmail.com>
 <20101109090645.GG5220@cr0.nay.redhat.com>
 <20101109142053.GA3067@kroah.com>
 <AANLkTi=tUSMrCqnY3-868ugi=b2K78Z=SD=ZDJ36vBUJ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=tUSMrCqnY3-868ugi=b2K78Z=SD=ZDJ36vBUJ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 09, 2010 at 09:24:33AM -0800, Mike Waychison wrote:
> On Tue, Nov 9, 2010 at 6:20 AM, Greg KH <greg@kroah.com> wrote:
> > On Tue, Nov 09, 2010 at 05:06:45PM +0800, Am??rico Wang wrote:
> >> On Tue, Nov 09, 2010 at 12:34:24AM -0800, Mike Waychison wrote:
> >> >On Mon, Nov 8, 2010 at 8:27 PM, Am??rico Wang <xiyou.wangcong@gmail.com> wrote:
> >> >> On Tue, Nov 09, 2010 at 11:30:24AM +0800, Am??rico Wang wrote:
> >> >>>
> >> >> ....
> >> >>>
> >> >>>So, either we need to de-modulize configfs or replace configfs API
> >> >>>with sysfs API. Personally, I prefer the former one, I don't think
> >> >>>configfs should be a module as long as it can provide API's
> >> >>>for other subsystems, like debugfs.
> >> >>>
> >> >>
> >> >> To clarify, I meant "as long as the API it provides can be used by
> >> >> other core subsystems".
> >> >>
> >> >
> >> >Ya, I see the problem with it being a tristate.
> >> >
> >> >Why not just make netconsole support being compiled in force configfs
> >> >to be compiled in?  Or does that just set bad precedent?
> >>
> >> That is what netconsole does now, and this is fine, since netconsole is
> >> a module too, however, after you move that code into netpoll, then netpoll
> >> will have a dependence on it, we will have problems.
> >>
> >> I think we can let NETPOLL_TARGET depend on CONFIGFS_FS=y, but I still
> >> see no reason why CONFIGFS_FS should be a module.
> >
> > No, just have the NETPOLL_TARGET set CONFIG_FS to y, don't force the
> > code to always be that way if the user isn't going to want that option.
> 
> Can you clarify what you mean by "that way" here?

I think I can't remember, as this is a bit complex.

I'm just objecting to the changing of configfs to only be able to be
built into the kernel.  If this patch set requires configfs, great, then
set the value to "Y", but don't change configfs like the proposed patch
later in this email thread did.

thanks,

greg k-h
