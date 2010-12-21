Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754Ab0LUT2X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 14:28:23 -0500
Received: from mail-px0-f179.google.com ([209.85.212.179]:55512 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223Ab0LUT2W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 14:28:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=OsG8gebQEE9o4GhBiaiP8LlgFy5/P7J+xf1AQkCeFzXBLJ29kWT0s4rV4nrNk1vFdy
         eE2N+FjcB2tI4nviR3MNJBauA8wIoyK+FJzhMoTz6aAkgWFwKHiu5wJMj4NUWh0ZRmpL
         +8Tpyf7Xq3kjBl1Sr46oPpK22CX4BjVZvP1Zw=
MIME-Version: 1.0
In-Reply-To: <AANLkTin=U6j4XTmCq4H4sKivD+jecxor3Q-7mYFDfD=N@mail.gmail.com>
References: <1292866298-8585-1-git-send-email-per.forlin@stericsson.com>
	<AANLkTi=7E7rAc=46p5d6YSpLeut5yehmBtLa4TVofefp@mail.gmail.com>
	<AANLkTin=U6j4XTmCq4H4sKivD+jecxor3Q-7mYFDfD=N@mail.gmail.com>
Date: Tue, 21 Dec 2010 20:28:21 +0100
Message-ID: <AANLkTik94Go7W4AMquncm-novWkHtLOBRn7BfpepoEZz@mail.gmail.com>
Subject: Re: [PATCH] dmaengine: dma40: Add support to split up large elements
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Per Forlin <per.forlin@stericsson.com>, linux-kernel@vger.kernel.org,
        Per Forlin <per.forlin@linaro.org>,
        Rabin VINCENT <rabin.vincent@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/12/21 Dan Williams <dan.j.williams@intel.com>:

> If that is the case then the temporary fix for 2.6.37 is along the
> lines of fixing up the clients to not submit such large requests.

They don't, currently. We actually had some debate about this
internally, because the only driver submitting something >64K-1
was the MMCI driver (which is yet not in mainline) and yes, indeed
the suggested solution was to amend the MMCI driver
for the time being.

I insisted on doing this fix anyway because I was under the
impression that memcpy() is supposed to handle *any* size of
request, is this the intention?

Since its semantics are not documented as far as I can see I
was maybe misguided in assuming that any size of buffer should
be possible to pass in... :-(

>  You
> mention the "memcpy api contract" can this be triggered outside of
> dmatest?

Nope. That and out-of-tree MMCI.

So for the next merge window it is, if the patch is semantically
correct.

Yours,
Linus Walleij
