Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754129Ab0DVKvg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 06:51:36 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:62728 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753916Ab0DVKve convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 06:51:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=qARKeZGykogaeoOr+sRbVcMb2ij8q/sHhc5w/ZupHOdQ2opfTCzKTZW2wcDCarqik0
         yWlsmx47ehWtRTY/son1eoimm4IjHPJI5fA84AZHrvy/N06w42fwzDAYDuZ3QEWSD2s1
         zjUKkXObG0RIOXNyl6eTtgPsZV9qefB4nZVZ4=
MIME-Version: 1.0
In-Reply-To: <20100421112807.5eca9f9d@bike.lwn.net>
References: <l2u87a5b0801004210935wf6ca2991ua777c39c737391f8@mail.gmail.com>
	 <20100421112807.5eca9f9d@bike.lwn.net>
Date: Thu, 22 Apr 2010 11:51:33 +0100
Message-ID: <j2o87a5b0801004220351ze6948d6dn3d995122aff355b6@mail.gmail.com>
Subject: Re: Threaded irq handler question
From: Will Newton <will.newton@gmail.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 21, 2010 at 6:28 PM, Jonathan Corbet <corbet@lwn.net> wrote:
> On Wed, 21 Apr 2010 17:35:32 +0100
> Will Newton <will.newton@gmail.com> wrote:
>
>> My problem is that this structure does not work, because once I call
>> disable_irq_nosync() on the irq in the check handler the thread will
>> no longer run because the irq is disabled. However if I don't call
>> disable_irq_nosync() I will get endless irqs because the line is
>> level-triggered and will not be deasserted until the thread has run.
>
> Trying to disable IRQs at this level is the wrong approach.  You need to
> do enough in the primary interrupt handler to cause the hardware to
> stop interrupting in the first place; usually that's just a matter of
> some sort of acknowledgment.  Then the threaded handler can move data
> around in peace.

Unfortunately this device has no way of doing that - deasserting the
interrupt line involves doing i2c transactions which will likely sleep
so cannot be done in the check handler. This is quite a common problem
for i2c connected devices.
