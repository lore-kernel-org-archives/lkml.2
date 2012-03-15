Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965206Ab2COOw2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 10:52:28 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:55720 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964859Ab2COOw0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 10:52:26 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1203151503530.2466@ionos>
References: <CA+1xoqcGcfYzjrvRU-z=mUSq+wgqfBqdM51shV5gk4ohfe5Wng@mail.gmail.com>
 <CA+1xoqdeuorMi+=EZLpyrBN9L+J2o4SF-8meY=5Qypze9XrpiQ@mail.gmail.com> <alpine.LFD.2.02.1203151503530.2466@ionos>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Thu, 15 Mar 2012 16:52:04 +0200
Message-ID: <CA+1xoqfeDE5NEgGtxEWbU6uYaVgPfTWvBQ1pjcuf0piy_GGbqA@mail.gmail.com>
Subject: Re: ntp: BUG: spinlock lockup on CPU#1
To: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>, Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2012 at 4:04 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Thu, 15 Mar 2012, Sasha Levin wrote:
>
>> On Thu, Mar 15, 2012 at 3:23 PM, Sasha Levin <levinsasha928@gmail.com> wrote:
>> > Hi all,
>> >
>> > I was doing some more fuzzing with trinity in a KVM tools guest, using
>> > today's linux-next, when I've experienced a complete system lockup
>> > (just in the guest ofcourse). After a bit I got the spew at the bottom
>> > of this mail.
>> >
>> > From what I can tell from the logs, there were several threads waiting
>> > on syscall results, and I suspect that the adjtimex() call on CPU3 is
>> > somehow responsible for this lockup.
>>
>> Oh, and I'm not sure if it's related or not, but I've started seeing
>> the following spew every time I start fuzzing:
>>
>> [   47.105987] ------------[ cut here ]------------
>> [   47.106021] WARNING: at kernel/time/clockevents.c:209
>
> It's unrelated, but I'm mighty curious how you manage that.

>From what I gather from the logs it's the result of adjtimex() being
called while a different CPU is in the middle of a syscall. It happens
quite often really, so I can get that warning to jump out pretty
easily.
