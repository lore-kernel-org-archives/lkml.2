Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751643Ab1HKOVH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 10:21:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20736 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751121Ab1HKOVE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 10:21:04 -0400
Date: Thu, 11 Aug 2011 10:20:49 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Kyungmin Park <kmpark@infradead.org>
Cc: Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org, arnd@arndb.de, jh80.chung@samsung.com,
        linux-mmc@vger.kernel.org
Subject: Re: [RFC PATCH] request: teach the device more intelligent
Message-ID: <20110811142049.GE8552@redhat.com>
References: <20110809034724.GA22257@july>
 <4E4181E4.3090704@kernel.dk>
 <CAH9JG2X5yb9JEyO60YeLFHcuNp54m-xX8M-xSR7+DEY7FKQL1Q@mail.gmail.com>
 <4E423C83.9090209@kernel.dk>
 <CAH9JG2VhPg-mk36CO_Jh8D0O6SW3RnZyjnBRNH4UqT8SXXWULQ@mail.gmail.com>
 <CANejiEVW69ihzpMYqvTZ5iW+uz3jUA2y60vL7xzyZidhSxj-0g@mail.gmail.com>
 <4E424A0A.6090300@kernel.dk>
 <CANejiEU+gG9wWb+=zqASj1M-CmcDhXi2kft=FpFJ8K6Tb+whrw@mail.gmail.com>
 <CAH9JG2XTOOS5GGO7howP+SLbTkj0xUJHPisFYPZfkJddWeKQ4Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH9JG2XTOOS5GGO7howP+SLbTkj0xUJHPisFYPZfkJddWeKQ4Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 11, 2011 at 09:36:04AM +0900, Kyungmin Park wrote:

[...]
> No, no need to consistent. the context id id only valid when several
> requests are request the I/O simultaneously
> e.g.,
> App1 requests A, B, C, D, ...
> App2 requests a, b, c, d, ...
> App2 requests 1, 2, 3, 4, 5, ...
> with following order, A, B, a, 1, C, b, 2, ...
> 
> The current eMMC can't handle these operation.
> 
> Instead using context, it can teach the these operation comes from
> using context ID. and finally can place the request in-order at card
> internally.
> 
> Open Context ID operation, perform I/O with context Id, ...., and
> Close Context ID operation until queue is empty.

Hi Kyungmin,

So once we have context information, we want to process all the requests
from the same context together? IOW, we expect that driver will have
multiple requests in flight from various context and it will batch the
requests from same context together?

How does that help? Is it something related to seeking? If yes, then just
setting the rotational=1 should help as CFQ will sequence all the
sequential IO where it can. For random IO, anyway optimization will not
help. May be it is about something else which I am completely missing.
Some details here will help.

Thanks
Vivek
