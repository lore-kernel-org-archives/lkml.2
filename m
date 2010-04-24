Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756844Ab0DXDUu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 23:20:50 -0400
Received: from mail-iw0-f197.google.com ([209.85.223.197]:47600 "EHLO
	mail-iw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756341Ab0DXDUs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 23:20:48 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1004231242460.1777-100000@iolanthe.rowland.org>
References: <20100423084349.GC1573@ucw.cz>
	 <Pine.LNX.4.44L0.1004231242460.1777-100000@iolanthe.rowland.org>
Date: Fri, 23 Apr 2010 20:20:47 -0700
Message-ID: <i2zd6200be21004232020t46f4de0ct93b94e2bd67a6e76@mail.gmail.com>
Subject: Re: [linux-pm] [PATCH 2/9] PM: suspend_block: Add driver to access 
	suspend blockers from user-space
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>,
       linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Magnus Damm <damm@igel.co.jp>,
       linux-pm@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 23, 2010 at 9:43 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Fri, 23 Apr 2010, Pavel Machek wrote:
>
>> Hi!
>>
>> > Add a misc device, "suspend_blocker", that allows user-space processes
>> > to block auto suspend. The device has ioctls to create a suspend_blocker,
>> > and to block and unblock suspend. To delete the suspend_blocker, close
>> > the device.
>> >
>> > Signed-off-by: Arve Hj??nnev??g <arve@android.com>
>>
>> > --- a/Documentation/power/suspend-blockers.txt
>> > +++ b/Documentation/power/suspend-blockers.txt
>> > @@ -95,3 +95,20 @@ if (list_empty(&state->pending_work))
>> >  else
>> >     suspend_block(&state->suspend_blocker);
>> >
>> > +User-space API
>> > +==============
>> > +
>> > +To create a suspend_blocker from user-space, open the suspend_blocker device:
>> > +    fd = open("/dev/suspend_blocker", O_RDWR | O_CLOEXEC);
>> > +then call:
>> > +    ioctl(fd, SUSPEND_BLOCKER_IOCTL_INIT(strlen(name)), name);
>>
>>
>> This seems like very wrong idea -- it uses different ioctl number for
>> each length AFAICT.
>
> How about specifying the name by an ordinary write() call instead of
> by an ioctl()?
>

I prefer using ioctls. We have three operations at the moment. Init,
block and unblock. If we do init with write but block and unblock
using ioctls, it would be pretty strange. Specifying a command and
argument in a string to write is more complicated to parse than using
ioctls. Or did you have something else in mind?

-- 
Arve Hjønnevåg
