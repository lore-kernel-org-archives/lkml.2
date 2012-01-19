Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753857Ab2ASA6a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 19:58:30 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:36588 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659Ab2ASA62 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 19:58:28 -0500
MIME-Version: 1.0
In-Reply-To: <201201190108.32794.rjw@sisk.pl>
References: <1326826563-32215-1-git-send-email-sjg@chromium.org>
	<20120118041720.GA2431@linux.vnet.ibm.com>
	<CAPnjgZ1GJatR15dVsq-+hAWhD7eaLhtN737QvBaor_=0+K+6wA@mail.gmail.com>
	<201201190108.32794.rjw@sisk.pl>
Date: Wed, 18 Jan 2012 16:58:27 -0800
X-Google-Sender-Auth: iP92bC3Wk4IfSRQyqM90mUr5NiA
Message-ID: <CAPnjgZ0tF4eaK7yrPf6QEOHtGz+CcZaM1q0ToV3QWu-mRD_QhA@mail.gmail.com>
Subject: Re: [PATCH 3/3] serial: 8250: Add a wakeup_capable module param
From: Simon Glass <sjg@chromium.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: paulmck@linux.vnet.ibm.com, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-serial@vger.kernel.org
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

On Wed, Jan 18, 2012 at 4:08 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Wednesday, January 18, 2012, Simon Glass wrote:
>> [+cc Rafael J. Wysocki <rjw@sisk.pl> who I think wrote the wakeup.c code]
>>
>> Hi Alan, Paul,
>>
>> On Tue, Jan 17, 2012 at 8:17 PM, Paul E. McKenney
>> <paulmck@linux.vnet.ibm.com> wrote:
>> > On Tue, Jan 17, 2012 at 08:10:36PM +0000, Alan Cox wrote:
>> >> On Tue, 17 Jan 2012 10:56:03 -0800
>> >> Simon Glass <sjg@chromium.org> wrote:
>> >>
>> >> > Since serial_core now does not make serial ports wake-up capable by
>> >> > default, add a parameter to support this feature in the 8250 UART.
>> >> > This is the only UART where I think this feature is useful.
>> >>
>> >> NAK
>> >>
>> >> Things should just work for users. Magic parameters is not an
>> >> improvement. If its a performance problem someone needs to fix the rcu
>> >> sync overhead or stop using rcu on that path.
>>
>> OK fair enough, I agree. Every level I move down the source tree
>> affects more people though.
>>
>> >
>> > I must say that I lack context here, even after looking at the patch,
>> > but the synchronize_rcu_expedited() primitives can be used if the latency
>> > of synchronize_rcu() is too large.
>> >
>>
>> Let me provide a bit of context. The serial_core code seems to be the
>> only place in the kernel that does this:
>>
>>               device_init_wakeup(tty_dev, 1);
>>               device_set_wakeup_enable(tty_dev, 0);
>
> It shouldn't do that.
>
> It should just do device_set_wakeup_capable(tty_dev, true) instead.

Ok, that makes sense - thank you for clearing it up. I will do a new patch.

Regards
Simon

>
> Thanks,
> Rafael
