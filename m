Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755499Ab2BFUQQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 15:16:16 -0500
Received: from casper.infradead.org ([85.118.1.10]:55087 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754175Ab2BFUQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 15:16:15 -0500
Message-ID: <4F303506.9000201@kernel.dk>
Date: Mon, 06 Feb 2012 21:16:06 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Vivek Goyal <vgoyal@redhat.com>,
        Shaohua Li <vivek.goyal2008@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Knut Petersen <Knut_Petersen@t-online.de>, mroos@linux.ee
Subject: Re: [patch]block: fix ioc locking warning
References: <1328514611.21268.66.camel@sli10-conroe> <20120206151219.GC30752@redhat.com> <4F2FFB21.9000202@kernel.dk> <20120206163721.GF30752@redhat.com> <20120206164428.GA21292@google.com> <CA+55aFx6BR_ZUHd8d64btu-LzsPHo3Ot_d1-5jJytjQUqvvaiQ@mail.gmail.com> <20120206172706.GB21292@google.com>
In-Reply-To: <20120206172706.GB21292@google.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-02-06 18:27, Tejun Heo wrote:
> Hello,
> 
> On Mon, Feb 06, 2012 at 08:58:49AM -0800, Linus Torvalds wrote:
>> On Mon, Feb 6, 2012 at 8:44 AM, Tejun Heo <tj@kernel.org> wrote:
>>>
>>> Yeah, this seems better to me.  Jens, if you're gonna amend the
>>> commit, please consider collapsing the following patch into the
>>> original patch too.  Thanks.
>>
>> Guys, is it *really* worth it to do all these crazy games?
>>
>> How bad is it to just always use the async freeing, instead of this
>> clearly very fragile crazy direct-freeing-with-serious-locking-issues
>> thing?
> 
> It's one wq scheduling on exit for any task which has issued an IO.  I
> don't think it would matter except for task fork/exit microbenchs (or
> workloads which approximate to that).  I'll get some measurements and
> strip the optimization if it doesn't really show up.

One (arguably stupid) thing that some users do do is something like:

$ find . -exec grep foo '{}' \;

So that would probably be a good pathological test case for this.

-- 
Jens Axboe

