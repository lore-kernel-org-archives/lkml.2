Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760825Ab0FQW3E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 18:29:04 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:20696 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760235Ab0FQW3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 18:29:00 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6016"; a="44771670"
Subject: Re: Overview of concurrency managed workqueue
From: Daniel Walker <dwalker@codeaurora.org>
To: Tejun Heo <tj@kernel.org>
Cc: mingo@elte.hu, awalls@radix.net, linux-kernel@vger.kernel.org,
       jeff@garzik.org, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       johannes@sipsolutions.net, oleg@redhat.com, axboe@kernel.dk
In-Reply-To: <4C18D574.1040903@kernel.org>
References: <1276551467-21246-1-git-send-email-tj@kernel.org>
	 <4C17C598.7070303@kernel.org>
	 <1276631037.6432.9.camel@c-dwalke-linux.qualcomm.com>
	 <4C18BF40.40607@kernel.org> <1276694825.9309.12.camel@m0nster>
	 <4C18D1FD.9060804@kernel.org> <1276695665.9309.17.camel@m0nster>
	 <4C18D574.1040903@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Jun 2010 15:28:53 -0700
Message-ID: <1276813733.29614.120.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-16 at 15:45 +0200, Tejun Heo wrote:
> On 06/16/2010 03:41 PM, Daniel Walker wrote:
> > Any workqueue that has a thread which can be prioritized from userspace.
> > As long as there is a thread it can usually be given a priority from
> > userspace, so any _current_ workqueue which uses a single thread or
> > multiple threads is an example of what I'm talking about.
> 
> Eh... what's the use case for that?  That's just so wrong.  What do
> you do after a suspend/resume cycle?  Reprioritize all of them from
> suspend/resume hooks?


I tested your assertion about suspend/resume, and it doesn't seem to be
true.. I tested workqueues with nice levels, and real time priorities on
a random laptop using 2.6.31 both held their priorities across suspend
to RAM and suspend to disk .. Was this change added after 2.6.31 ?

Daniel

