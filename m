Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758006Ab0GHOJ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 10:09:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64773 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756820Ab0GHOJ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 10:09:57 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Jens Axboe <axboe@kernel.dk>, Corrado Zoccolo <czoccolo@gmail.com>,
       Nauman Rafique <nauman@google.com>, Divyesh Shah <dpshah@google.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: Re: [RFC/RFT PATCH] cfq-iosched: Implement cfq group idling
References: <20100707230521.GB7842@redhat.com>
	<x4939vuf5y6.fsf@segfault.boston.devel.redhat.com>
	<20100708135625.GD5093@redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 08 Jul 2010 10:08:44 -0400
In-Reply-To: <20100708135625.GD5093@redhat.com> (Vivek Goyal's message of
	"Thu, 8 Jul 2010 09:56:25 -0400")
Message-ID: <x49r5jedq1f.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> On Thu, Jul 08, 2010 at 09:39:45AM -0400, Jeff Moyer wrote:
>> Vivek Goyal <vgoyal@redhat.com> writes:
>> 
>> > Currently we idle on sequential queues and allow dispatch from a single
>> > queue and that can become a bottleneck on higher end storage. For example
>> > on my HP EVA, I can run multiple sequential streams and achieve top BW
>> > of around 350 MB/s. But with CFQ, dispatching from single queue does not
>> > keep the array busy (limits to 150-180 MB/s with 4 or 8 processes).
>> >
>> > One approach to solve this issue is simply use slice_idle = 0. But this
>> > also takes away the any service differentiation between groups.
>> 
>> That also takes away service differentiation between queues.  If you
>> want to maintain that at all, then this is really just pushing the
>> problem to another layer.
>> 
>
> Yes it does take away the io priority with-in group. But I think that's
> the trade-off and that's not default. So those who don't require ioprio
> stuff working with-in group and those who know that they have got
> faster storage will set slice_idle=0. For rest of the SATA users default
> is still slice_idle=8.

[snip]

Sorry, Vivek, I'm actually hijacking your thread.  ;-)  I know what the
alternatives are, what I'm looking for is guidance on what Jens wants to
do with CFQ.  We can discuss the merits of different approaches once we
agree on a set of requirements.

Cheers,
Jeff
