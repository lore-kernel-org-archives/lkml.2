Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196Ab2CJXpt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 18:45:49 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45060 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749Ab2CJXps convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 18:45:48 -0500
MIME-Version: 1.0
In-Reply-To: <CAKaWdxa8yJJhnPj1th6GdYvn9+Lu7GUV1e=960gMQOdc8W47dQ@mail.gmail.com>
References: <CAKaWdxZGg-Xpw2E85bAr8BVgWtXxEitwsir=yXp5qS0FMUk1uQ@mail.gmail.com>
	<m1ehtd8qez.fsf@fess.ebiederm.org>
	<CAKaWdxbuwV6yQnX=4zcBZncL8f+7cXPFwx8ejw=6d=dX8NoZsw@mail.gmail.com>
	<87obshxt4w.fsf@xmission.com>
	<CAKaWdxa326eP47=nENh8_1NmRCadTB=o8jyWO2dAzZcn9yCwiA@mail.gmail.com>
	<87zkc1w6wp.fsf@xmission.com>
	<CAKaWdxa8yJJhnPj1th6GdYvn9+Lu7GUV1e=960gMQOdc8W47dQ@mail.gmail.com>
Date: Sun, 11 Mar 2012 12:45:48 +1300
Message-ID: <CAKaWdxaaKMiwnhP7R786mqHTPs+o=izerZDbUgPBaxyU+XL-2g@mail.gmail.com>
Subject: Re: Hang on "echo b > /proc/sysrq-trigger"
From: Keith Chew <keith.chew@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric

Keep a quick update...

>> I would check with your BIOS folks and perhaps play with the kernel
>> option.  The most reliable way to peform a reset is to trigger a board
>> reset by writing to 0xcf9 or a similar register.  I expect your BIOS
>> does that and you can probably get the kernel to do that.  I would
>> definitely test to see if you can write to the mostly standard
>> 0xcf9 register directly from the kernel and trigger a reset directly.
>>

Thank you very much for this. We have tried with reboot=p, which is
writing to the 0xCF9 register directly, and the test has been running
good for the past 9 days. Will keep monitoring it.

Also, I have also added a delay in the KBD reboot, which appears to
have made the reboot reliable (running good for past 8 days, before it
would hang after 2 days):
-----------------------
kb_wait();
udelay(150); <------ Increased from 50
outb(0xfe, 0x64); /* pulse reset low */
udelay(50);
-----------------------

Looks like the code may be issuing the reboot a bit too early after
returning from kb_wait().

Regards
Keith
