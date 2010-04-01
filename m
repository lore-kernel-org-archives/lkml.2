Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758563Ab0DABXG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 21:23:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:53240 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758474Ab0DABXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 21:23:05 -0400
X-Authority-Analysis: v=1.1 cv=W8jVbnnOFeMnsvu+vJfVVAGaiNyfzTaRLlU2b8ifu+8= c=1 sm=0 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=meVymXHHAAAA:8 a=sWLtxSyDz3GxUzZ78asA:9 a=vVWEVvZEbgN-5ghdzGgA:7 a=QMAUNiPzLjmkOl2P2_mdWs0QeKwA:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: lockup in rb_get_reader_page
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Jiaying Zhang <jiayingz@google.com>
Cc: Steven Rostedt <srostedt@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <p2t5df78e1d1003311814q1f270e41o4ebdc1f48659c034@mail.gmail.com>
References: <m2u5df78e1d1003301627ya1f621f7qaf0ad099f62d787e@mail.gmail.com>
	 <1269995724.22564.58.camel@localhost.localdomain>
	 <q2o5df78e1d1003302101q585143aan32e8872fcdb05c8a@mail.gmail.com>
	 <1270081707.19685.8095.camel@gandalf.stny.rr.com>
	 <p2t5df78e1d1003311814q1f270e41o4ebdc1f48659c034@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Wed, 31 Mar 2010 21:23:02 -0400
Message-ID: <1270084982.19685.8151.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-31 at 18:14 -0700, Jiaying Zhang wrote:
> On Wed, Mar 31, 2010 at 5:28 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > Are you doing reads from interrupt context?
> >
> No. We are using a user-space reader that reads ring buffer via syscall
> or ioctl. But even though we don't read from interrupt context, as I
> understand, we can still have a reader on another cpuB reads cpuA's
> buffer when the writer on cpuA moves the head page. Will we have
> any problem in that case?

Nope, unless that write hangs for some reason ;-)

The read may spin waiting for a writer to finish, hence it just can not
preempt a writer in an interrupt context, because then it may spin
forever, because it is blocking the writer. But if a writer is on
another CPU, then all is well. In fact, the ring buffer was designed
with that in mind.

-- Steve

