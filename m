Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756114Ab0EaIqR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 04:46:17 -0400
Received: from smtp.nokia.com ([192.100.105.134]:49502 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753491Ab0EaIqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 04:46:15 -0400
Message-ID: <4C037731.5030301@nokia.com>
Date: Mon, 31 May 2010 11:45:37 +0300
From: Adrian Hunter <adrian.hunter@nokia.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] mmc: add an ioctl for erasing
References: <4BF68EFC.70101@nokia.com> <20100521140714.GB15070@infradead.org>
In-Reply-To: <20100521140714.GB15070@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 31 May 2010 08:45:24.0126 (UTC) FILETIME=[9C3C63E0:01CB009D]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Fri, May 21, 2010 at 04:47:40PM +0300, Adrian Hunter wrote:
>>> From f3baf566eb33a22bf12a48e4cdc7c99611bde934 Mon Sep 17 00:00:00 2001
>> From: Adrian Hunter <adrian.hunter@nokia.com>
>> Date: Wed, 5 May 2010 14:07:55 +0300
>> Subject: [PATCH] mmc: add an ioctl for erasing
>>
>> As SD and MMC cards have a NAND core, they can support an erase
>> operation that is typically 10x to 100x faster than writing.
>>
>> In addition, eMMCv4.4 also offers:
>> 	o Secure Erase
>> 	o Trim
>> 	o Secure Trim
>>
>> The "secure" variants also ensure that any copies of the data
>> (for example remnants of garbage collection) are also erased.
>>
>> "Trim" is the same as "erase" except that individual sectors
>> can be erased instead of whole Erase Groups.
>>
>> The Erase Operation and its variants are not supported by
>> default and drivers must set MMC_CAP_ERASE.  This is because
>> the operation can take a long time and drivers that rely on
>> polling the status may perform very badly.  Also drivers
>> may need changes to support the very long erase timeouts.
> 
> Please don't add new device specific ioctls.  Just implement the
> block layer discard operation to make the discard ioctl work on MMC
> device.  We can talk about adding a secure erase variant of it then.

Sorry for the slow reply, I have been away.

Connecting erase to discard was rejected for performance reasons in 2008.
Refer:

	http://thread.gmane.org/gmane.linux.file-systems/25378/focus=25606


We may want to connect MMC trim to discard, but I suspect it might have the
same performance problems.

My requirement is to expose erase and secure erase to userspace.  The discard
operation is not appropriate and the discard ioctl is too limited.

I could shift the ioctls to the block layer?
