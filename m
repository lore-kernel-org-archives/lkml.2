Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503Ab1HLCUY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 22:20:24 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:43846 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433Ab1HLCUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 22:20:22 -0400
MIME-Version: 1.0
In-Reply-To: <20110811142049.GE8552@redhat.com>
References: <20110809034724.GA22257@july>
	<4E4181E4.3090704@kernel.dk>
	<CAH9JG2X5yb9JEyO60YeLFHcuNp54m-xX8M-xSR7+DEY7FKQL1Q@mail.gmail.com>
	<4E423C83.9090209@kernel.dk>
	<CAH9JG2VhPg-mk36CO_Jh8D0O6SW3RnZyjnBRNH4UqT8SXXWULQ@mail.gmail.com>
	<CANejiEVW69ihzpMYqvTZ5iW+uz3jUA2y60vL7xzyZidhSxj-0g@mail.gmail.com>
	<4E424A0A.6090300@kernel.dk>
	<CANejiEU+gG9wWb+=zqASj1M-CmcDhXi2kft=FpFJ8K6Tb+whrw@mail.gmail.com>
	<CAH9JG2XTOOS5GGO7howP+SLbTkj0xUJHPisFYPZfkJddWeKQ4Q@mail.gmail.com>
	<20110811142049.GE8552@redhat.com>
Date: Fri, 12 Aug 2011 11:20:21 +0900
X-Google-Sender-Auth: FZZ-avMbTjIX-FaQmPAjPGTyfbo
Message-ID: <CAH9JG2Xn92sbgbPx+E6LnS=7g7Yiq=f8KcjFLAcZ-_9UpVhGgA@mail.gmail.com>
Subject: Re: [RFC PATCH] request: teach the device more intelligent
From: Kyungmin Park <kmpark@infradead.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org, arnd@arndb.de, jh80.chung@samsung.com,
        linux-mmc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 11, 2011 at 11:20 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Thu, Aug 11, 2011 at 09:36:04AM +0900, Kyungmin Park wrote:
>
> [...]
>> No, no need to consistent. the context id id only valid when several
>> requests are request the I/O simultaneously
>> e.g.,
>> App1 requests A, B, C, D, ...
>> App2 requests a, b, c, d, ...
>> App2 requests 1, 2, 3, 4, 5, ...
>> with following order, A, B, a, 1, C, b, 2, ...
>>
>> The current eMMC can't handle these operation.
>>
>> Instead using context, it can teach the these operation comes from
>> using context ID. and finally can place the request in-order at card
>> internally.
>>
>> Open Context ID operation, perform I/O with context Id, ...., and
>> Close Context ID operation until queue is empty.
>
> Hi Kyungmin,
>
> So once we have context information, we want to process all the requests
> from the same context together? IOW, we expect that driver will have
> multiple requests in flight from various context and it will batch the
> requests from same context together?
It's current implementation. Actually there's no context until eMMC v4.41.
After eMMC v4.5. introduce the context and handle it efficiently if
context is provided from host
>
> How does that help? Is it something related to seeking? If yes, then just
> setting the rotational=1 should help as CFQ will sequence all the
> sequential IO where it can. For random IO, anyway optimization will not
> help. May be it is about something else which I am completely missing.
> Some details here will help.
No, it's dependent on firmware implementation at each vendor. but some
mixed workload, several programs requests the sequential write, and
one or two random write, it can assign the blocks one for sequential,
another for ramdon. don't mix it if context is provided.

Thank you,
Kyungmin Park
>
> Thanks
> Vivek
>
