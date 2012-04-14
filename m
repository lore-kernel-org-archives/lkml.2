Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756519Ab2DNWJ3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 18:09:29 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:48686 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756427Ab2DNWJ1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 18:09:27 -0400
MIME-Version: 1.0
In-Reply-To: <20120414232124.1ffd7ac9@stein>
References: <20120411231102.GA6404@kroah.com>
	<CAJyhjX2KrfSJW64PJMTHou9zSojsfA1iNT-WahinfMBce_B=BA@mail.gmail.com>
	<20120412002927.GA23167@kroah.com>
	<CAMP44s3Jh-t07A+i82qbAMQyEN0oWTmKk5BJcst942gFdD0=VA@mail.gmail.com>
	<20120412011313.GA23764@kroah.com>
	<CAMP44s2q+bQE3-zsX4bs=sQDt4jf8eE5bwZ8V88UjodjRyAjog@mail.gmail.com>
	<20120412144626.GA14868@kroah.com>
	<CAMP44s1T4EVwpzDuV_vV0Zh-5WcPCwdw9eeOfL17Geqp_UFN-Q@mail.gmail.com>
	<CAJ-VmonhwvnXPKa=LNOR4W0ZTXZqWmzw4UrsKLoE0YN_Bu0FzQ@mail.gmail.com>
	<CAMP44s2JPvhEB6Eb049Z_bToAFncHKMEheuyaxyhC=bnh2GJVg@mail.gmail.com>
	<20120413105746.10ffb120@stein>
	<CAMP44s0RohH9tPiM5qCDT57XBV=iO66PZkSjYVxA6Usg1qJPtw@mail.gmail.com>
	<20120413154216.476a02ac@stein>
	<CAMP44s10KVwL5pY=Q5hWfyUtU6CvvZZ4Bcg-fEY9dAhSL306aQ@mail.gmail.com>
	<20120414094137.54a7f213@stein>
	<CAMP44s2Un-M2OCmuRQGpGsHR21gH=S7oJKx4Ci8tvYVCCSitUw@mail.gmail.com>
	<20120414195559.3d5ab944@stein>
	<CAMP44s0ngzwkbQapTip=oW1b5m2uO5zCzbXHVqHXwT2+Wpgo_A@mail.gmail.com>
	<20120414232124.1ffd7ac9@stein>
Date: Sun, 15 Apr 2012 01:09:25 +0300
Message-ID: <CAMP44s05k3YkXSLGdYjJ42d+uEM+bLS9uZ+2ztUBWqcO6kyUtA@mail.gmail.com>
Subject: Re: [ 00/78] 3.3.2-stable review
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Adrian Chadd <adrian@freebsd.org>, Greg KH <gregkh@linuxfoundation.org>,
        Sergio Correia <lists@uece.net>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        linux-wireless Mailing List <linux-wireless@vger.kernel.org>,
        Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
        "John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 15, 2012 at 12:21 AM, Stefan Richter
<stefanr@s5r6.in-berlin.de> wrote:
> On Apr 14 Felipe Contreras wrote:
>> On Sat, Apr 14, 2012 at 8:55 PM, Stefan Richter
>> <stefanr@s5r6.in-berlin.de> wrote:
>> > Generally, "commit + push out" makes it undroppable.  In case of -stable,
>> > commit/ push out/ tag are close and virtually identical.
>> >
>> > After a change was pushed out, the choice narrows down to add a reverting
>> > change for a subsequent release or to rebase to a point before the
>> > defective commit.  The latter is not done to -stable, obviously.  (3.3.2
>> > is not being restarted from 3.3 if a regression from 3.3 to 3.3.1 was
>> > discovered.)
>>
>> That's irrelevant; whether you rebase and drop the patch, or you
>> revert it, the resulting code is *exactly* the same. It's also the
>> same if Greg drops it from his quilt queue before pushing (assuming
>> that's what he uses).
>
> The result may be the same (sometimes it actually isn't),

If the result is not the same, then that's a different situation; I'm
talking about true reverts/drops in which the result is *exactly* the
same. OK?

>> Let's avoid this semantic red herring, by undroppable I mean
>> unrevertable, or undiscardable, or anything that effectively makes the
>> patch not be there.
>
> How do you "make it not be there"?  By adding a reverting patch.
>
> The reverting patch needs to come from somewhere, and the only
> disagreement is basically through which channels the patch should be
> allowed to come, or which qualifications this reverting patch should
> fulfill.

If the patch was tagged in a release, yes, but if the patch was in the
queue, but never tagged, it can be dropped.

The question that has not been answered is what makes them different, and why.

>> >> But *why*? You say you *really* need to problem to fixed in mainline,
>> >> that's why it cannot be dropped, but that applies also to patches in
>> >> the queue *before* the tag is made, doesn't it? If you find a patch in
>> >> the stable review queue causes problems, why don't you leave it there?
>> >
>> > As Willy wrote, that's actually what is done sometimes.  I didn't know
>> > that.
>>
>> Don't avoid the question.
>
> Willy answered that, hence I didn't think I have to.  The patch can in
> fact be kept in the stable queue as a reminder, it just should not be
> applied to stable as long as there is no resolution for mainline.

>> I don't mean just leave it in the queue, I mean leave it so it gets
>> tagged in the release.
>
> That would be even sillier than the discussion which we are having.

Exactly!

I'm glad you see it's silly to put bad patches in the stable release
just so they get properly tracked for mainline, but that's exactly
what you arguing for.

Now all you have to do is explain why it's silly before the tag, but not after.

-- 
Felipe Contreras
