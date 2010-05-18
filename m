Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757413Ab0EROln (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 10:41:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:62167 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754344Ab0EROll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 10:41:41 -0400
X-Authority-Analysis: v=1.1 cv=MoOeBCR3UCSroT7bBzr0mtJUqJhHyBWzyNa37ex1qNU= c=1 sm=0 a=pjGjkNHRNmAA:10 a=0qYQvVkOOIcA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=pCTbaqMk0ZeEHFYGejQA:9 a=rguzO34FQ8Kn7tWAZYQ69Ami8jQA:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: collecting static data related to tracing
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1274191742.31554.10.camel@jlt3.sipsolutions.net>
References: <1274191742.31554.10.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Tue, 18 May 2010 10:41:38 -0400
Message-ID: <1274193698.26328.746.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-18 at 16:09 +0200, Johannes Berg wrote:

> I'm thinking that we could have per subsystem "detail" files that are
> provided by the respective subsystem implementation in some way, and can
> then simply be included in the recorded trace file. However, I have no
> idea if that is feasible to implement, or if maybe there's another way.
> FWIW, all my events already contain a pointer, used as a cookie, to
> identify the hardware instance, but that only allows me to read a trace
> that contains data about multiple devices, it doesn't give me
> information about each device. Ideally, the "detail" file would list all
> the information along with the cookie, so I could connect the dots.
> 
> Thoughts?

The latest version of trace-cmd has an "options" section. This allows
you to add options to the file.

We could make a plugin that also can be used by trace-cmd record, that
allows you to add options. The options are written such that if a
trace-cmd does not know how to deal with them, they will be ignored.

Hmm, but the options require a unique ID. Well we could register IDs
with plugins, or add a plugin id, which uses the name of the plugin as
an identifier too.

But this would allow you to add the details you want about the system
and then have the reader be able to print it out.

How's that sound?

-- Steve


