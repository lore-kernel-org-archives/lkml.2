Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755169Ab0FSIiI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 04:38:08 -0400
Received: from one.firstfloor.org ([213.235.205.2]:50556 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754872Ab0FSIiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 04:38:04 -0400
From: Andi Kleen <andi@firstfloor.org>
To: Andy Walls <awalls@md.metrocast.net>
Cc: Daniel Walker <dwalker@codeaurora.org>, Tejun Heo <tj@kernel.org>,
       mingo@elte.hu, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       johannes@sipsolutions.net, oleg@redhat.com, axboe@kernel.dk
Subject: Re: Overview of concurrency managed workqueue
References: <1276551467-21246-1-git-send-email-tj@kernel.org>
	<4C17C598.7070303@kernel.org>
	<1276631037.6432.9.camel@c-dwalke-linux.qualcomm.com>
	<4C18BF40.40607@kernel.org> <1276694825.9309.12.camel@m0nster>
	<4C18D1FD.9060804@kernel.org> <1276695665.9309.17.camel@m0nster>
	<4C18D574.1040903@kernel.org> <1276697146.9309.27.camel@m0nster>
	<1276776066.2461.15.camel@localhost>
Date: Sat, 19 Jun 2010 10:38:03 +0200
In-Reply-To: <1276776066.2461.15.camel@localhost> (Andy Walls's message of
	"Thu, 17 Jun 2010 08:01:06 -0400")
Message-ID: <87vd9fo1sk.fsf@basil.nowhere.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Walls <awalls@md.metrocast.net> writes:
>
> I'm going to agree with Tejun, that tweaking worker thread priorities
> seems like an odd thing, since they are meant to handle deferable
> actions - things that can be put off until later.

> If one needs to support Real Time deadlines on deferable actions,
> wouldn't using dedicated kernel threads be more deterministic?
> Would the user ever up the priority for a workqueue other than a
> single-threaded workqueue?

One exceptional case here are things like high priority error handling
which is rare.

For example you get an MCE that tells you some of your
memory got corrupted and you should handle it ASAP.
Better give it high priority then.

But it's still a rare event so you don't want dedicated
threads hanging around for it all time
(that's what we currently have and it causes all sorts
of problems)

So yes I think having a priority mechanism for work items
is useful.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
