Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758Ab1G2TIO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 15:08:14 -0400
Received: from smtp-out.google.com ([74.125.121.67]:49167 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527Ab1G2TIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 15:08:13 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:x-system-of-record;
	b=vt307dvk/GUxZpiBECiKxLiAdczdjYPJ5HBNJkQFRwKfCvCPqO/8xsAvq8DB3QGSU
	tVTk9HPCz8HWInTtCRAKA==
MIME-Version: 1.0
In-Reply-To: <1311962000.21143.69.camel@gandalf.stny.rr.com>
References: <1310785241-3799-1-git-send-email-vnagarnaik@google.com>
 <1311619188-4905-1-git-send-email-vnagarnaik@google.com> <1311949173.21143.43.camel@gandalf.stny.rr.com>
 <CAL26m8Jmy=Rcg6fKghk9Epcj9U6Z2i9UM78hF5_r30U5Qvv9uw@mail.gmail.com> <1311962000.21143.69.camel@gandalf.stny.rr.com>
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
Date: Fri, 29 Jul 2011 12:07:38 -0700
Message-ID: <CAL26m8JXQxWf-Pj1_KuW=ORUoL9yzEdtgXnQfe7dw0cqPUSURw@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] trace-cmd: Add parse error checking target
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 29, 2011 at 10:53 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Fri, 2011-07-29 at 10:41 -0700, Vaibhav Nagarnaik wrote:
>
>> Thanks Steve. I will send the man page patch.
>
> BTW, I played with this and I have a few issues. I'll still accept the
> patch as it's not that big of a deal. But here's some improvements that
> can be made.
>
>
> It should load in the plugins. As the plugins can process failed events
> well. If you don't want the plugins than you can just do what we do with
> report, add a -N to prevent plugins from being loaded.

Thanks for the suggestion, I didn't know about plugins adding parsing
capability. I will add loading the available plugins for this option.

> It should also read a trace.dat file if one is provided on the command
> line. If you don't add a file then it will use the local events of the
> system, if possible.

Our intention with this patch was to reuse the format string parsing
functionality in trace-cmd to look for any errors in new trace events
added by various kernel developers. So this was targeted to test for
event format errors and report them during a new kernel release.

A trace.dat file has already recorded all the data from the machine and
when 'report' is used on it, the format string errors will be reported
regardless. I don't see how using 'check-events' on a trace.dat file
would be useful. Thoughts?


Vaibhav Nagarnaik
