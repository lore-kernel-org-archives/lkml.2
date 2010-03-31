Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757801Ab0CaAfq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 20:35:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47395 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756197Ab0CaAfm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 20:35:42 -0400
Subject: Re: lockup in rb_get_reader_page
From: Steven Rostedt <srostedt@redhat.com>
To: Jiaying Zhang <jiayingz@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, Michael Rubin <mrubin@google.com>,
       David Sharp <dhsharp@google.com>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <m2u5df78e1d1003301627ya1f621f7qaf0ad099f62d787e@mail.gmail.com>
References: <m2u5df78e1d1003301627ya1f621f7qaf0ad099f62d787e@mail.gmail.com>
Content-Type: text/plain
Organization: Red Hat
Date: Tue, 30 Mar 2010 20:35:24 -0400
Message-Id: <1269995724.22564.58.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiaying,


On Tue, 2010-03-30 at 16:27 -0700, Jiaying Zhang wrote:
> Hi Steven,
> 
> We recently saw some cpu lockups while running kernel tracing.
> The problem started to happen after we synced up our ring buffer
> code with the upstream lockless ring buffer change. It usually
> took many hours and heavy trace load to hit this problem. When
> the lockup happens, the problematic cpu seemed to be in an infinite
> loop of trying to grab the head_page in rb_get_reader_page().
> 
> We would like to check with you on whether this is a known issue.
> If so, do we have a bug fix? If not, do you have any suggestions on
> where we should check?

I'm unaware of any problems with the ring buffer. I've been running the
lockless version for over a year now, and hammering it with very
intensive tracing.

Now, you see this on the reader side. There has been a few recent fixes
that could cause problems when we have multiple readers. Ftrace usage
does not usually encounter multiple readers so I have not had issues.
But Li Zefan had a stress test that did find and trigger the problems.

Are you using the latest ring buffer that is in Linus's tree? Are you
resetting the ring buffer while reading it?

I guess I need to know more exactly what you are doing to understand the
problem.

Thanks,

-- Steve


