Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801Ab1DCRdU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Apr 2011 13:33:20 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37806 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752406Ab1DCRdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Apr 2011 13:33:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=ginkel.com; s=google;
        h=mime-version:x-originating-ip:in-reply-to:references:from:date
         :message-id:subject:to:cc:content-type;
        b=TuPZ+QQSMsYLP57yMP1REXaeUx7LFMbJh9zI3gMKO9aX8Dl6/vpxXkrfTqvuP4F7N2
         dIQ/RRdOqBi1dIkHTh2HrjCo7XnzXo1dIDrRX+13vqbxhPy9/IS5WDoCTQPR3kiMbocD
         p2071pleB3O6FURQHcUPDNmF5Sb3oLOf1pTM8=
MIME-Version: 1.0
X-Originating-IP: [91.17.155.41]
In-Reply-To: <1301811515.7592.2.camel@marge.simson.net>
References: <AANLkTim5ctAoaB4+BS7Z-+ARUgTEBO22bkYMUvFtGmoN@mail.gmail.com> <1301811515.7592.2.camel@marge.simson.net>
From: Thilo-Alexander Ginkel <thilo@ginkel.com>
Date: Sun, 3 Apr 2011 19:32:48 +0200
Message-ID: <AANLkTimeRFN_5ZFwjtY6+yo0V=VAoX8T_Ju+ceDJnfHv@mail.gmail.com>
Subject: Re: Soft lockup during suspend since ~2.6.36
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 3, 2011 at 08:18, Mike Galbraith <efault@gmx.de> wrote:
> Adds CC to author of fingered commit.
>
> On Sun, 2011-04-03 at 04:03 +0200, Thilo-Alexander Ginkel wrote:
>> recently, I upgraded my Linux kernel (running on an Intel Core 2 Quad)
>> from 2.6.35 to 2.6.38. Unfortunately, I have been experiencing
>> frequent (but sporadic) freezes during suspend (S3) since then, i.e.,
>> the system became completely unresponsive (even MagicSysRq stopped
>> working) after having spun down the hard disks.
>>
>> I performed a bisect, which pointed out the following commit:
>>
>> bd25f4dd6972755579d0ea50d1a5ace2e9b00d1a is the first bad commit
>> commit bd25f4dd6972755579d0ea50d1a5ace2e9b00d1a

A good night of sleep and some Googling later I am under the
impression that this issue was already supposedly fixed by the
following commit a long time ago:
  http://git.kernel.org/?p=linux/kernel/git/jikos/hid.git;a=commitdiff;h=9c9e54a8df0be48aa359744f412377cc55c3b7d2
  http://permalink.gmane.org/gmane.linux.kernel/1024386

This makes some sense as versions closer to 2.6.36 only lock up
sporadically whereas the original bug locks up reliably. I'll try to
get a backtrace for the sporadic bug, but may only be able to do so
using a tainted kernel as my text console does not survive
suspend/resume without proprietary drivers (and the serial console
also breaks during the relevant suspend phase). I hope, this is
acceptable.

Thanks,
Thilo
