Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423Ab2GEH77 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 03:59:59 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:47777 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753458Ab2GEH76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 03:59:58 -0400
MIME-Version: 1.0
In-Reply-To: <1340988354-26981-1-git-send-email-vincent.sanders@collabora.co.uk>
References: <1340988354-26981-1-git-send-email-vincent.sanders@collabora.co.uk>
Date: Thu, 5 Jul 2012 09:59:53 +0200
X-Google-Sender-Auth: Rg_LQ63G8oBAwO1F60i7S3nGq4M
Message-ID: <CAKnu2Mr_TWvBXmL+ORfddpEgPdPxPXFpJdCtvPe+imj6o6Y+1w@mail.gmail.com>
Subject: Re: AF_BUS socket address family
From: Linus Walleij <linus.walleij@linaro.org>
To: Vincent Sanders <vincent.sanders@collabora.co.uk>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
        Daniel Walker <dwalker@fifo99.com>,
        John Stultz <john.stultz@linaro.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Greg Kroah-Hartman <greg@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/6/29 Vincent Sanders <vincent.sanders@collabora.co.uk>:

> AF_BUS is a message oriented inter process communication system.

We have a very huge and important in-kernel IPC message passer
in drivers/staging/android/binder.c

It's deployed in some 400 million devices according to latest reports.
John Stultz & Anton Vorontsov are trying to look after these Android
drivers a bit...

I and others discussed this in the past with the Android folks. Dianne
makes an excellent summary of how it works here:
https://lkml.org/lkml/2009/6/25/3

If we could all be convinced that this thing also fulfills the needs
of what binder does, this is a pretty solid case for it too. I can
sure see that some of the shortcuts that Android is taking with
binder try to address the same issue of high-speed IPC loopholes
through the kernel and some kind of security model.

Whether Android would actually use it (or wrap it) is a totally
different question, but what I think we need to know is whether it
*could*. And staging code has to move forward, maybe this
is the direction it should move?

Yours,
Linus Walleij
