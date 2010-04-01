Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756870Ab0DAA2a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 20:28:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:53580 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755984Ab0DAA22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 20:28:28 -0400
X-Authority-Analysis: v=1.1 cv=W8jVbnnOFeMnsvu+vJfVVAGaiNyfzTaRLlU2b8ifu+8= c=1 sm=0 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=5p_IK7M0cK9HAtes3tMA:9 a=vZAJR5hoXEiUHsGval0A:7 a=jAy3N-JfwaWLmz5-ZvIf5794AREA:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: lockup in rb_get_reader_page
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Jiaying Zhang <jiayingz@google.com>
Cc: Steven Rostedt <srostedt@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <q2o5df78e1d1003302101q585143aan32e8872fcdb05c8a@mail.gmail.com>
References: <m2u5df78e1d1003301627ya1f621f7qaf0ad099f62d787e@mail.gmail.com>
	 <1269995724.22564.58.camel@localhost.localdomain>
	 <q2o5df78e1d1003302101q585143aan32e8872fcdb05c8a@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Wed, 31 Mar 2010 20:28:27 -0400
Message-ID: <1270081707.19685.8095.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-30 at 21:01 -0700, Jiaying Zhang wrote:

> I am going to patch rb_get_reader_page() to print out some debugging
> message when it enters into an infinitely loop. I will keep you updated
> if I find any interesting info.

I was just thinking about this some more. One restriction to the
ring_buffer is that a reader can not preempt a writer, which means that
a read can not happen in an interrupt or NMI. If a read happens there
and preempts a writer as the writer was moving the head page, it will go
into an infinite loop waiting for the writer to finish its move.

You can only do reads from interrupt context if the writer disables
interrupts before reserving and committing the data.

Are you doing reads from interrupt context?

-- Steve


