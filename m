Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974Ab0JERye (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 13:54:34 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:41087 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753675Ab0JERyd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 13:54:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=wiM3GunVYEDo7zHgp4CdZDByuokZykR4JLaCudB0Ki6w8rgmtm/WgMvY74RTBUfDHZ
         TaTRw5mFuiitnEvBcM8Bj8KXGegyFajdiaPayptoVzM405MJSMyODETUKL/JcKHjGrSC
         sGHWJWdTnOeic5Pt2kidhYJYxOdn9c/47DOso=
MIME-Version: 1.0
In-Reply-To: <4CAB5779.5020901@kernel.org>
References: <201009161546.16909.ruirui.r.yang@tieto.com>
	<20100917005227.GJ24409@dastard>
	<20100920191355.GA28443@infradead.org>
	<AANLkTi=45J+=ytj=NC4bYTVJFRakNQQiFd35K7mrf+Gq@mail.gmail.com>
	<4CA997DF.5030008@kernel.org>
	<20101004092107.GJ4681@dastard>
	<AANLkTi=3jjoCtYoK0endt8OM=omygO284WN2ZQZ=jceo@mail.gmail.com>
	<4CAB5779.5020901@kernel.org>
Date: Tue, 5 Oct 2010 19:54:32 +0200
Message-ID: <AANLkTinwFix7br+p+U2X_mNLTbb0umxQEL5+bhp5N0jW@mail.gmail.com>
Subject: Re: -mm: xfs lockdep warning
From: Torsten Kaiser <just.for.lkml@googlemail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>,
        Yang Ruirui <ruirui.r.yang@tieto.com>,
        Andrew Morton <akpm@linux-foundation.org>, xfs@oss.sgi.com,
        linux-kernel@vger.kernel.org, Alex Elder <aelder@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 5, 2010 at 6:51 PM, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> This is getting confusing.
>
> On 10/05/2010 12:09 PM, Torsten Kaiser wrote:
>> 2) the hang with 2.6.35-rc5 I have seen twice (triggered probably by
>> high load while building KOffice on an tmpfs)
>
> The trace doesn't seem to firmly point at xfs locking up.  There are
> md and dm crypt involved.  Are you sure this is locking up inside xfs?

Not 100%, but apart from the md/dm-worker the other prcesses got stuck
in sync_page() and do_lockup() and these function look filesystem
related. And the only filesystem I'm using on that system is XFS.

And having just read about some problems (that were fixed in
2.6.36-rc5) regarding XFS vs the new workqueues, I "feared" that I
somehow triggered some funny interaction between the workqueues of
XFS, md-raid1 and dm-crypt.

> Also, can you please enable frame pointers so that we can get more
> reliable backtrace?

I will do that and see if -rc6 gets stuck the same way.
But it might take until tomorrow to test this.

>> 3) the lockdep issue that started this thread and that I am seeing in
>> mainline 2.6.36-rc5 and -rc6 and that seems to be rather easy to
>> trigger for me.
>>
>> Because 3) is regarded as a false positive, it should not be the cause
>> of 2)
>
> For now, let's not draw any conclusion or mix the issues.  I'll look
> up the original thread and look into what the lockdep warning means.
>
> Thanks.
>
> --
> tejun
>
