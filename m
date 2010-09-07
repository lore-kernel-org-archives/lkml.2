Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757967Ab0IGSKT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 14:10:19 -0400
Received: from n78.bullet.mail.sp1.yahoo.com ([98.136.44.42]:46819 "HELO
	n78.bullet.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756933Ab0IGSKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 14:10:15 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 678262.34264.bm@omp120.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type;
  b=WuyIrimc2wLGT0F8DdDQUY3Br3NgLGrROik1M4x8ZT84ET0YarZxN1hHvJw0AzIwET6J4wvh0qJaA7pc+BXIpGRZaW7r6YT8QiehzvDkZQObUwuwuYNN3ITq/za/lDkyAz8KNNTCfmDzgLPJI4bbf3cZBuYVRAzmGpkhuEIiy00=;
Message-ID: <569801.35222.qm@web180310.mail.gq1.yahoo.com>
X-YMail-OSG: hLMcrhQVM1mGpvuVqlx49LaOS5gJkFBzk0idNZ87PqohGVd
 EJ6IJkMRhGf5V2OCZOo82L2ttJiJwrVxJW6TZAis8XgFr3A41cG0nuLo0xfH
 V8qFTKKp7SqUcQ6MY3nCwYKtAcxWF4Z4wO.pUtw58Zt2spn8auAIZ1oHRIjQ
 q2WhP1pCEVh4aepw.Wo2BKYPWnQxDv6YpfjZqwFwioc1fhz.dTamYNkQ4twa
 IDfKMxWw4JzGM3gwQkQaH7_PQpjRnZ_5QaukYkQMmBVc4wqfIbSZ6QYhZYAy
 NGfV0GfYn8cxSNOrnvAcOI9B3bmf_OCVFxYSuF5do0rVv3s0NXX63748kLAH
 mcDBlzv4TCgMvYRC1Uk.7EfSb85ZdIn6V7Ls-
X-Mailer: YahooMailClassic/11.3.2 YahooMailWebService/0.8.105.279950
Date: Tue, 7 Sep 2010 11:10:14 -0700 (PDT)
From: David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH] pio: add arch specific gpio_is_valid() function
To: Eric Miao <eric.y.miao@gmail.com>, Ryan Mallon <ryan@bluewatersys.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
        avictor.za@gmail.com, bn@niasdigital.com,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <4C85BEFD.402@bluewatersys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--- On Mon, 9/6/10, Ryan Mallon <ryan@bluewatersys.com> wrote:

> >  The intent of my patch was to keep gpio_is_valid
> simple, but add
> a simple check for architectures where the base gpio is not
> zero. Will
> wait and see what David has to say.

NAK still.  You're trying to abuse gpio_is_valid(),
which I see no need to support.


In terms of GPIO framework architecture, zero is
the first GPIO in all cases, and is always
a valid GPIO number, even if it's not
requestable/swritable/readable on a given board.

Whether it's usable on a given platform depends
on whether a GPIO controller is registered which
claims numbers 0..N ... (assuming gpiolib in use).


