Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756708Ab0JOTYM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 15:24:12 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63632 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755471Ab0JOTYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 15:24:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=eYwUG/QPTqjXZG9OmKeszRMzmhD083Vy4SHl+yniw0xC7miNIHk55F8i3nMFgkeBE4
         4WuBF1a83RdZ6bJMIhtCm+Ff5MruHO5rTh4FK0lZJJUkj1PPU8DVm6/odJYC1s2isqh7
         jWugav417Rfs1KUUFZfU037phA+AfOqFpvXNk=
MIME-Version: 1.0
In-Reply-To: <20101015001904I.fujita.tomonori@lab.ntt.co.jp>
References: <87sk0a1sq0.fsf@basil.nowhere.org>
	<20101014160217N.fujita.tomonori@lab.ntt.co.jp>
	<AANLkTin-8mjL_B8g9cPoviQU0FUaEyb_v5_Fm4kbSweA@mail.gmail.com>
	<20101015001904I.fujita.tomonori@lab.ntt.co.jp>
Date: Fri, 15 Oct 2010 00:50:49 +0300
Message-ID: <AANLkTik7Gj0M64D8kYoToja3QmmSLMCUQHjVPKibp0Qm@mail.gmail.com>
Subject: Re: [RFC][PATCH 1/3] contigous big page allocator
From: Felipe Contreras <felipe.contreras@gmail.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: andi@firstfloor.org, kamezawa.hiroyu@jp.fujitsu.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, minchan.kim@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 14, 2010 at 6:24 PM, FUJITA Tomonori
<fujita.tomonori@lab.ntt.co.jp> wrote:
> On Thu, 14 Oct 2010 15:09:13 +0300
> Felipe Contreras <felipe.contreras@gmail.com> wrote:
>
>> > As already pointed out, some embeded drivers need physcailly
>> > contignous memory. Currenlty, they use hacky tricks (e.g. playing with
>> > the boot memory allocators). There are several proposals for this like
>> > adding a new kernel memory allocator (from samsung).
>> >
>> > It's ideal if the memory allocator can handle this, I think.
>>
>> Not only contiguous, but sometimes also coherent.
>
> Can you give the list of such drivers?

omapfb and tidspbridge. Perhaps tidspbridge can be modified to flush
the relevant memory, but for now it does. I'm not sure about omapfb,
but it would be very likely that user-space would need to be modified
if flushes suddenly become required.

-- 
Felipe Contreras
