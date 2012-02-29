Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965984Ab2B2Xep (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 18:34:45 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:48656 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965013Ab2B2Xem convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 18:34:42 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Keith Chew <keith.chew@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
References: <CAKaWdxZGg-Xpw2E85bAr8BVgWtXxEitwsir=yXp5qS0FMUk1uQ@mail.gmail.com>
	<m1ehtd8qez.fsf@fess.ebiederm.org>
	<CAKaWdxbuwV6yQnX=4zcBZncL8f+7cXPFwx8ejw=6d=dX8NoZsw@mail.gmail.com>
	<87obshxt4w.fsf@xmission.com>
	<CAKaWdxa326eP47=nENh8_1NmRCadTB=o8jyWO2dAzZcn9yCwiA@mail.gmail.com>
Date: Wed, 29 Feb 2012 15:34:30 -0800
In-Reply-To: <CAKaWdxa326eP47=nENh8_1NmRCadTB=o8jyWO2dAzZcn9yCwiA@mail.gmail.com>
	(Keith Chew's message of "Thu, 1 Mar 2012 11:06:53 +1300")
Message-ID: <87zkc1w6wp.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+kJsGhxwx4vbguUTPAGH4w/vQWjZ7HvUw=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0001]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      []
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: ; 
X-Spam-Combo: ;Keith Chew <keith.chew@gmail.com>
X-Spam-Relay-Country: **
Subject: Re: Hang on "echo b > /proc/sysrq-trigger"
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keith Chew <keith.chew@gmail.com> writes:

> Hi Eric
>
>>
>> Historically a lot of issues have had to do with which cpu you are
>> entering the bios from.  So you might try pinning your process
>> to differen cpus and see if you can make the failure more deterministic.
>>
>
> We are using a Celeron 575 uniprocessor, so we do not have the option
> to pin on another cpu. I have tried compiling the kernel in both UP
> and SMP configuration, but sadly both causes the hang.

Ok.  That rules out a bunch of things, and emerengy_restart may not
be much different in practice.

>> Ugh.  The other possibility is that there is an intermittent failure in
>> the hardware, that prevents the boot/reboot.  Wrong values on pull-up
>> resistors have been known to cause that kind of thing.
>>
>
> Thank you very much for this pointer, will feed that back to the
> manufacturer and see if it will give them some clues. The original
> purpose for this reboot exercise was to ensure the software will
> handle a power failure without any OS/data corruptions. With this new
> discovery of unreliable reboot, the next worry is "If reboot is not
> reliable, is the boot process also susceptible to the same issue?". I
> have not rigged up any hardware to simulate a periodic full shutdown
> and boot up process, but will be planning to set this up next.
>
> Thanks again, if you have any other suggestions for us to try, I am
> all ears!

I would check with your BIOS folks and perhaps play with the kernel
option.  The most reliable way to peform a reset is to trigger a board
reset by writing to 0xcf9 or a similar register.  I expect your BIOS
does that and you can probably get the kernel to do that.  I would
definitely test to see if you can write to the mostly standard
0xcf9 register directly from the kernel and trigger a reset directly.

Once past a reset and with a single cpu all of the failures will be
happening in the boot path.  So the only possible points of failure
are in devices that are different between a soft reset and a power on
reset.

I would check to see if your board perhaps supports post codes or any
other debugging that will let you see where you are hanging.

It sounds like there is some very rare failure, that is going to be
a challenge to track down.  I would definitely test more than one
motherboard to ensure that you can reproduce the problem on more
than one piece of hardware.  Sometimes hardware is just broken.

Eric
