Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206Ab1F3WpX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 18:45:23 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:35621 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664Ab1F3WpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 18:45:22 -0400
X-Authority-Analysis: v=1.1 cv=5asQ6euaRPJxDdFxwvXsn6JDb7fmFbz8qWDLMfa45gU= c=1 sm=0 a=yGV206oZUtoA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=2-oHqw-K7N3AG4ByOEwA:9 a=_s83GMOiBuOzrNJQ02cA:7 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] plist: add mutex to the blessed lock type for plists
From: Steven Rostedt <rostedt@goodmis.org>
To: Dima Zavin <dima@android.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <CAPz4a6AHuBLfXPx4aXew0BCa3bQ-_kAnrpw_3f2r-5A9OhTTsg@mail.gmail.com>
References: <1309376033-32005-1-git-send-email-dima@android.com>
	 <m2tyb81jml.fsf@firstfloor.org>
	 <CAPz4a6CbzEm3QJZ-5wsaiSH1H9g7tgo7E7-HyRB8Fv5=NfGDRQ@mail.gmail.com>
	 <1309380221.26417.50.camel@gandalf.stny.rr.com>
	 <CAPz4a6AHuBLfXPx4aXew0BCa3bQ-_kAnrpw_3f2r-5A9OhTTsg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 30 Jun 2011 18:45:18 -0400
Message-ID: <1309473918.26417.115.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-30 at 15:14 -0700, Dima Zavin wrote:
> Steve,
> 
> So what would do you recommend I do? Is this patch acceptable or do
> you want me to remove all the debug stuff and modify all the users to
> not provide a lock?
> 

I'm fine either way. I would like to know what Thomas, Ingo and Peter
think.

-- Steve

> On Wed, Jun 29, 2011 at 1:43 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> > On Wed, 2011-06-29 at 13:34 -0700, Dima Zavin wrote:
> >
> >> The whole enforcement of locking inside this code is awkward anyway.
> >> We don't enforce locking on rb_trees, or on list_head, etc. Why
> >> plists? The funny part is that the test code in plist.c itself has a
> >> hack to skip the lock check.
> >
> > It's a legacy from the -rt tree. With the development there, there was
> > always a case where a plist was added without the proper locking, and we
> > spent days debugging it. This test proved very useful. As plists came to
> > mainline, we kept the tests.
> >
> > Now, getting rid of them maybe the thing to do. I'm not sure how useful
> > they are today.
> >
> > -- Steve
> >
> >
> >


