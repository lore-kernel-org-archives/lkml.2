Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614Ab0D0VGO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 17:06:14 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:58332 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614Ab0D0VGN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 17:06:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ueKvEeX4XwO2Z9oN+VP+XFdQBVUR1zM9ZBuxg39Q95LUNv934tcJaKuACmiZ9n7emi
         ooEOoouD80BWUbeRlhv5vdbUOpRYWru3j38aeCWbLisldxdNlb17BG5nxoZ5ej7WVhBk
         CSnJKACE/VVfKdPy+9cWjPnm/jRIRzTBvkYlI=
MIME-Version: 1.0
In-Reply-To: <1272401402.9739.77.camel@gandalf.stny.rr.com>
References: <1272304925-2436-1-git-send-email-chase.douglas@canonical.com>
	 <1272401402.9739.77.camel@gandalf.stny.rr.com>
Date: Tue, 27 Apr 2010 17:06:12 -0400
X-Google-Sender-Auth: 1a1bed4d0b5d630a
Message-ID: <y2k40ec3ea41004271406x3727625cwa3c5d628e0e9ad3b@mail.gmail.com>
Subject: Re: [PATCH] ftrace: print sample std dev when function profiling
From: Chase Douglas <chase.douglas@canonical.com>
To: rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 27, 2010 at 4:50 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Mon, 2010-04-26 at 14:02 -0400, Chase Douglas wrote:
>
>> +     /* Sample standard deviation (s^2) */
>> +     if (rec->counter <= 1)
>> +             stddev = 0;
>> +     else {
>> +             stddev = rec->time_squared - rec->counter * avg * avg;
>> +             do_div(stddev, (rec->counter - 1) * 1000); /* ns^2 -> us^2 */
>
> Shouldn't this be:
>
>        do_div(stddev, (rec->counter - 1) * 1000000); ?
>
> (x / 1000)^2 == x^2 / 1000^2

The trace_print_graph_duration function divides the value by 1000
again to display in us units. I could make the comment more clear, but
I didn't want to make a big fuss over a unit conversion.

I also figured this out *after* I had some really wrong looking
numbers :). I made sure this patch produced the correct value after
two events, so I assume the math is correct.

-- Chase
