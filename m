Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417Ab0D0XWN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 19:22:13 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:56914 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753184Ab0D0XWM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 19:22:12 -0400
MIME-Version: 1.0
In-Reply-To: <201004280003.31668.rjw@sisk.pl>
References: <Pine.LNX.4.44L0.1004271432280.1850-100000@iolanthe.rowland.org>
	 <201004280003.31668.rjw@sisk.pl>
Date: Tue, 27 Apr 2010 16:22:11 -0700
Message-ID: <t2sd6200be21004271622k3e102381i7d766c3635d71a6a@mail.gmail.com>
Subject: Re: [linux-pm] [PATCH 2/9] PM: suspend_block: Add driver to access 
	suspend blockers from user-space
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>, Pavel Machek <pavel@ucw.cz>,
       Len Brown <len.brown@intel.com>, linux-doc@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Magnus Damm <damm@igel.co.jp>, linux-pm@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/4/27 Rafael J. Wysocki <rjw@sisk.pl>:
> On Tuesday 27 April 2010, Alan Stern wrote:
>> On Mon, 26 Apr 2010, Arve Hjønnevåg wrote:
>>
>> > > If you insist on using ioctl for init, you should use the standard
>> > > convention for passing variable-length data.  The userspace program
>> > > sets up a fixed-size buffer containing a pointer to the name and the
>> > > name's length, and it passes the buffer's address as the ioctl
>> > > argument.
>> >
>> > Are you sure that is the standard? I searched for ioctls with NAME in
>> > their name and only found one that passed the name that way. The rest
>> > used fixed length string buffers, or passed the buffersize to _IOC
>> > like I do. For instance, input.h has ioctls to read string and
>> > bitmasks where user space specify the buffer size as an argument to
>> > the ioctl macro. These pass data from the kernel to user space, but I
>> > don't passing a string length is any worse than passing a buffer size.
>>
>> You're right.  Okay, I withdraw my objection.
>
> In the meantime, though, I thought that the suspend blocker might be created
> by _open() if we found a way to automatically choose a name for it.  That'd be
> kind of logical, since it's later destroyed by _release().
>
> So, what about using the name of the process that opened the special device
> file (or that name with'0' appended, or generally with a number appended) as
> the suspend blocker name?
>

I prefer to let user space choose the name since we use more than one
suspend blocker in the same process.

-- 
Arve Hjønnevåg
