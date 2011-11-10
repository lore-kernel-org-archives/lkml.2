Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935532Ab1KJQD0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 11:03:26 -0500
Received: from locusts.copyleft.no ([178.255.144.241]:51350 "EHLO
	mail.mailgateway.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932857Ab1KJQDX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 11:03:23 -0500
MIME-Version: 1.0
In-Reply-To: <7vaa84t3ek.fsf@alter.siamese.dyndns.org>
References: <20111026202235.GA20928@havoc.gtf.org>
	<1319969101.5215.20.camel@dabdike>
	<CA+55aFx1NGWfNJAKDTvZfsHDDKiEtS4t4RydSgHurBeyGPyhXg@mail.gmail.com>
	<1320049150.8283.19.camel@dabdike>
	<CA+55aFz3=cbciRfTYodNhdEetXYxTARGTfpP9GL9RZK222XmKQ@mail.gmail.com>
	<7vy5w1ow90.fsf@alter.siamese.dyndns.org>
	<CA+55aFwL_s=DcT46dprcYVWEAm_=WkuTV6K9dAn3wc_bDQU8vA@mail.gmail.com>
	<7vwrbjlj5r.fsf@alter.siamese.dyndns.org>
	<CA+55aFx_rAA6TJkZn1Zvu6u9UjxnmTVt0HpMnvaE_q9Sx-jzPg@mail.gmail.com>
	<7vk47jld5s.fsf@alter.siamese.dyndns.org>
	<CA+55aFz7TeQQH3D4Tpp31cZYZoQKeK37jouo+2Kh61Wa07knfw@mail.gmail.com>
	<CAJo=hJv5nAKH_ptYSWfMvFQv0Dj+naPXK35wSzKYkfPOYsWkxg@mail.gmail.com>
	<CA+55aFx0oCd6-sh0psYxho-s=sHAK0RHXJHfLewRuUcdXzxZbg@mail.gmail.com>
	<CA+55aFwXu=+HdQ5nW11Ts5p-V=KgpxjyagKqB+Xv+qBOEEWXvQ@mail.gmail.com>
	<7v62j1gitn.fsf@alter.siamese.dyndns.org>
	<7vvcr1f38j.fsf@alter.siamese.dyndns.org>
	<CA+55aFyRawm9CoJMiEXDFCX4YTidPOiV4oqSS2d7nNv7Ecw8BQ@mail.gmail.com>
	<7v4nydurzh.fsf@alter.siamese.dyndns.org>
	<CALKQrgfZtELcK3H5ZYvmcW8RrtKMVRACFTvw3s5SidFvmFWkGw@mail.gmail.com>
	<7vaa84t3ek.fsf@alter.siamese.dyndns.org>
Date: Thu, 10 Nov 2011 17:03:17 +0100
Message-ID: <CALKQrgdxEXQGKQ3t9Sh82=U933ypHNg8duyVmG9uJbg2iST5fw@mail.gmail.com>
Subject: Re: [git patches] libata updates, GPG signed (but see admin notes)
From: Johan Herland <johan@herland.net>
To: Junio C Hamano <junio@pobox.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "Ted Ts'o" <tytso@mit.edu>,
        Shawn Pearce <spearce@spearce.org>, git@vger.kernel.org,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Jeff Garzik <jeff@garzik.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 10, 2011 at 16:15, Junio C Hamano <junio@pobox.com> wrote:
> Johan Herland <johan@herland.net> writes:
>> On Wed, Nov 9, 2011 at 18:26, Junio C Hamano <gitster@pobox.com> wrote:
>>>  - "git notes" is represented as a commit that records a tree that holds
>>>   the entire mapping from commit to its annotations, and the only way to
>>>   transferr it is to send it together with its history as a whole. It
>>>   does not have the nice auto-following property that transfers only the
>>>   relevant annotations.
>>
>> True. However, consider these mitigating factors:
>> ...
>>
>> My point is that although "notes" might end up transferring more
>> annotations than strictly necessary, I believe that in practice all the
>> notes being transferred are already (or will soon become) relevant.
>
> Sorry, but I do not think you are considering what would happen when you
> have many branches with different purposes, whose commits near tips will
> never get merged with each other. "automatic following" semantics like
> what "git fetch" does for signed tags is absolutely necessary in such a
> case, and the above are not mitigating factors at all in that context.

What about having one notes ref per branch? If/when the branch is merged,
the associated notes ref containing the annotations for the commits on that
branch would be merged as well (using "git notes merge").

Sure, using one notes ref per branch is more expensive than a single notes
ref, but it's still cheaper than one ref per signed commit (which is what we
get when using annotated tags). And it prevents the added code and
complexity of the timestamped mapping approach.


...Johan

-- 
Johan Herland, <johan@herland.net>
www.herland.net
