Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230Ab1DZXds (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 19:33:48 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:52427 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519Ab1DZXdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 19:33:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=aLoDTElzQK0d/YWb0yn3jCeeB5AEBllquLaFOXKn13swNGMcwjdrIlmqGYVKdvqAQa
         AvV650tY2lX3jfotq/TzhlmmlY63+/j/5+N4o3OG+2aqZagg32zVgVBmbuu5ef+phEv5
         GmDFJUlnwAKqyx5vq+2tmZDSue6h0newUZD5U=
MIME-Version: 1.0
In-Reply-To: <BANLkTin0wj3AhCtR5ZD=N_LUKjE1etBcFg@mail.gmail.com>
References: <20110426085953.GA12389@darkstar>
	<BANLkTikkUq7rg4umYQ5yt9ve+q34Pf+=Ag@mail.gmail.com>
	<BANLkTin0wj3AhCtR5ZD=N_LUKjE1etBcFg@mail.gmail.com>
Date: Wed, 27 Apr 2011 08:33:46 +0900
Message-ID: <BANLkTim067_+bycA-rJk6u595YucMmruqQ@mail.gmail.com>
Subject: Re: [PATCH v2] virtio_balloon: disable oom killer when fill balloon
From: Minchan Kim <minchan.kim@gmail.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kosaki.motohiro@jp.fujitsu.com, linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 26, 2011 at 6:39 PM, Dave Young <hidave.darkstar@gmail.com> wrote:
> On Tue, Apr 26, 2011 at 5:28 PM, Minchan Kim <minchan.kim@gmail.com> wrote:
>> Please resend this with [2/2] to linux-mm.
>>
>> On Tue, Apr 26, 2011 at 5:59 PM, Dave Young <hidave.darkstar@gmail.com> wrote:
>>> When memory pressure is high, virtio ballooning will probably cause oom killing.
>>> Even if alloc_page with GFP_NORETRY itself does not directly trigger oom it
>>> will make memory becoming low then memory alloc of other processes will trigger
>>> oom killing. It is not desired behaviour.
>>
>> I can't understand why it is undesirable.
>> Why do we have to handle it specially?
>>
>
> Suppose user run some random memory hogging process while ballooning
> it will be undesirable.


In VM POV, kvm and random memory hogging processes are customers.
If we handle ballooning specially with disable OOM, what happens other
processes requires memory at same time? Should they wait for balloon
driver to release memory?

I don't know your point. Sorry.
Could you explain your scenario in detail for justify your idea?
And as I previous said, we have to solve oom_killer_disabled issue in
do_try_to_free_pages.

Thanks, Dave.
-- 
Kind regards,
Minchan Kim
