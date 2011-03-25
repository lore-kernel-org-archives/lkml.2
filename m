Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498Ab1CYWlm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 18:41:42 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55156 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754853Ab1CYWll convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 18:41:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ZlVVP9ar4GL1JavxLPCwdKK9rY/JcxAmnwPM9bq8PgnWsG32BEIyQtDMIVeCJRqmV4
         vNdOCE2Ckin3tl3GKkq6EqGaoCFTs5/aztRGTHgiHMQ4KNuc9DnZmcBZTqpB5FzNX4QW
         pDaGFgsd4Ua0qumNj/qFgzKq/rgSGORT6rUZM=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=de3yDfXxCDp082+e3T+g_1wRWKWjqS0n1vy0+@mail.gmail.com>
References: <AANLkTi=de3yDfXxCDp082+e3T+g_1wRWKWjqS0n1vy0+@mail.gmail.com>
Date: Fri, 25 Mar 2011 22:41:40 +0000
Message-ID: <AANLkTi=W0mW2o2muNgMnb1OQ6WaBeOmu1VBHr8Zf63r9@mail.gmail.com>
Subject: Re: advice sought: practicality of SMP cache coherency implemented in
 assembler (and a hardware detect line)
From: Will Newton <will.newton@gmail.com>
To: Luke Kenneth Casson Leighton <luke.leighton@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 25, 2011 at 9:52 PM, Luke Kenneth Casson Leighton
<luke.leighton@gmail.com> wrote:
> so, bearing in mind that sensible answers will likely result in offers
> of a consulting contract to actually *implement* the software /
> assembly code for the linux kernel modifications required (yes, linux
> is already available for this RISC processor type - but only in
> single-core), i would greatly appreciate some help in getting answers
> to these questions:
>
> * is this even a good idea? does it "fly"?

Probably not. Is it a virtual or physical indexed cache? Do you have a
precise workload in mind? If you have a very precise workload and you
don't expect to get many write conflicts then it could be made to
work.

> * if it does work, at what point do the number of cores involved just
> make it... completely impractical?  over 2?  over 4?  8? 16?

You would have to simulate it with your workload to know the answer to
that, but if you're pushing to higher number of cores I think it would
pay to do this properly.

> occurred back in 2005 or so - this multi-core processor is going to be
> based around an existing proven 20-year-old well-established RISC core
> that has been running linux for over a decade, it just has never been
> put into an SMP arrangement before and we're on rather short
> timescales to get it done.

There are a number of mature cores out there that can do this already
and can be bought off the shelf, I wouldn't underestimate the
difficulty of getting your cache coherency protocol right particularly
on a limited time/resource budget.
