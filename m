Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957Ab1HWTYP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 15:24:15 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:43709 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752684Ab1HWTYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 15:24:07 -0400
X-Authority-Analysis: v=1.1 cv=YhhhcVvq/Bf3xBNEvzTEV9JHGW2mXul7kEbaqsyQnMQ= c=1 sm=0 a=1tBU7os0dNMA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=1XWaLZrsAAAA:8 a=vHnFh6V3jqHI_VibtnMA:9 a=3_2kgjtiv-1b5V89Ff4A:7 a=PUjeQqilurYA:10 a=UTB_XpHje0EA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH v3 4/5] trace: Make removal of ring buffer pages atomic
From: Steven Rostedt <rostedt@goodmis.org>
To: David Sharp <dhsharp@google.com>
Cc: Vaibhav Nagarnaik <vnagarnaik@google.com>, Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Michael Rubin <mrubin@google.com>, linux-kernel@vger.kernel.org
In-Reply-To: <CAJL_ektp-BP52Qqfu_bBDjUnXyX20PWzgNuQF_atB0J9q7n=Zw@mail.gmail.com>
References: <1313531179-9323-5-git-send-email-vnagarnaik@google.com>
	 <1314125758-5069-1-git-send-email-vnagarnaik@google.com>
	 <CAJL_ektp-BP52Qqfu_bBDjUnXyX20PWzgNuQF_atB0J9q7n=Zw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 23 Aug 2011 15:24:04 -0400
Message-ID: <1314127444.15704.161.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-08-23 at 12:16 -0700, David Sharp wrote:
> On Tue, Aug 23, 2011 at 11:55 AM, Vaibhav Nagarnaik
> <vnagarnaik@google.com> wrote:
> > This patch adds the capability to remove pages from a ring buffer
> > without destroying any existing data in it.
> >
> > This is done by removing the pages after the tail page. This makes sure
> > that first all the empty pages in the ring buffer are removed. If the
> > head page is one in the list of pages to be removed, then the page after
> > the removed ones is made the head page. This removes the oldest data
> > from the ring buffer and keeps the latest data around to be read.
> >
> > To do this in a non-racey manner, tracing is stopped for a very short
> > time while the pages to be removed are identified and unlinked from the
> > ring buffer. The pages are freed after the tracing is restarted to
> > minimize the time needed to stop tracing.
> >
> > The context in which the pages from the per-cpu ring buffer are removed
> > runs on the respective CPU. This minimizes the events not traced to only
> > NMI trace contexts.
> 
> "interrupt contexts". We're not disabling interrupts.

Hi David,

Just a note on LKML etiquette, when you make a single comment in an
email, please delete the rest of the email, or at the very least, sign
it with your name, so those reading your reply wont go looking through
the email for what else you wrote.

-- Steve


