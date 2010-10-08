Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932275Ab0JHKY0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 06:24:26 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:35617 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754020Ab0JHKYY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 06:24:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ZR4pPUGtRtsPWV0EaaXUeLHBZdsxsELzLNE742X0EeLSIOWUDjSBXDdiq2WpwG4Ypp
         QCtqqSWbHd6pVvJB/DZc110UXZhsbcU1ZnbJ45s3BRUfFfQO3PMUMyIOIdVb+ZnR3w1p
         K6pMlj1QGRHkOlkhz81RP9SFQpX4SRE0c9TNo=
MIME-Version: 1.0
In-Reply-To: <AANLkTinP7tA87anzgN6Yi3p_FtJ7bJHmEZc6rKX=o+-R@mail.gmail.com>
References: <20101005124521.GA2602@darkstar>
	<201010061935.45010.rusty@rustcorp.com.au>
	<AANLkTinP7tA87anzgN6Yi3p_FtJ7bJHmEZc6rKX=o+-R@mail.gmail.com>
Date: Fri, 8 Oct 2010 18:24:23 +0800
Message-ID: <AANLkTinLYy3vUp8VPzv=q3br-zBrE239MRpwMAAsmtKD@mail.gmail.com>
Subject: Re: [PATCH] kvm: add oom notifier for virtio balloon
From: Dave Young <hidave.darkstar@gmail.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
        Anthony Liguori <anthony@codemonkey.ws>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 6, 2010 at 9:50 PM, Dave Young <hidave.darkstar@gmail.com> wrote:
> On Wed, Oct 6, 2010 at 5:05 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
>> On Tue, 5 Oct 2010 11:15:21 pm Dave Young wrote:
>>> Balloon could cause guest memory oom killing and panic.
>>>
>>> Add oom notify to leak some memory and retry fill balloon after 5 minutes.
>>
>> Have you tried registering a shrinker?  See mm.h.
>
> Hi, thanks. I didn't know shrinker can shrink mem beyond slab. Will try
Hi, rusty

I did some test with shrinker, findings as following:

1. shrinker is for ageable cache shrinking, balloon pages is a different kind
2. oom notifier is a last minute shrink, but shrinker is more conservative.
after my tests of "balloon 30" for a slackware 13.0 guest, free -m in guest
oom notifier results 17M
shrinker results 77M

3. Aside of above use mutex locking in shrinker cause kernel hang, no
idea how to fix it


>
>>
>> Thanks,
>> Rusty.
>>
>
>
>
> --
> Regards
> dave
>



-- 
Regards
dave
