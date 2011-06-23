Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752742Ab1FWFWT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 01:22:19 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59018 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996Ab1FWFWS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 01:22:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=tKizSD4LpFPofAmLeV8FFgN7VLC7DoCAgUJyfNz7DEhuMqaFWX88yvMyEEFQ9/B9Cw
         kTeb8b8eUQ9pWcaTguImghGImIyX7U8k138REwT0QFRp2fWsRPDR4BA/IpUZ2AG8MJA9
         iC5axQwcx7k4Nk/2AH0MSW0Her8sjj4TgJv5k=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1106181630480.3431@chino.kir.corp.google.com>
References: <20110618071308.GA24743@cr0>
	<alpine.DEB.2.00.1106181630480.3431@chino.kir.corp.google.com>
Date: Thu, 23 Jun 2011 13:22:17 +0800
Message-ID: <BANLkTi=7O2hW37Mt2NCvxDQq6Ldsa6XhXw@mail.gmail.com>
Subject: Re: [Patch] hugetlb: remove user_shm_lock() check from hugetlb_file_setup()
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Ravikiran Thirumalai <kiran@scalex86.org>,
        William Irwin <wli@holomorphy.com>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 19, 2011 at 7:34 AM, David Rientjes <rientjes@google.com> wrote:
> On Sat, 18 Jun 2011, Américo Wang wrote:
>
>>
>> This is a revert of
>>
>> commit 2584e517320bd48dc8d20e38a2621a2dbe58fade
>> Author: Ravikiran G Thirumalai <kiran@scalex86.org>
>> Date:   Tue Mar 31 15:21:26 2009 -0700
>>
>>     mm: reintroduce and deprecate rlimit based access for SHM_HUGETLB
>>
>>
>> because it is deprecated and scheduled to be removed.
>>
>
> I know this is scheduled for removal and it is quite past due, but I think
> we need to do some due diligence before just yanking the whole thing out.
> A printk_once() about some mysterious application using SHM_HUGETLB
> doesn't seem very helpful in migrating users to start using
> /proc/sys/vm/hugetlb_shm_group, and suddenly returning -EPERM when
> attempting it doesn't seem very responsible, despite what
> Documentation/feature-removal-schedule.txt may say.
>
> For context, we just ran into this internally where this warning at one
> point appeared to be WARN_ON_ONCE().  That seems more attention grabbing
> because it at least allows users to start understanding what the issue is
> and who needs to be fixed.

Well, we put printk_once with KERN_WARNING level, this is already an enough
warning, the only difference with WARN_ON_ONCE() is this has no backtrace
which is not important for this case.

Thanks.
