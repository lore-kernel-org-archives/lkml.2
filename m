Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993Ab0KBQFD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 12:05:03 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38756 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111Ab0KBQE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 12:04:58 -0400
MIME-Version: 1.0
X-Originating-IP: [66.187.233.202]
In-Reply-To: <201010311518.42998.dmitry.torokhov@gmail.com>
References: <tkrat.980deadea593e9ed@s5r6.in-berlin.de>
	<201010311518.42998.dmitry.torokhov@gmail.com>
Date: Tue, 2 Nov 2010 12:04:56 -0400
Message-ID: <AANLkTi=AGWGv2WPuGQ4bF7N4TSAbU5YMjry9beXyvspk@mail.gmail.com>
Subject: Re: drivers/media/IR/ir-keytable.c::ir_getkeycode - 'retval' may be
 used uninitialized
From: Jarod Wilson <jarod@wilsonet.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        mchehab@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 31, 2010 at 6:18 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> On Sunday, October 31, 2010 10:51:21 am Stefan Richter wrote:
>> Commit 9f470095068e "Input: media/IR - switch to using new keycode
>> interface" added the following build warning:
>>
>> drivers/media/IR/ir-keytable.c: In function 'ir_getkeycode':
>> drivers/media/IR/ir-keytable.c:363: warning: 'retval' may be used uninitialized in this function
>>
>> It is due to an actual bug but I don't know the fix.
>>
>
> The patch below should fix it. I wonder if Linus released -rc1 yet...

Looks like it missed rc1.

> Input: ir-keytable - fix uninitialized variable warning
>
> From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
>
> We were forgetting to set up proper return value in success path causing
> ir_getkeycode() to fail intermittently:
>
> drivers/media/IR/ir-keytable.c: In function 'ir_getkeycode':
> drivers/media/IR/ir-keytable.c:363: warning: 'retval' may be used
> uninitialized in this function
>
> Reported-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
> Signed-off-by: Dmitry Torokhov <dtor@mail.ru>

Acked-by: Jarod Wilson <jarod@redhat.com>


-- 
Jarod Wilson
jarod@wilsonet.com
