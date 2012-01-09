Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018Ab2AICdd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 21:33:33 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:57627 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521Ab2AICdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 21:33:32 -0500
X-AuditID: 9c930197-b7c0dae000006c54-02-4f0a51f7006c
Message-ID: <4F0A51F7.9040206@lge.com>
Date: Mon, 09 Jan 2012 11:33:27 +0900
From: Namhyung Kim <namhyung.kim@lge.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Namhyung Kim <namhyung.kim@lge.com>, axboe@kernel.dk, mingo@redhat.com,
        rostedt@goodmis.org, fweisbec@gmail.com, teravest@google.com,
        slavapestov@google.com, ctalbott@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/11] block: block_bio_complete tracepoint was missing
References: <1325806974-23486-1-git-send-email-tj@kernel.org> <1325806974-23486-4-git-send-email-tj@kernel.org> <4F0A431E.3090106@lge.com> <20120109014949.GA16360@mtj.dyndns.org>
In-Reply-To: <20120109014949.GA16360@mtj.dyndns.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2012-01-09 10:49 AM, Tejun Heo wrote:
> Hello,
>
> On Mon, Jan 09, 2012 at 10:30:06AM +0900, Namhyung Kim wrote:
>> Just adding the TP unconditionally will produce duplicated (in some
>> sense) reports about the completion. For example, normal request
>> based IO reports whole request completion prior to its bio's, and
>> further
>
> Request and bio completions are separate events.  There's nothing
> wrong with reporting them separately.  In fact, I think they should be
> reported separately.
>
>> , some of nested block IO handling routines - bounced bio and
>> btrfs with compression, etc - call bio_endio() more than once. Also
>> there are cases that bio fails before it's enqueued for some reason.
>
> They are actually separate bio's being completed.  I don't think
> trying to put extra semantics on TP itself is a good idea.  In
> general, TP signals that such event happened with sufficient
> information and it's the consumers' responsibility to make sense of
> what's going on.  BIO_CLONED/BOUNCED are there.

I see.


>> I have no idea about the ioblame can deal with all of such corner
>> cases. However it might confuse blktrace somewhat, I guess.
>
> Unless someone is doing memcpy() on bio's, ioblame should be okay.  It
> only considers bio's which went through actual submission.
>
>> I already posted similar patch a couple of weeks ago, but didn't
>> receive a comment yet. [1] Please take a look this too :)
>
> I'll reply there but don't think imposing such extra logic on TP is a
> good idea.

I'll reply on that thread too. :)


>> After a quick glance, the ioblame seems to carry all IO accounting
>> info through the first bio in the request. If so, why don't you use
>> the request structure for that?
>
> Because there are bio based drivers which don't use requests at all.

What I thought for such drivers was dynamic allocation in their 
->make_request_fn, but because we don't have a block_bio_issue TP, 
Nevermind. :)


Thanks,
Namhyung Kim
