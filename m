Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753857Ab1HZPTP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 11:19:15 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:40372 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753464Ab1HZPTO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 11:19:14 -0400
MIME-Version: 1.0
In-Reply-To: <20110826135402.GS14479@barkeeper1-xen.linbit>
References: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
 <CAGpXXZKem-uEdF4SyUgpQFV6=d5Vo3v9p3wmcaygAKa4w4x01w@mail.gmail.com> <20110826135402.GS14479@barkeeper1-xen.linbit>
From: Kyle Moffett <kyle@moffetthome.net>
Date: Fri, 26 Aug 2011 11:18:53 -0400
Message-ID: <CAGZ=bqJojmtfVjQdbx3j2vZyrz01dZZs7wVqBxNbqreejZu4JQ@mail.gmail.com>
Subject: Re: [Drbd-dev] [RFC 000/118] drbd: part 1 of adding multiple volume
 support to drbd
To: Greg Freemyer <greg.freemyer@gmail.com>,
        Philipp Reisner <philipp.reisner@linbit.com>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        drbd-dev@lists.linbit.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 26, 2011 at 09:54, Lars Ellenberg <lars.ellenberg@linbit.com> wrote:
> On Fri, Aug 26, 2011 at 09:20:51AM -0400, Greg Freemyer wrote:
>> On Thu, Aug 25, 2011 at 11:06 AM, Philipp Reisner <
>> philipp.reisner@linbit.com> wrote:
>>
>> > This the first request for review of drbd-8.4. The complete set has
>> > 500 patches. In this first series there are only 118 of these.
>>
>> I've only taken a quick glance, but is drbd functional between applying each
>> patch?
>>
>> It doesn't look like it to me, but I didn't look that close.  I also saw at
>> least one patch that introduced a new function with no caller to test it.
>>
>> The idea is that a patch series leave a testable / functional kernel after
>> each patch in the series is applied sequentially.
>>
>> That is the only way git bisect can do its job.
>
> Very likely DRBD will not always be completely functional between
> any arbitrary two of these patches.
>
> The kernel as such will still be bisectable "just fine".

No.

That's not the way that kernel development works.

Besides which, that's not the way that "git bisect" works.

For example, say I have a driver bug that happens to be triggering
on my server which also happens to use GFS on DRBD.  I try to
bisect the bug and it happens to pick a commit right in the middle
of this DRBD branch.

Suddenly DRBD is unusable or corrupting data or something, which
is unacceptable for an unrelated bisection of a driver bug.

So if you want these patches merged into the kernel, you need to
do them properly as per Documentation/SubmittingPatches.

Cheers,
Kyle Moffett
