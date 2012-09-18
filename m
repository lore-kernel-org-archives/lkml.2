Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755784Ab2IRWWj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 18:22:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29577 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755167Ab2IRWWi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 18:22:38 -0400
Date: Wed, 19 Sep 2012 01:24:05 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Sjur =?iso-8859-1?Q?Br=E6ndeland?= <sjurbren@gmail.com>,
        Amit Shah <amit.shah@redhat.com>, linux-kernel@vger.kernel.org,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH repost] virtio: don't crash when device is buggy
Message-ID: <20120918222405.GB20285@redhat.com>
References: <20120903143018.GA5353@redhat.com>
 <CAJK669bkHHMAPYMEr22-6uOwfgJv1uKTbzNBQVVCq=OooExC0g@mail.gmail.com>
 <20120903202737.GD6181@redhat.com>
 <CAJK669ZvnnG6fGOog-Z47B7xqyn9hcx5dAD7S--+2PSgE+hrLA@mail.gmail.com>
 <20120904135022.GI9805@redhat.com>
 <CAJK669Z1UYakBWartChfoeKL_eU5=GFZMGhH8R_Q-difVm0ygQ@mail.gmail.com>
 <20120904185541.GB3602@redhat.com>
 <87k3w7j49i.fsf@rustcorp.com.au>
 <20120916094427.GA24075@redhat.com>
 <87ehm1s28q.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ehm1s28q.fsf@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2012 at 01:57:17PM +0930, Rusty Russell wrote:
> "Michael S. Tsirkin" <mst@redhat.com> writes:
> 
> > Because of a sanity check in virtio_dev_remove, a buggy device can crash
> > kernel.  And in case of rproc it's userspace so it's not a good idea.
> > We are unloading a driver so how bad can it be?
> > Be less aggressive in handling this error: if it's a driver bug,
> > warning once should be enough.
> >
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> >
> > --
> >
> > 3.6 material?
> 
> I have already applied, this, but it's not for stable, since it's a
> "theoretical bugfix".  That check has been in there forever and noone
> AFAIK has actually struck it.
> 
> Cheers,
> Rusty.

Yes but can't malicious userspace trigger this with remoteproc? If yes
it's not a question of whether anyone has struck it since people don't
normally run malicious userspace :)

-- 
MST
