Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957Ab2KCPlk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 11:41:40 -0400
Received: from mail-ia0-f174.google.com ([209.85.210.174]:37483 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755404Ab2KCPli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 11:41:38 -0400
MIME-Version: 1.0
In-Reply-To: <1351943332.16850.25.camel@maggy.simpson.net>
References: <CAKKZj2Do+ViFbdmeA9y4qZ4Dd_CrW_wmVWc0_CB4BAAwO6SfJg@mail.gmail.com>
 <CAKKZj2Av0TN9MbYk=-2ZB_jxDnUCWfrN5tJNZ7azgSHyOrMzvg@mail.gmail.com>
 <1351942405.16850.23.camel@maggy.simpson.net> <1351943332.16850.25.camel@maggy.simpson.net>
From: Michal Zatloukal <myxal.mxl@gmail.com>
Date: Sat, 3 Nov 2012 16:40:57 +0100
Message-ID: <CAKKZj2D-jCkAbEKPX75OFYWrdSYxwh6fFBFy9UBDxy_XHHX3Gg@mail.gmail.com>
Subject: Re: Fwd: Nice processes prevent frequency increases - possible
 scheduler regression (known good in 2.6.35)
To: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 3, 2012 at 12:48 PM, Mike Galbraith <efault@gmx.de> wrote:
> On Sat, 2012-11-03 at 04:33 -0700, Mike Galbraith wrote:
>> On Fri, 2012-11-02 at 21:09 +0100, Michal Zatloukal wrote:
>>
>> > On the new kernel, the nice processes are never starved - even when
>> > starting a tab-laden chromium session, the processes for BOINC keep
>> > about 20% CPU each (that is normalized to all CPUs, ie 40% nice load
>> > on each core). The problem is, the governor now seems to consider the
>> > non-nice task unable to saturate the CPU, and the cores' frequencies
>> > are hovering between 1.0 and 1.8 GHz. The scheduler keeps scheduling
>> > the nice tasks, and the non-nice tasks are progressing much slower,
>> > caused by the lower CPU speed as well as less processing time
>> > allocated to them. HD video stutters often, and Chromium takes at
>> > least 2-3 times longer to fully load.
>>
>> Your nice 19 tasks receiving 'too much' CPU when there are other
>> runnable tasks around sounds like you have SCHED_AUTOGROUP enabled.
>
> (forgot to mention: if that's the case, you can add noautogroup to your
> kernel command line to turn it off if distro turned it on in .config)
>

Thanks, Ubuntu's kernel is indeed configured with that option enabled,
and passing "noautogroup" at grub restores the previous behaviour. I'm
back to happy days again :) BTW, isn't this the "magic 200-line patch"
I was reading about ~2 years ago?

MZ
