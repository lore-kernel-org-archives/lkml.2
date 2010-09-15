Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754981Ab0IOWUP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 18:20:15 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52324 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744Ab0IOWUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 18:20:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=BC2hVyiR5Xl6dpAIqQ22F71Nz0qqNTLRVQk0A7K5poIUz9cNmQc9FBtPcfDQBP4IQ5
         LvQOSxG+Brzw7GrlwQdKZYc6hIyMgNKBDwzBlvkgHKXB1Cfl5BsOG32Ioqb1OIeTvHwG
         TSoKDrEj7ZZTfNrJY2G0P1BBPtS51qKIElSBA=
Subject: Re: [REGRESSION] cdrom drive doesn't detect removal
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>, Tejun Heo <tj@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
In-Reply-To: <AANLkTinGDUxsgaGey7EnYOu3kKP-YRE00gL33hiKvAWj@mail.gmail.com>
References: <1284284969.2928.18.camel@maxim-laptop>
	 <1284427621.4127.7.camel@maxim-laptop> <4C8F2699.3020509@kernel.org>
	 <AANLkTinGHB9fbLw1Cm5wvPLGy8QEuoBBmFiqpnvXiZ8R@mail.gmail.com>
	 <1284507516.4963.2.camel@maxim-laptop>
	 <AANLkTimFpyYab69=XQVZc+P50v6_uVr6UbA246Fnm3-u@mail.gmail.com>
	 <1284511071.3551.1.camel@maxim-laptop>
	 <AANLkTikF37hN7dFqPbCp-gcim7SarveaTrjXipnGpJM7@mail.gmail.com>
	 <20100915132731.GA20558@khazad-dum.debian.net>
	 <AANLkTinGDUxsgaGey7EnYOu3kKP-YRE00gL33hiKvAWj@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 16 Sep 2010 00:20:07 +0200
Message-ID: <1284589207.4672.3.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-09-15 at 15:44 +0200, Kay Sievers wrote: 
> On Wed, Sep 15, 2010 at 15:27, Henrique de Moraes Holschuh
> <hmh@hmh.eng.br> wrote:
> > On Wed, 15 Sep 2010, Kay Sievers wrote:
> >> It's only the polling that should be able to trigger these events for
> >> the device. the device itself can't report any changes to the host,
> >> unless you have a SATA drive which can send AN (async notification)
> >> events. But we disabled the AN support recently, because it was
> >> running in loops on some boxes.
> >
> > Is it so widespread or extremely difficult to detect, that it justifies
> > breaking AN for all users?
> 
> Yes. It's not properly implemented, and many drives just always send
> an event on access, regardless if the media is changed or not. To work
> properly, it will need in-kernel media presence polling, which is
> being worked on. The current AN events, the stuff the drives send, and
> the way it is handled in the kernel, is just not usable.
> 
> > Anyway, if userspace thinks AN is available, it won't pool or touch
> > /dev/sr*, which would explain the problem (but one still would have to find
> > the root cause: why userspace thinks it doesn't need to pool?).
> 
> There is no userspace checking for AN support right now. It wouldn't
> work anyway. And the only thing that makes sense is to move the
> polling in the kernel regardless of AN support or not, and make
> userspace check for that and skip polling when the kernel takes care.

So it makes the sense.
It turns out that hal is still running on ubuntu systems, and yes, it
still polls the drives, and yes I disabled that feature....
So restoring that polling feature indeed fixes that problem for now.
Yet, why without that commit detection did work?

Best regards,
Maxim Levitsky

