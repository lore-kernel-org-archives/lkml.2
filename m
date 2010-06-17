Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933103Ab0FQQ4z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 12:56:55 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:30722 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933084Ab0FQQ4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 12:56:54 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6016"; a="44738637"
Subject: Re: Overview of concurrency managed workqueue
From: Daniel Walker <dwalker@codeaurora.org>
To: Andy Walls <awalls@md.metrocast.net>
Cc: Tejun Heo <tj@kernel.org>, mingo@elte.hu, linux-kernel@vger.kernel.org,
       jeff@garzik.org, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       johannes@sipsolutions.net, oleg@redhat.com, axboe@kernel.dk
In-Reply-To: <1276776066.2461.15.camel@localhost>
References: <1276551467-21246-1-git-send-email-tj@kernel.org>
	 <4C17C598.7070303@kernel.org>
	 <1276631037.6432.9.camel@c-dwalke-linux.qualcomm.com>
	 <4C18BF40.40607@kernel.org> <1276694825.9309.12.camel@m0nster>
	 <4C18D1FD.9060804@kernel.org> <1276695665.9309.17.camel@m0nster>
	 <4C18D574.1040903@kernel.org>  <1276697146.9309.27.camel@m0nster>
	 <1276776066.2461.15.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Jun 2010 09:56:44 -0700
Message-ID: <1276793804.29614.17.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-06-17 at 08:01 -0400, Andy Walls wrote:
> On Wed, 2010-06-16 at 07:05 -0700, Daniel Walker wrote:
> > On Wed, 2010-06-16 at 15:45 +0200, Tejun Heo wrote:
> > > On 06/16/2010 03:41 PM, Daniel Walker wrote:
> > > > Any workqueue that has a thread which can be prioritized from userspace.
> > > > As long as there is a thread it can usually be given a priority from
> > > > userspace, so any _current_ workqueue which uses a single thread or
> > > > multiple threads is an example of what I'm talking about.
> > > 
> > > Eh... what's the use case for that?  That's just so wrong.  What do
> > > you do after a suspend/resume cycle?  Reprioritize all of them from
> > > suspend/resume hooks?
> > 
> > The use case is any situation when the user wants to give higher
> > priority to some set of work items, and there's nothing wrong with that.
> > In fact there has been a lot of work in the RT kernel related to
> > workqueue prioritization ..
> 
> I'm going to agree with Tejun, that tweaking worker thread priorities
> seems like an odd thing, since they are meant to handle deferable
> actions - things that can be put off until later.

Running RT threads at all can be thought of as odd , but it's an
available feature. In order to effectively run RT threads it's best if
your able to prioritize the system, and that is available with current
workqueues period ..

The problem is Tejun is removing that , ok so maybe this feature of
workqueues is an odd thing to use (just like using RT threads). However,
people are still doing it, it is useful, and it is available in mainline
(and has been for a long time) ..

All I'm asking Tejun to do is have feature parity with current mainline,
and it's not even that hard to do that.

> If one needs to support Real Time deadlines on deferable actions,
> wouldn't using dedicated kernel threads be more deterministic?
> Would the user ever up the priority for a workqueue other than a
> single-threaded workqueue?

It's in a thread and you can prioritize it , so it's only deferable if
the user defines it that way. What your suggesting with dedicated
threads _might_ be something you would do in the long run, but to
satisfy my current of-the-moment needs I would rather re-prioritize the
workqueue instead of investing a significant amount of time re-writing
the driver when it's unknown if that would even help..

Daniel

