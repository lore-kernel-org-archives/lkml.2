Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756753Ab0KJPxs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 10:53:48 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:52492 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756231Ab0KJPxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 10:53:47 -0500
X-Authority-Analysis: v=1.1 cv=6ptpMFIBtxRk0xdOb6IhJTbTLVRlKjWFes7R4SsWCrA= c=1 sm=0 a=2Zzf6Ss2cq4A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=GwmEstuPqUwjGjsdEDwA:9 a=_vMTJuKud1PwGh-L5wQA:7 a=7SD9hlayFWtsfzhUD3iDaYiWTsoA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC/Requirements/Design] h/w error reporting
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, "Luck, Tony" <tony.luck@intel.com>,
        linux-kernel@vger.kernel.org, ying.huang@intel.com, bp@alien8.de,
        tglx@linutronix.de, akpm@linux-foundation.org, mchehab@redhat.com,
        =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Arjan van de Ven <arjan@infradead.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
In-Reply-To: <1289403019.2084.17.camel@laptop>
References: <4cd9edd7543527b78@agluck-desktop.sc.intel.com>
	 <20101110101450.GA18481@elte.hu>
	 <1289400056.12418.139.camel@gandalf.stny.rr.com>
	 <1289400234.2191.129.camel@laptop>
	 <1289401781.12418.145.camel@gandalf.stny.rr.com>
	 <1289403019.2084.17.camel@laptop>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 10 Nov 2010 10:53:45 -0500
Message-ID: <1289404425.12418.160.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-10 at 16:30 +0100, Peter Zijlstra wrote:


> I also don't want to support the stupid concurrent read/write from tail.

You are talking about what you said that ftrace ring buffer is totally
broken, that if the writer is writing to the tail, and the reader is
reading from the head, it is broken?

Let me get this straight.

We have a writer constantly writing to the tail of the buffer. On
another CPU we have a reader, that will start at that tail (where the
writer just wrote) and go backwards.

What happens if the writer continues writing? Do we stop the reader and
have it write what it just wrote? Or just consider that the reader goes
the opposite direction of the writer, and when it hits the writer, it
continues, since now it has the new data again.

Now the question comes, how do we show this data to the user? Does the
user need to sort the data? If the reader reads X amount of data, it
gets X from where the writer just wrote. Then the writer writes Y data.
The reader reads X amount again, but X > Y, do we read the Y where the
writer wrote, and then read the buffer part that is older than the
previous read? Thus the user now has the burden to sort the buffer?

I'm really confused to how to use a buffer like this?

-- Steve


