Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798Ab0INIIJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 04:08:09 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:37477 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965Ab0INIIF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 04:08:05 -0400
MIME-Version: 1.0
In-Reply-To: <4C8F2699.3020509@kernel.org>
References: <1284284969.2928.18.camel@maxim-laptop> <1284427621.4127.7.camel@maxim-laptop>
 <4C8F2699.3020509@kernel.org>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Tue, 14 Sep 2010 10:07:49 +0200
Message-ID: <AANLkTinGHB9fbLw1Cm5wvPLGy8QEuoBBmFiqpnvXiZ8R@mail.gmail.com>
Subject: Re: [REGRESSION] cdrom drive doesn't detect removal
To: Tejun Heo <tj@kernel.org>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 14, 2010 at 09:39, Tejun Heo <tj@kernel.org> wrote:
> On 09/14/2010 03:27 AM, Maxim Levitsky wrote:
>>> However 2.6.36 doesn't detect that removal.
>>> According to udevadm monitor --property no uevents are send on removal.
>> Correction, this is regression between 2.6.34 and 2.6.35. This shows how
>> much I use cd these days...
>>
>> I bisected it down to this:
>>
>> 6b4517a7913a09d3259bb1d21c9cb300f12294bd is the first bad commit
>> commit 6b4517a7913a09d3259bb1d21c9cb300f12294bd
>> Author: Tejun Heo <tj@kernel.org>
>> Date:   Wed Apr 7 18:53:59 2010 +0900
>>
>>     block: implement bd_claiming and claiming block
>
> Hmmm... weird.  This commit does change the open behavior but
> shouldn't change the end result.  Can someone please enlighten me how
> udevadm is interacting with the device at system call level?

Not at all. Udev does not really touch it.

The cdrom drive isn't unlocked on usual systems, udisks polls the
cdrom drive periodically just like HAL did. The only difference is
that with the polling, the sr driver detects a media change and sends
a uevent to udev, instead of HAL looking at the result of the open().

Are we sure, that there is something that still polls the drive?
Udisks is only auto-started, when the desktop calls into some D-Bus
methods, unlike HAL where it was an init script.

Kay
