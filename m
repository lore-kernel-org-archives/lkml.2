Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343Ab2IFDA4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 23:00:56 -0400
Received: from ozlabs.org ([203.10.76.45]:55569 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754161Ab2IFDAx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 23:00:53 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>,
        Sjur =?utf-8?Q?Br=C3=A6ndeland?= <sjurbren@gmail.com>
Cc: Amit Shah <amit.shah@redhat.com>, linux-kernel@vger.kernel.org,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        virtualization@lists.linux-foundation.org
Subject: Re: [RFC 1/2] virtio_console: Add support for DMA memory allocation
In-Reply-To: <20120904185541.GB3602@redhat.com>
References: <1346680277-5887-1-git-send-email-sjur.brandeland@stericsson.com> <20120903143018.GA5353@redhat.com> <CAJK669bkHHMAPYMEr22-6uOwfgJv1uKTbzNBQVVCq=OooExC0g@mail.gmail.com> <20120903202737.GD6181@redhat.com> <CAJK669ZvnnG6fGOog-Z47B7xqyn9hcx5dAD7S--+2PSgE+hrLA@mail.gmail.com> <20120904135022.GI9805@redhat.com> <CAJK669Z1UYakBWartChfoeKL_eU5=GFZMGhH8R_Q-difVm0ygQ@mail.gmail.com> <20120904185541.GB3602@redhat.com>
User-Agent: Notmuch/0.13.2 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Thu, 06 Sep 2012 11:34:25 +0930
Message-ID: <87k3w7j49i.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Michael S. Tsirkin" <mst@redhat.com> writes:
> On Tue, Sep 04, 2012 at 06:58:47PM +0200, Sjur Brændeland wrote:
>> Hi Michael,
>> 
>> > Exactly. Though if we just fail load it will be much less code.
>> >
>> > Generally, using a feature bit for this is a bit of a problem though:
>> > normally driver is expected to be able to simply ignore
>> > a feature bit. In this case driver is required to
>> > do something so a feature bit is not a good fit.
>> > I am not sure what the right thing to do is.
>> 
>> I see - so in order to avoid the binding between driver and device
>> there are two options I guess. Either make virtio_dev_match() or
>> virtcons_probe() fail. Neither of them seems like the obvious choice.
>> 
>> Maybe adding a check for VIRTIO_CONSOLE_F_DMA_MEM match
>> between device and driver in virtcons_probe() is the lesser evil?
>> 
>> Regards,
>> Sjur
>
> A simplest thing to do is change dev id. rusty?

For generic usage, this is correct.  But my opinion is that fallback on
feature non-ack is quality-of-implementation issue: great to have, but
there are cases where you just want to fail with "you're too old".

And in this case, an old system simply will never work.  So it's a
question of how graceful the failure is.

Can your userspace loader can refuse to proceed if the driver doesn't
ack the bits?  If so, it's simpler than a whole new ID.

Cheers,
Rusty.
