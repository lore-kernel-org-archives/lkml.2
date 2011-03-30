Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755938Ab1C3N2M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 09:28:12 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:64104 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798Ab1C3N2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 09:28:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=odXwbMBLo4+Xs0AvgGGjEsitAO+VK3+yFNBUviUPRZ7OworGegu6cjUAl5wnlffjrH
         CwCvOxwvgCZAni8pGJWkZP5CPFqtEMDC/OvVmJ0N+3Q15BjV/qgTX1Jl1jrhXCX9OKWY
         Q5KnQXIgmU3oo5oX0FoB0iLcRA0+wlShGPSDg=
MIME-Version: 1.0
In-Reply-To: <849307$c7qtj5@azsmga001.ch.intel.com>
References: <1301310995.5615.92.camel@wangqingchuan>
	<1301336010.2217.20.camel@workstation>
	<AANLkTikMJszEyv8-SMMjD-MeykSwmsKf=gmezcMgySoP@mail.gmail.com>
	<1301409864.5615.98.camel@wangqingchuan>
	<AANLkTi=fcWBpmQ66a3+vQwgFOXn=0rJAviNzR4a0mfcJ@mail.gmail.com>
	<1301421664.2151.12.camel@Portable-Work>
	<AANLkTin_v5h==E0i5mQgK2AEdaZhwViykr3acbz4CW0k@mail.gmail.com>
	<20110329202608.GA3454@viiv.ffwll.ch>
	<AANLkTim2AyGPrun8MNq0=TyXpJ+b8i=eyHhLz01F+f2P@mail.gmail.com>
	<AANLkTi=vFwoKCOsvyGBQA9w01QX_TwGu_GF6mA0grr2o@mail.gmail.com>
	<849307$c7qtj5@azsmga001.ch.intel.com>
Date: Wed, 30 Mar 2011 09:28:07 -0400
Message-ID: <AANLkTinxVznFtHwM2RM3kNm9-eSXuz9L7TgfaMpgu=uZ@mail.gmail.com>
Subject: Re: GEM-related desktop sluggishness due to linear-time arch_get_unmapped_area_topdown()
From: Jerome Glisse <j.glisse@gmail.com>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Dave Airlie <airlied@gmail.com>, r6144 <rainy6144@gmail.com>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 30, 2011 at 3:32 AM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> On Wed, 30 Mar 2011 07:57:49 +1000, Dave Airlie <airlied@gmail.com> wrote:
>> On Wed, Mar 30, 2011 at 7:04 AM, Jerome Glisse <j.glisse@gmail.com> wrote:
>> > What i had in mind was something little bit more advance that pwrite,
>> > somethings that would take width,height,pitch of userpage and would be
>> > able to perform proper blit. But yes pwrite in intel is kind of
>> > limited.
>>
>> TTM has support for userpage binding we just don't use it.
>
> Yes, and I've been experimenting with the same in GEM to great effect in
> the DDX. The complication remains in managing the CPU synchronisation,
> which suggests that it would only be useful for STREAM_DRAW objects (and
> perhaps the sub-region updates to STATIC_DRAW). (And for readback, if
> retrieving the data were the actual bottleneck.)

What do you mean by CPU synchronisation ? In what i had in mind the
upload/download would block userspace until operation is, this would
make upload/dowload barrier of course it doesn't play well with
usecase where you keep uploading/downloading (idea to aleviate that is
to allow several download/upload in one ioctl call).

> And I did play with a new pread/pwrite interface that did as you suggest,
> binding the user pages and performing a blit. But by the time you make the
> interface asynchronous, it becomes much easier to let the client code
> create the mapping and be fully aware of the barriers.
>
> And yes I do concur that vma bookkeeping does impose significant overheads
> and I have been removing as many mappings from our drivers as I can; within
> the limitations of the pwrite interface.
> -Chris
>
> --
> Chris Wilson, Intel Open Source Technology Centre
>

Cheers,
Jerome
