Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752028Ab1JMURb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 16:17:31 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:44453 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593Ab1JMUR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 16:17:29 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1110131606030.2026-100000@iolanthe.rowland.org>
References: <CA+O4pCL2NmTgW2vDU=jdhyy1_PpuP3g9SVup=iwEOVGoGzHmUA@mail.gmail.com>
	<Pine.LNX.4.44L0.1110131606030.2026-100000@iolanthe.rowland.org>
Date: Thu, 13 Oct 2011 22:17:28 +0200
Message-ID: <CA+O4pC+AnDjZ3x2BRA83b6Wf7rWo0g2Xa7+WfPtRJr9aJCZvuw@mail.gmail.com>
Subject: Re: [Patch] Increase USBFS Bulk Transfer size
From: Markus Rechberger <mrechberger@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Chris Friesen <chris.friesen@genband.com>, Greg KH <gregkh@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 13, 2011 at 10:07 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Thu, 13 Oct 2011, Markus Rechberger wrote:
>
>> fair enough I have 2 devices which don't work properly with bulk.
>> Device A works by adjusting a hardware register
>> Device B is documented in this thread.
>>
>> Device A causes corruptions when the hardwareregister is set to a
>> buffersize > 16k.
>> There is certainly something on the physical usb layer which is unknown to the
>> (software) USB experts here.
>> The logfiles in the previous email shows up enough and is clear enough.
>
> When you ran the test using the 12288/11776 sizes, did you change the
> hardware register buffersize value?

sorry for confusing you here, this device does not have such a register.

Device A has the hardware register, the buffer is currently set to
~16kb for it and it is okay, it does not
require the patch. By increasing the hw register to >16kb the transfer
is also damaged.

Device B unfortunately not and only accepts 24064 bytes, before
getting that constant I tried
several other smaller buffer sizes and it did not succeed (result is
just as indicated by the video and logfiles in the earlier
post). CPU usage is also okay 0.9% for the entire streaming application.

Markus

> Or did you leave it set to the same 24064 as in the other test?
>
> Alan Stern
>
>
