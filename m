Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758881Ab0EMM3Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 08:29:24 -0400
Received: from mail-ew0-f216.google.com ([209.85.219.216]:56317 "EHLO
	mail-ew0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866Ab0EMM3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 08:29:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:in-reply-to:references
         :x-mailer:mime-version:content-type:content-transfer-encoding;
        b=eXv42z+hsny3nGTvpGkKWIx5/QI9GDQdJYRHbhNy3yyh0K6cd7bH9N2GZ9B07j3I+a
         x7dJyJn7mKSzsGpKTqf0Jd9XoUvwlkrews8uPyPpcCOphi+EtwpefFp4fZ/rchv9YONe
         1Ir9cGs6TwqOBPIp0DUqqUubtmxQZmZAQy4Nk=
Date: Thu, 13 May 2010 15:29:15 +0300
From: Pekka Paalanen <pq@iki.fi>
To: rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH 3/4] tracing: Allow mmio tracer to display
 trace_printk() and other events
Message-ID: <20100513152915.3d3f852b@daedalus.pq.iki.fi>
In-Reply-To: <1273752909.27703.809.camel@gandalf.stny.rr.com>
References: <20100513012110.558313399@goodmis.org>
	<20100513012302.352845720@goodmis.org>
	<20100513115414.7688b51d@daedalus.pq.iki.fi>
	<1273752909.27703.809.camel@gandalf.stny.rr.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.7; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 May 2010 08:15:09 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Thu, 2010-05-13 at 11:54 +0300, Pekka Paalanen wrote:
> > On Wed, 12 May 2010 21:21:13 -0400
> > Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> > > From: Steven Rostedt <srostedt@redhat.com>
> > > 
> > > The mmio tracer has its own function to handle reading of
> > > events. But if it encounters an event that it does not
> > > understand it ignores it instead of telling the calling
> > > function that it is not processing it.
> > > 
> > > If someone adds trace_printk() or enables events along with
> > > the mmio tracer, then these events will not be displayed in
> > > the trace output.
> > > 
> > > Simple solution is to just have the mmio print return
> > > UNHANDLED to let the caller know that it did not processes
> > > the event and the caller can process the event further.
> > 
> > Does this not mean that the mmiotrace output may contain
> > foreign lines? If it does, it will break the user space.
> > The dump format is specified in
> > Documentation/trace/mmiotrace.txt.
> > 
> > If you want to handle arbitrary messages, format them as
> > MARK events, please.
> > 
> > If I understood correctly, then NAK for this patch. Otherwise,
> > could you explain how this does not break the mmiotrace dump
> > format?
> > 
> > Is the tracing infrastructure now supporting several
> > active tracers at the same time? If yes, and if mmiotrace
> > should be able to co-operate, we need a new revision of the
> > dump format, or a tool that extracts the mmiotrace
> > events in the current format.
> > 
> 
> It only displays other events if the user enabled those events.
> 
> But that said, I don't want to break existing userspace tools. I
> can add a mmiotrace option "mmiotrace_all_events", if the user
> wants to see all events within the mmiotracer then they can just
> enable that option, otherwise, the mmiotracer will act like it
> currently does.
> 
> How does that sound?

That would be fine. Is it not redundant with what you said in
your first sentence?

-- 
Pekka Paalanen
http://www.iki.fi/pq/
