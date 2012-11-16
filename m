Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751365Ab2KPK1f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 05:27:35 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:33005 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001Ab2KPK1e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 05:27:34 -0500
MIME-Version: 1.0
In-Reply-To: <87zk2hubh1.fsf@nemi.mork.no>
References: <1353007337-12791-1-git-send-email-const@MakeLinux.com>
	<20121115224030.GA16377@kroah.com>
	<87zk2hubh1.fsf@nemi.mork.no>
Date: Fri, 16 Nov 2012 12:27:33 +0200
X-Google-Sender-Auth: KzeLsGJmKFSkUZq5fNkfBrRealI
Message-ID: <CAE7jHC817W77-Dgk7MJ2s7RVnxRGbO6oaSvqge75OCMo-8haFg@mail.gmail.com>
Subject: Re: [PATCH v2] LDT - Linux Driver Template
From: Constantine Shulyupin <const@makelinux.com>
To: =?ISO-8859-1?Q?Bj=F8rn_Mork?= <bjorn@mork.no>
Cc: linux-kernel@vger.kernel.org, celinux-dev@lists.celinuxforum.org,
        selimtemur@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2012 at 11:46 AM, Bjørn Mork <bjorn@mork.no> wrote:
> Greg KH <gregkh@linuxfoundation.org> writes:
>
>>  Normally you just start with a
>> driver for a device like the one you need to write and modify it from
>> there.
>
> Yes.
>
> Even if the template driver is fixed up to be the most beautiful driver
> ever made, it will still always be made for non-existing hardware.  This
> causes two major problems:
>  - the driver will not be tested, so it will have bugs
>  - the driver will not be used by anyone, so it will not be maintained
>    (remember that it is initially perfect, so there is no reason to
>    change it)
Thanks. I seems you have missed.
The main advantage of LDT - is working driver with real HW and simple
test suite.
It implements trivial UART driver just to write to port, receive real
HW interrupt
and read data from port. (You can to suggest to use any another HW).
Without available UART, LDT emulates loopback in SW for testing.
Memory buffers are used for mmap and ioctl operations.
LDT test script ldt-test and test utility dio.c configures the driver
for loopback mode, passes data to the driver, receives back and
compares with input and gives result of comparison.
To perform validation tests, regression tests need simply to run test script.
Detailed kernel log and ftrace log during the test are saved for analysts.

> May I suggest another approach?  How about selecting a set of existing
> drivers which are suitable as templates, and put all this effort into
> making those drivers *the* perfect examples instead? Start submitting
> cleanup patches for the selected drivers until everyone is satisfied and
> then document them as starting points for anyone wanting to write a
> similar driver.
Thank you. Possible too. Can you or somebody else recommend such drivers?

>
> I believe many subsystem maintainers already have such sample drivers
> which they point new submitters to when asked.  That does not mean that
> these drivers necessarily are perfect, so there is still work to do here
> for anyone interested.  And collecting this information and documenting
> it would be useful in itself.
Thanks. I already research omap panda platform for improvement opportunities.

Thank you.
