Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756679Ab0G1XE1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 19:04:27 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:65184 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752373Ab0G1XEO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 19:04:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=M827Ie66Tk6Zs1kRldWiEQAkGZ81jYmiUqbHHeZXql4CeVjA3KtQ5cBcS73B8/TrKU
         3ifzQEbwYGVyoKBjCH0zMyV19nl5ySoKc2ZsodVT+uhGwbf1YBDF7yOKuLX17a73RWMF
         RxVirqFq8dIWD8zwDIYXco3JosZjw9ppPiN4w=
MIME-Version: 1.0
In-Reply-To: <AANLkTikiV7+qvy8rG0nFqFoYxYqmwBswZK76abqj5DVb@mail.gmail.com>
References: <1279906072-377-1-git-send-email-linus.walleij@stericsson.com>
	<AANLkTikiV7+qvy8rG0nFqFoYxYqmwBswZK76abqj5DVb@mail.gmail.com>
Date: Thu, 29 Jul 2010 01:04:12 +0200
Message-ID: <AANLkTikYj1rpUzsnzhc=ffWF3fL8YXwScXnmV_DTt3hL@mail.gmail.com>
Subject: Re: [PATCH] DMAENGINE: generic slave channel control v3
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        Alan Cox <alan@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/7/28 Dan Williams <dan.j.williams@intel.com>:

> What are the rules for when a new dma_slave_config can be set?

My idea is that these are done immediately before any work
to be carried out.

> Looking at the driver implementations it seems there is nothing
> preventing a concurrent call to device_control to occur at "wrong
> time"?  Is there a synchronization context I'm missing?

I do imagine that the code using this will be naturally serialized,
since you need to configure the channel before using it for
something. i.e. the channel is typically STOPPED. If you like
I can add checking for this to the coh901318 and ste_dma40
patches. (It wouldn't affect this one though.)

Drivers that want to support reconfiguring while a channel is
running a transfer may have to look harder.

Yours,
Linus Walleij
