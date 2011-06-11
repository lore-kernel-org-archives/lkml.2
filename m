Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752961Ab1FKRjd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jun 2011 13:39:33 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43032 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506Ab1FKRjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jun 2011 13:39:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=gBuBfqcaU0tRtn6a9poHkRVXsqG3CQZoexFiDxLWsHEkrjpu4qxPZd7qzH2KhWYHXz
         +OxDg0ib+9k2Atzy5haCG6mRXomneMt9EamEm611GCJ+pN09boKfOGmzHTzc1/V5lPqG
         CFnXNZJFum+BIj9uGX+V5PZbSGrXWNQgurJxw=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1106101728040.11814@ionos>
References: <17185480.5304.1307435255996.JavaMail.root@WARSBL214.highway.telekom.at>
	<alpine.LFD.2.02.1106071033350.11814@ionos>
	<4DEDF1F2.2080204@steinhoff.de>
	<1307439469.2322.235.camel@twins>
	<BANLkTi=KPyds_BWYpXHeUkAg000FGSuJOQ@mail.gmail.com>
	<20110607233517.GA31794@opentech.at>
	<BANLkTimYSEo4_3ecdEVaJxdME7n9=2Km8Q@mail.gmail.com>
	<alpine.LFD.2.02.1106082044040.11814@ionos>
	<BANLkTingXiRohBsaFbX9Jwr=Ba-ATqH4ag@mail.gmail.com>
	<alpine.LFD.2.02.1106101728040.11814@ionos>
Date: Sat, 11 Jun 2011 19:16:51 +0200
X-Google-Sender-Auth: NyEF2_FMyHC72hCH60HWXqrTlYw
Message-ID: <BANLkTimCwRYi0YTcu1jyZO=6=yqHnBF3iA@mail.gmail.com>
Subject: Re: Changing Kernel thread priorities
From: Remy Bohmer <linux@bohmer.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Nicholas Mc Guire <der.herr@hofr.at>,
        Peter Zijlstra <peterz@infradead.org>,
        Armin Steinhoff <armin@steinhoff.de>,
        Johannes Bauer <hannes_bauer@aon.at>,
        Monica Puig-Pey <puigpeym@unican.es>,
        Rolando Martins <rolando.martins@gmail.com>,
        linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> No, it's not. The root cause was a problem with the network softirq
> and a network driver, the softirq ->49 was a temporary workaround
> until we had enough information to find the real root cause. I wish
> I'd never committed that change at all.

Clear. Did not know it was already solved. I thought it was still an
issue. This changes things :-)

>> Race conditions that occur when a softirq preempts a related hardirq
>> what the driver did not expect or was designed for.
>
> And making it the other way round hides the problem, which is even
> worse. We want stuff to explode right away.

100% Agreed

> You can run into the same
> problem when the softirq holds a lock and the high prio irq thread
> boosts it.

OK.

Thanks for the explanation. I see no reason any more why setting the
prios default to 1 would be a bad thing.
The rest of the configuration in that case can then indeed done be
done by udev and other userland friends.

Kind regards,

Remy
