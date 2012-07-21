Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752299Ab2GURQP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2012 13:16:15 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:39055 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104Ab2GURQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2012 13:16:13 -0400
MIME-Version: 1.0
In-Reply-To: <87txx1qsgz.fsf@kernel.org>
References: <87txx1qsgz.fsf@kernel.org>
Date: Sat, 21 Jul 2012 19:16:11 +0200
Message-ID: <CABPqkBTkFBq+A0u1u98_RXORuLDVzJO1exMmHGWZ=hWvsg_MDw@mail.gmail.com>
Subject: Re: [Question] perf header: Why the HEADER_EVENT_DESC is needed?
From: Stephane Eranian <eranian@google.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 21, 2012 at 1:11 PM, Namhyung Kim <namhyung@kernel.org> wrote:
> Hi Stephane,
>
> I wonder why we need to save the event descriptions in the feature area
> of file header. Since the perf_event_attr, its ids and the event name
> are already saved in the header, it seems a duplicate work to do that.
> For printing the information, we might reuse those info or evlist
> directly IMHO.
>
> Am I missing something?

Unfortunately, I think you are.

There event names are not saved in header.c except indirectly by write_cmdline.
But more importantly, event_desc makes it possible to connect an event name as
passed on the cmdline with the corresponding attr struct.

Furthermore, it is also present in pipe mode, with the patch I posted
months ago.

Finally, you cannot arbitrarily remove features like this. We do have
tools that do
rely on the presence of EVENT_DESC.
