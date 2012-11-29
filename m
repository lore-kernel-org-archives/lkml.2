Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892Ab2K2QFc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 11:05:32 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:63579 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753466Ab2K2QFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 11:05:30 -0500
MIME-Version: 1.0
In-Reply-To: <20121128210509.GA2590@local>
References: <201211271348.14603.vitas@nppfactor.kiev.ua>
	<20121127224341.GA2605@local>
	<201211281058.33185.vitas@nppfactor.kiev.ua>
	<20121128210509.GA2590@local>
Date: Thu, 29 Nov 2012 17:05:27 +0100
X-Google-Sender-Auth: zsdiLiMY21BF5V8adUEx1X5sk04
Message-ID: <CAM3j68rrBePLoamRb1pCH+TeAfLDO-5Jd_kk7-JRCNnEBhLp2Q@mail.gmail.com>
Subject: Re: [PATCH] uio.c: Fix warning: 'ret' might be used uninitialized
From: Tux9 <tuxding@gmail.com>
To: "Hans J. Koch" <hjk@hansjkoch.de>
Cc: Vitalii Demianets <vitas@nppfactor.kiev.ua>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hans, I think there are something wrong in your patch, while Vitalii's
is right. The variable "ret" is reused in line 292 and line 295, so
the value of "ret" would be overridden (if it goto err_map in line 284
when mi>=1).

Best,
Cong

On Wed, Nov 28, 2012 at 10:05 PM, Hans J. Koch <hjk@hansjkoch.de> wrote:
> On Wed, Nov 28, 2012 at 10:58:32AM +0200, Vitalii Demianets wrote:
>> On Wednesday 28 November 2012 00:43:41 Hans J. Koch wrote:
>> >
>> > Thanks, good catch, but why don't you simply do this:
>> >
>>
>> Just a matter of personal preference.
>
> Your patch: 1 files changed, 12 insertions(+), 4 deletions(-)
> My patch: 1 files changed, 1 insertions(+), 1 deletions(-)
>
> Both achieve exactly the same. That's not a matter of personal
> preference, that's the difference between a working solution and
> a good solution. In the kernel, we want the latter.
>
>> As a maintainer you can apply either
>> patch you want. I guess you would prefer your approach and I have no
>> objections to that :)
>
> That's not the right kind of comment. Don't make it a habit.
>
> Thanks,
> Hans
>
>>
>> >
>> > >From 228445996bb75a44d16b6237eca6a0916d9b2d7e Mon Sep 17 00:00:00 2001
>> > From: "Hans J. Koch" <hjk@hansjkoch.de>
>> > Date: Tue, 27 Nov 2012 23:38:00 +0100
>> > Subject: [PATCH] uio: Fix warning: 'ret' might be used uninitialized
>> >
>> > In two cases, the return value variable "ret" can be undefined.
>> >
>> > Signed-off-by: Hans J. Koch <hjk@hansjkoch.de>
>> > ---
>> >  drivers/uio/uio.c |    2 +-
>> >  1 files changed, 1 insertions(+), 1 deletions(-)
>> >
>> > diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
>> > index 5110f36..fc60e35 100644
>> > --- a/drivers/uio/uio.c
>> > +++ b/drivers/uio/uio.c
>> > @@ -263,7 +263,7 @@ static struct class uio_class = {
>> >   */
>> >  static int uio_dev_add_attributes(struct uio_device *idev)
>> >  {
>> > -   int ret;
>> > +   int ret = -ENOMEM;
>> >     int mi, pi;
>> >     int map_found = 0;
>> >     int portio_found = 0;
>>
>>
>>
>> --
>> With Best Regards,
>> Vitalii Demianets
>>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
