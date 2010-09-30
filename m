Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755634Ab0I3X3M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 19:29:12 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:59571 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754970Ab0I3X3I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 19:29:08 -0400
MIME-Version: 1.0
X-Originating-IP: [98.248.182.159]
In-Reply-To: <201009301337.55511.arnd@arndb.de>
References: <AANLkTik8auzhRB00fRWxbmZKOKg+T87ZZa07ydDAGp=f@mail.gmail.com>
	<20100930100405.GB5265@cr0.nay.redhat.com>
	<201009301337.55511.arnd@arndb.de>
Date: Thu, 30 Sep 2010 16:29:06 -0700
Message-ID: <AANLkTimHsih_s+ETtq7YHSj7zvAx-DjipOHXvZfWOdXR@mail.gmail.com>
Subject: Re: interpreting semantics of ipc system call
From: Andreas Saebjoernsen <andreas@digitalplaywright.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you! I am now implementing support for this system call. Looking at the
data structures that the 'void*' can represent it will probably take a
some time,
but the semantics is clear.

kind regards,
Andreas

On Thu, Sep 30, 2010 at 4:37 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Thursday 30 September 2010, Américo Wang wrote:
>> On Wed, Sep 29, 2010 at 03:03:11PM -0700, Andreas Saebjoernsen wrote:
>> >We are developing a simulator that can simulate any specimen x86 linux program.
>> >Our simulator has a simulated memory, unlike the concrete memory state of
>> >tools like Valgrind, so that we can do concrete symbolic execution. Instead of
>> >reimplementing the system calls we marshal the system calls called by
>> >the specimen.
>> >
>> >I am currently working on marshaling calls to the ipc system call (system
>> >call 117) which has the following signature
>> >
>> >int ipc(unsigned int call, int first, int second, int third, void
>> >*ptr, long fifth)
>> >
>> >I have a problem interpreting what the size is of the data structure
>> >pointed to by
>> >the 'void*', and I have been unable to locate good documentation or code on the
>> >semantics of this system call.
>>
>>
>> Take a look at ipc/syscall.c, that pointer will be interpreted to different
>> data structures when you pass different arguments to 'call'.
>
> Right. Note that you can ignore the version field for all practical
> purposes and consider it constant.
>
>        Arnd
>
