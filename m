Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755661Ab2BACSN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 21:18:13 -0500
Received: from exprod5og105.obsmtp.com ([64.18.0.180]:43485 "EHLO
	exprod5og105.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753237Ab2BACSL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 21:18:11 -0500
MIME-Version: 1.0
In-Reply-To: <20120131154748.GA5650@redhat.com>
References: <CAOwKts8zS1rYA+Y4k-vb8YAaR=aFd1BwryhhWWnWLQyrYrNqyA@mail.gmail.com>
	<20120131154748.GA5650@redhat.com>
Date: Wed, 1 Feb 2012 10:18:09 +0800
Message-ID: <CAOwKts_dTvc4LiCZUXN9oYzty1pkDEn_VQwPKY=EoVzk0n6tFA@mail.gmail.com>
Subject: Re: In many cases softlockup can not be reported after disabling IRQ
 for long time
From: TAO HU <tghk48@motorola.com>
To: Don Zickus <dzickus@redhat.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        linux-arm-kernel@lists.infradead.org,
        linux-omap <linux-omap@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Don

Thanks for your feedback!

Unfortunately, the hardlockup depends on NMI which is not available on
ARM (Cortex-A9) per my understanding.
Our system uses OMAP4430. Any more suggestions?

On Tue, Jan 31, 2012 at 11:47 PM, Don Zickus <dzickus@redhat.com> wrote:
> On Tue, Jan 31, 2012 at 03:28:09PM +0800, TAO HU wrote:
>> Resend with a new subject
>>
>> On Wed, Jan 25, 2012 at 4:24 PM, TAO HU <tghk48@motorola.com> wrote:
>> > Hi, All
>> >
>> > While playing kernel 3.0.8 with below test code, it does NOT report
>> > any softlockup with 60%~70% chances.
>> > NOTE: the softlockup timeout is set to 10 seconds (i.e.
>> > watchdog_thresh=5) in my test.
>> > ... ...
>> > preempt_disable();
>> > local_irq_disable();
>> > for (i = 0; i < 20; i++)
>> >       mdelay(1000);
>> > local_irq_enable();
>> > preempt_enable();
>> > ... ...
>> >
>> > However, if I remove local_irq_disable()/local_irq_enable() it will
>> > report softlockup with no problem.
>> > I believe it is due to that after local_irq_enable()
>> > touch_softlockup_watchdog() is called prior softlockup timer.
>
> Hi Hu,
>
> Honestly, you should be getting hardlockup warnings if you are disabling
> interrupts.  Do you see anything in the console output?
>
> Cheers,
> Don



-- 
Best Regards
Hu Tao
