Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751855Ab2KQMwj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 07:52:39 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:36196 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778Ab2KQMwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 07:52:38 -0500
MIME-Version: 1.0
In-Reply-To: <20121115224030.GA16377@kroah.com>
References: <1353007337-12791-1-git-send-email-const@MakeLinux.com>
	<20121115224030.GA16377@kroah.com>
Date: Sat, 17 Nov 2012 14:52:37 +0200
X-Google-Sender-Auth: _XF-zN8mXAKTCBL7lzqGbpitMM4
Message-ID: <CAE7jHC8tAEXSXXdZFSCo=iAtSUyYpm45KFsTYNcn3Lcgn7YAcg@mail.gmail.com>
Subject: Re: [PATCH v2] LDT - Linux Driver Template
From: Constantine Shulyupin <const@makelinux.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2012 at 12:40 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Thu, Nov 15, 2012 at 09:22:17PM +0200, Constantine Shulyupin wrote:
>> From: Constantine Shulyupin <const@MakeLinux.com>
>>
>> LDT is useful for Linux driver development beginners,
>> hackers and as starting point for a new drivers.
>
> Really?  I strongly doubt it.  The odds that a new driver needs to use a
> misc device is quite low these days.  Normally you just start with a
> driver for a device like the one you need to write and modify it from
> there.  The days when people write char device drivers are pretty much
> over now.

In a recent letter you have discouraged to use of class_create and
recommended to use misc interface:

On Wed, Nov 14, 2012 at 1:32 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> Now I agree using the char interface isn't the most "obvious" and I have
> a set of ideas/half-baked patches floating around that aim to clean it
> up, but for now, I'd recommend just using the misc interface, it's
> worlds simpler, makes sense, and handles all of the struct device work
> for you automatically.

That is exact what I think too.

>> The driver uses following Linux facilities: module, platform driver,
>> file operations (read/write, mmap, ioctl, blocking and nonblocking mode, polling),
>> kfifo, completion, interrupt, tasklet, work, kthread, timer, single misc device,
>> Device Model, configfs, UART 0x3f8,
>> HW loopback, SW loopback, ftracer.
>
> That's a whole lot of different things all mushed together here.  If you
> _really_ want to make something useful, you would do individual drivers
> for each of these different things, not something all tied together in a
> way that no one is ever going to use.

Yes, LDT uses many of Linux facilities, which are used in different drivers.
An advantage ot LDT is integration this facilities.
It is easy to remove unused parts of LDT for tailoring it to specific
requirement.

Any way, I'll be glad to make a sample driver accordingly your specification.
May be it is just need to remove some facilities and simplify LDT.


>> + *   Power Management (dev_pm_ops)
>> + *   Device Tree (of_device_id)
>
> Again, that's a lot of non-related things all together in one piece,
> making it hard to understand, and review, which does not lend itself to
> being a good example for anything.

Indeed, it is a challenge to make it complete, simple and useful.
Many reviewers are suggesting different ideas.
For example:

On Sun, Oct 7, 2012 at 3:18 PM, Jean-Christophe PLAGNIOL-VILLARD
<plagnioj@jcrosoft.com> wrote:
> They are not a "good practice example" as you miss too many point about
> drivers such as PM, Runtime-PM, Devicetree etc...

I am still weighting what to include and to exclude from LDT to
approach it to "good practice example".

> Also, you didn't run this through checkpatch.pl, like was requested.
I do it each time. I just allow to to some lines be few longer than 80
symbols,  accordingly
your presentation  "Write and Submit your first Linux kernel Patch"
https://www.youtube.com/watch?v=LLBrBBImJt4 on 10:00.

>
>> +#define trace_ioctl(nr) pr_debug("ioctl=(%c%c %c #%i %i)\n", \
>> +     (_IOC_READ & _IOC_DIR(nr)) ? 'r' : ' ', \
>> +     (_IOC_WRITE & _IOC_DIR(nr)) ? 'w' : ' ', \
>> +     _IOC_TYPE(nr), _IOC_NR(nr), _IOC_SIZE(nr))
>
> That's just horrid :(
>
>> +static long ldt_ioctl(struct file *f, unsigned int cmnd, unsigned long arg)
>
> No, no new ioctls, don't even think about it, sorry.

Do you mean that new drivers should not provide ioclt interface?
What should be used instead?

>> +tracing()
>> +{
>> +     sudo sh -c "cd $tracing; $1" || true
>> +}
>
> sudo?  Why?
script ldt-test is intended to run from user, but ftrace and insmod
require root access.

> What is the goal of this script in the first place?

The goal of ldt-test script is to validate LDT driver.

Thank you very much!

-- 
Constantine Shulyupin
http://www.MakeLinux.com/
Embedded Linux Systems,
Device Drivers, TI DaVinci
