Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759995Ab2EVReI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 13:34:08 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57860 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759968Ab2EVReG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 13:34:06 -0400
Message-ID: <1337708035.9698.44.camel@twins>
Subject: Re: [PATCH v2 4/5] perf record: add meta-data support for pipe-mode
From: Peter Zijlstra <peterz@infradead.org>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu
Date: Tue, 22 May 2012 19:33:55 +0200
In-Reply-To: <20120518171911.GH2636@infradead.org>
References: <1337081295-10303-1-git-send-email-eranian@google.com>
	 <1337081295-10303-5-git-send-email-eranian@google.com>
	 <4FB32032.3000509@gmail.com>
	 <CABPqkBQyZfSczhAROdH8p0_asy=c2AJho4Kv9wRYabaLNKkURA@mail.gmail.com>
	 <4FB67DE5.8050000@gmail.com> <20120518171911.GH2636@infradead.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-18 at 14:19 -0300, Arnaldo Carvalho de Melo wrote:

> PeterZ was the one objecting to adding more userspace only events,

Ah, yes I was ;-)

So uhm the argument was something like perf_event_type is a kernel enum
and userspace stealing space there is going to get us into trouble
eventually since userspace doesn't register its types in our enum.

Furthermore most (if not all) the userspace thingies were setup (like in
this case single session meta-data) things. So they don't belong in the
event stream at all.

>From what I can remember all this is somehow related to how data is
passed to scripts or so and since there's only a single stdin everything
is stuffed over it.

For the data file we should simply create another section in the header;
and I think that is how it works these days.

For the script muck, I've really no idea how all that works, but why
can't you wrap the stuff in another layer; have a header up front that
says the next N bytes are meta-data and after that there's the regular
data stream.

Or take some inspiration from one of the many multi-stream stream
formats out there like mpeg or ogg or whatever.
