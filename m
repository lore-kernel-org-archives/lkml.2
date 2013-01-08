Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180Ab3AHGuw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 01:50:52 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:39976 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054Ab3AHGuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 01:50:51 -0500
X-AuditID: cbfec7f5-b7fd76d000007247-d5-50ebc1c9b2a9
Message-id: <50EBC1C1.3060208@samsung.com>
Date: Tue, 08 Jan 2013 07:50:41 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Alessandro Rubini <rubini@gnudd.com>,
        federico.vaga@gmail.com, mchehab@infradead.org, pawel@osciak.com,
        hans.verkuil@cisco.com, giancarlo.asnaghi@st.com,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        s.nawrocki@samsung.com
Subject: Re: [PATCH v3 2/4] videobuf2-dma-streaming: new videobuf2 memory
 allocator
References: <3892735.vLSnhhCRFi@harkonnen>
 <1348484332-8106-1-git-send-email-federico.vaga@gmail.com>
 <1399400.izKZgEHXnP@harkonnen> <12929800.xFTBAueAE0@harkonnen>
 <20130106230947.GA17979@mail.gnudd.com> <20130107124050.3fc5031b@lwn.net>
 <20130107181500.24c56803@redhat.com>
In-reply-to: <20130107181500.24c56803@redhat.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprILMWRmVeSWpSXmKPExsVy+t/xK7onD74OMLg9lcXi8q45bBY9G7ay
	OjB5fN4kF8AYxWWTkpqTWZZapG+XwJWxtPskW8FBjoqv/WeYGhivs3UxcnJICJhIXPx6mQnC
	FpO4cG89UJyLQ0hgKaPE3slNLCAJIYFmJolvLQkgNq+AlsS85xPB4iwCqhLHFzwBG8QmYCjR
	9bYLzBYV8JWY9usaE0S9oMSPyfeA6jk4RAT0JLqaBEDmMwtMZ5I4s+MWO0iNsECoxJv/r5gg
	Fs9mkvjZ9pgVJMEJNPRQ/wJGEJtZwEziUcs6ZghbXmLzmrfMExgFZiHZMQtJ2SwkZQsYmVcx
	iqaWJhcUJ6XnGukVJ+YWl+al6yXn525ihATj1x2MS49ZHWIU4GBU4uG9GPM6QIg1say4MvcQ
	owQHs5IIr/0+oBBvSmJlVWpRfnxRaU5q8SFGJg5OqQZG1hml91l2NBW93l37dW2vV0t91kev
	v4sf6y25onTQ9az4vt8eK7fYP5A58ic8/1rQD6/0CsYkjsy3L/P0C/pYRX3+7738wzWli/eR
	yPX7tgpFvd+kL0+zz93COHFvTeGaL78YTeY2K4dwmyfznombmD9bXTJF70n64TVnlnGJfnRt
	y3BYFfxOiaU4I9FQi7moOBEA5VonSyQCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 1/7/2013 9:15 PM, Mauro Carvalho Chehab wrote:
> Em Mon, 7 Jan 2013 12:40:50 -0700
> Jonathan Corbet <corbet@lwn.net> escreveu:
>
> > On Mon, 7 Jan 2013 00:09:47 +0100
> > Alessandro Rubini <rubini@gnudd.com> wrote:
> >
> > > I don't expect you'll see serious performance differences on the PC. I
> > > think ARM users will have better benefits, due to the different cache
> > > architecture.  You told me Jon measured meaningful figures on a Marvel
> > > CPU.
> >
> > It made the difference between 10 frames per second with the CPU running
> > flat out and 30fps mostly idle.  I think that probably counts as
> > meaningful, yeah...:)
>
> Couldn't this performance difference be due to the usage of GFP_DMA inside
> the VB2 code, like Federico's new patch series is proposing?
>
> If not, why are there a so large performance penalty?

Nope, this was caused rather by a very poor CPU access to non-cached (aka
'coherent') memory and the way the video data has been accessed/read 
with CPU.

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


