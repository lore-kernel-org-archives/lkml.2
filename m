Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757618Ab2IDSy0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 14:54:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18521 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757538Ab2IDSyZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 14:54:25 -0400
Date: Tue, 4 Sep 2012 21:55:41 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Sjur =?iso-8859-1?Q?Br=E6ndeland?= <sjurbren@gmail.com>
Cc: Amit Shah <amit.shah@redhat.com>, linux-kernel@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        virtualization@lists.linux-foundation.org
Subject: Re: [RFC 1/2] virtio_console: Add support for DMA memory allocation
Message-ID: <20120904185541.GB3602@redhat.com>
References: <1346680277-5887-1-git-send-email-sjur.brandeland@stericsson.com>
 <20120903143018.GA5353@redhat.com>
 <CAJK669bkHHMAPYMEr22-6uOwfgJv1uKTbzNBQVVCq=OooExC0g@mail.gmail.com>
 <20120903202737.GD6181@redhat.com>
 <CAJK669ZvnnG6fGOog-Z47B7xqyn9hcx5dAD7S--+2PSgE+hrLA@mail.gmail.com>
 <20120904135022.GI9805@redhat.com>
 <CAJK669Z1UYakBWartChfoeKL_eU5=GFZMGhH8R_Q-difVm0ygQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJK669Z1UYakBWartChfoeKL_eU5=GFZMGhH8R_Q-difVm0ygQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 04, 2012 at 06:58:47PM +0200, Sjur Brændeland wrote:
> Hi Michael,
> 
> > Exactly. Though if we just fail load it will be much less code.
> >
> > Generally, using a feature bit for this is a bit of a problem though:
> > normally driver is expected to be able to simply ignore
> > a feature bit. In this case driver is required to
> > do something so a feature bit is not a good fit.
> > I am not sure what the right thing to do is.
> 
> I see - so in order to avoid the binding between driver and device
> there are two options I guess. Either make virtio_dev_match() or
> virtcons_probe() fail. Neither of them seems like the obvious choice.
> 
> Maybe adding a check for VIRTIO_CONSOLE_F_DMA_MEM match
> between device and driver in virtcons_probe() is the lesser evil?
> 
> Regards,
> Sjur

A simplest thing to do is change dev id. rusty?

-- 
MST
