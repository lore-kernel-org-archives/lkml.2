Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486Ab0IIMbR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 08:31:17 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:34595 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314Ab0IIMbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 08:31:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=q996sqdL4hNOoYQJlTHBJEwirXImPnmtFKq1n1qrTGAkbNsQ4atKXBlVYZfK5MhRt/
         CpN+1b1NEdw9zNke7jcK7xL5Jcvo4aHT4a1TagQ3fImSdBXTlbhGIOLi+R19TOHTsDr1
         ibZFOmI6zQnYewv5NBk7T8R/VOuPIUaHbc4lI=
MIME-Version: 1.0
In-Reply-To: <20100909114053.GA15140@elte.hu>
References: <AANLkTi=yeHyOeewm9tdsHRtj+=d+vE5=NRKGaPyq_yGH@mail.gmail.com>
	<1284031141.402.1.camel@laptop>
	<20100909112940.GA5267@nowhere>
	<20100909114053.GA15140@elte.hu>
Date: Thu, 9 Sep 2010 14:31:14 +0200
Message-ID: <AANLkTikuqHFdOoiB4ejRygi3EV3p4HN2jgjJwM6Sw+31@mail.gmail.com>
Subject: Re: perf events over (net) console?
From: Harald Gustafsson <hgu1972@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Harald Gustafsson <harald.gustafsson@ericsson.com>,
        Song Yuan <song.yuan@ericsson.com>,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/9/9 Ingo Molnar <mingo@elte.hu>:
>
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
>
>> On Thu, Sep 09, 2010 at 01:19:01PM +0200, Peter Zijlstra wrote:
>> > On Thu, 2010-09-09 at 13:06 +0200, Harald Gustafsson wrote:
>> > > Hi,
>> > >
>> > > We would like to monitor the perf events continuously on a remote
>> > > machine. Does it exist a solution (in the kernel) to direct the
>> > > output to a console or maybe even a netconsole? We would like to
>> > > avoid a user space application to transfer it, due to that the
>> > > machine will be running a test which will heavily load it and we
>> > > want to avoid as many unrelated user space tasks as possible. If
>> > > not mainlined does anyone have a patch for this?
>> >
>> > No, and its a daft requirement.

Sorry for being daft...

>> >
>> > You need a process context anyway to read the data and send it to
>> > whatever place you want it.
>> >
>> > Putting that in-kernel serves no purpose what so ever.
>>
>> But if we bring the splice support, that can be done with minimal
>> userspace noise. Plus that would work with the usual sockets but not
>> limited to that.
>
> Yes. If we can transform the data over the network without it touching
> disk, then that would be a sufficiently 'does not disturb other tasks'
> measurement method.

Thanks for the pointers to more information, and yes my thoughts was
more about avoiding the data copy then avoiding any processing context
at all.

Regards,
