Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754959Ab0GJNGg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 09:06:36 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58037 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753988Ab0GJNGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 09:06:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=IcGsdxZ8aYS2TGpMeQ2QQyW3FMoBPUEmgUqncJBubpb/uH58tgqt9xTB62OYEvTsYQ
         9NNxSgeNfiVuJ2B8j6ifQVp0kIVtXCKF5NL8sPzQ124DRt6xeUNeIEARv4r4wkUAAaS3
         rFq39jZMrGF+/FMSkle715jzn5J/FVr3ALjak=
MIME-Version: 1.0
In-Reply-To: <1278761646.1537.182.camel@gandalf.stny.rr.com>
References: <1278705402.1537.157.camel@gandalf.stny.rr.com> 
	<20100709203301.GA13839@merkur.ravnborg.org> <AANLkTinWkfkXNVA2Sx-apVQMZa-5ehugtd7JQ36np7xM@mail.gmail.com> 
	<1278721339.1537.166.camel@gandalf.stny.rr.com> <20100710063459.GA14596@merkur.ravnborg.org> 
	<AANLkTim7jTSaDaQTudR3e-DMBDrg9n00Hor8QdDQoVo_@mail.gmail.com> 
	<1278761646.1537.182.camel@gandalf.stny.rr.com>
From: Zeev Tarantov <zeev.tarantov@gmail.com>
Date: Sat, 10 Jul 2010 16:06:05 +0300
Message-ID: <AANLkTil4eO0TW34ggl16lA9BTx5gObKQl4P3etzZI0MK@mail.gmail.com>
Subject: Re: [PATCH] tracing: properly align linker defined symbols
To: rostedt@goodmis.org
Cc: Sam Ravnborg <sam@ravnborg.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 10, 2010 at 14:34, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Sat, 2010-07-10 at 13:18 +0300, Zeev Tarantov wrote:
>> On Sat, Jul 10, 2010 at 09:35, Sam Ravnborg <sam@ravnborg.org> wrote:
>
>> > +/*
>> > + * Align to a 32 byte boundary equal to the
>> > + * alignment gcc 4.5 uses for a struct
>> > + */
>> > +#define STRUCT_ALIGN() . = ALIGN(32)
>> > +
>
> What I'm nervous about is when gcc 4.8 decides to up the alignment to
> 64.
>
> Maybe we should have both patches, just to be safe.
>
> -- Steve
>

I don't want to post obvious or inane suggests to the mailing list,
but if you're worried about gcc changing the default alignment, the
solution seems to be one of:
1. Not relying on the default alignment and specifying explicitly what you want.
2. Querying the default alignment before compilation, either using an
API gcc may provide or (cumbersomely) by testing.

-Zeev
