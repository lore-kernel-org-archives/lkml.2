Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367Ab1HXRy2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 13:54:28 -0400
Received: from 87-104-106-3-dynamic-customer.profibernet.dk ([87.104.106.3]:56885
	"EHLO kernel.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753386Ab1HXRyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 13:54:08 -0400
Message-ID: <4E553ABF.3030904@kernel.dk>
Date: Wed, 24 Aug 2011 19:54:07 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Philipp Reisner <philipp.reisner@linbit.com>
CC: Kyle Moffett <kyle@moffetthome.net>, linux-kernel@vger.kernel.org,
        drbd-dev@lists.linbit.com
Subject: Re: [GIT PULL] drbd-8.4 for mainline
References: <201108241641.42676.philipp.reisner@linbit.com> <CAGZ=bq+A1ExZYRnuBBwfAq7Ez37mpBtT1_T91AWcchDBZ3iqPw@mail.gmail.com> <4E552E9C.2000104@kernel.dk> <201108241949.43716.philipp.reisner@linbit.com>
In-Reply-To: <201108241949.43716.philipp.reisner@linbit.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-08-24 19:49, Philipp Reisner wrote:
> Am Mittwoch 24 August 2011, 19:02:20 schrieb Jens Axboe:
>> On 2011-08-24 18:00, Kyle Moffett wrote:
>>> On Wed, Aug 24, 2011 at 10:41, Philipp Reisner
>>>
>>> <philipp.reisner@linbit.com> wrote:
>>>> Hi Jens,
>>>>
>>>> First the announcement of drbd-8.4, then the git pull-request text:
>>>>
>>>> We are proud to announce the availability of DRBD-8.4.0.
>>>>
>>>>  The most noticeable change is the support for multiple replicated
>>>>  volumes in a single DRBD connection.
>>>>  Write-ordering is obeyed among all writes in all volumes in a
>>>>  single connection.
>>>>  This feature is really important for users who DRBD for mirroring
>>>>  over longer distances. (Protocol A).
>>>>
>>>> We do not only release DRBD-8.4.0 today:
>>>> The DRBD User's Guide was reviewed and updated to match DRBD-8.4.
>>>>
>>>> I suggest to everybody who considers to upgrade from 8.3 to 8.4
>>>> to have a look at the "Recent changes" appendix of the UG:
>>>> http://www.drbd.org/users-guide/ap-recent-changes.html
>>>>
>>>>  This release brings a new meta-data format. Forward (8.3 -> 8.4)
>>>>  conversion happens complete seamless. Backward conversion
>>>>  is done by a single command (drbdadm apply-al res).
>>>>  
>>>>  This release is protocol compatible with all it predecessor.
>>>>  Although, we do not recommend to run it in 8.3 - 8.4 for long
>>>>  time frames. We recommend to use that capability only for the
>>>>  rolling upgrade.
>>>>  
>>>>  drbdadm of 8.4 can parse config files of 8.3. We recommend
>>>>  to switch to the new configuration syntax after the upgrade
>>>>  of both nodes. (Use drbdadm dump to learn about the new
>>>>  config syntax)
>>>
>>> Hm...
>>>
>>> That's a lot of patches (including some protocol changes) that have not
>>> yet been reviewed by other kernel developers.
>>>
>>> By officially releasing the kernel and user-space bits and then posting
>>> them to LKML and expecting them to be merged as-is, you are not really
>>> following the linux kernel development process.
>>>
>>> Some of the reverts and commit messages make me concerned that your
>>> patch series has bisection issues; are you sure it compiles and runs
>>> after every patch?
>>>
>>> I'm obviously not anywhere in the maintenance chain for this code, but
>>> it does look really funny.
>>
>> That was my exact response a few weeks back, but I don't recall seeing
>> anything until this email today. Philipp, has this been reviewed at all
>> outside your internal group?
> 
> Yes, I requested review on LKML. See here: https://lkml.org/lkml/2011/8/8/179

You are not going to get any reviews this way. You need to make it a lot
easier for people to review patches individually. Requiring that people
pull your repo, then look at each change in there, is not going to work.
That's a lot of work up front. And how do you respond to code? Paste
into an email, copy/paste recepients, send. Even more work. End result,
nobody will EVER review such a posting as the above. I see you got one
guy to write back with an error, which I think is probably more a
testament to the user base than anything else.

So, please do this right. The email you sent is perfect for a 0/N header
email, then each patch must follow as a reply to that. There's git
send-email to help you with this. If you haven't used it before, I'd
advise you to do a dry-run or two to your own email address to ensure
that it produces the right result. When it does, then send it off to
lkml and myself. Then I too will see reviews and have a better chance of
judging whether this is mergeable now or not.

-- 
Jens Axboe

