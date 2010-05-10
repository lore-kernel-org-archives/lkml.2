Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954Ab0EJQkN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 12:40:13 -0400
Received: from mail-yx0-f171.google.com ([209.85.210.171]:61109 "EHLO
	mail-yx0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446Ab0EJQkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 12:40:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=ZdKISxjpR4PW96zy9rNn+Ah1197d9wpKOmlvx2Uh0h3llLcaNwVxznLtNxinaoLZ50
         6EY4O1ALiUYM2CJCc9WC8sr881jcbwa0AUGM+F0UW1HTvvNfRaq2riKKKj0LoEXvgy0H
         58iDS1Z7wWSz3nOUbt6K5skFvRVaSRcbC6RQM=
MIME-Version: 1.0
In-Reply-To: <1273488154-2993-1-git-send-email-os@emlix.com>
References: <1273487642-2169-1-git-send-email-os@emlix.com> 
	<1273488154-2993-1-git-send-email-os@emlix.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Mon, 10 May 2010 12:39:49 -0400
Message-ID: <AANLkTiniq9gT5-x8tP3SRXvMvTAZ3VJF7pe21OLl1qDH@mail.gmail.com>
Subject: Re: [PATCH v3] ad7877: keep dma rx buffers in seperate cache lines
To: Oskar Schirmer <os@emlix.com>
Cc: Michael Hennerich <Michael.Hennerich@analog.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       =?UTF-8?Q?Daniel_Gl=C3=B6ckner?= <dg@emlix.com>,
       Oliver Schneidewind <osw@emlix.com>, Johannes Weiner <jw@emlix.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 10, 2010 at 06:42, Oskar Schirmer wrote:
> With dma based spi transmission, data corruption
> is observed occasionally. With dma buffers located
> right next to msg and xfer fields, cache lines
> correctly flushed in preparation for dma usage
> may be polluted again when writing to fields
> in the same cache line.
>
> Make sure cache fields used with dma do not
> share cache lines with fields changed during
> dma handling. As both fields are part of a
> struct that is allocated via kzalloc, thus
> cache aligned, moving the fields to the 1st
> position and insert padding for alignment
> does the job.

Acked-by: Mike Frysinger <vapier@gentoo.org>

i'm guessing Dmitry will pick it up now
-mike
