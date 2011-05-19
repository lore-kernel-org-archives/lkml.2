Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933198Ab1ESPDF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 11:03:05 -0400
Received: from mail-px0-f173.google.com ([209.85.212.173]:50108 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932744Ab1ESPDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 11:03:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=dDo2UbAmNm626Aos2L3AZGhkVZjcfnW9AGTUgbmEtns74MSGeDaEvPqDmrF++NSMS0
         dYrJKCjd54v1eXrMr1aVlxzG0AAk7fMh82x4TeWPCXQeqEje1FwEVg6IK7DpQNExGQN7
         R7FXNpd57BNrzhreOSpzFiwyTQq7jnoIA8rdE=
MIME-Version: 1.0
In-Reply-To: <20110519144312.38177704@lxorguk.ukuu.org.uk>
References: <BANLkTikGxbcMBD=3W_9_mpZBoVDc8HrX8A@mail.gmail.com> <20110519144312.38177704@lxorguk.ukuu.org.uk>
From: "D. Jansen" <d.g.jansen@googlemail.com>
Date: Thu, 19 May 2011 17:02:21 +0200
Message-ID: <BANLkTikuEERvEnBvm9-zHy2Uoc=4PUwHjQ@mail.gmail.com>
Subject: Re: [rfc] Ignore Fsync Calls in Laptop_Mode
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, tytso@mit.edu
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 19, 2011 at 3:43 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> Problem: laptop_mode wants to keep applications from waking the hard
>> disks but fsync calls can "sneak through". (IMHO this is a bug.)
>
> Its a standards requirement and thing many apps rely on. Also you can do
> it perfectly well in user space for all apps. Thats why you can
> preconfigure preloads and it's why you have glic library source code!

Yes, it's another possibility I've considered. So then the patch
should go into glibc and glibc check for active laptop_mode? But if
implement it inside a library won't I get the same ordering guarantee
failure?
>
>> Proposed solution: Pretend the fsync was executed and successful.
>> Insert two lines into the fsync and fdatasync calls in fs/sync.c:
>> if (unlikely(laptop_mode))
>>    return 0;
>
> Whoops you've just risked corrupting any app which relies on fsync for
> ordering if there is a crash.
(...)
> The "right" way to do this is more complicated by far. An fsync is an
> ordering guarantee so you need to implement that ordering guarantee even
> if you don't force writes to physical media.

Ok. No problem, so the exit point would be a different one.

> That at least cuts down most failures (but not all - eg commits with a network
> component such as email receives)

I don't understand your email example.
