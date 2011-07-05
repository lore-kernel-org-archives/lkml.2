Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340Ab1GEEnA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 00:43:00 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:59227 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753238Ab1GEEm7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 00:42:59 -0400
MIME-Version: 1.0
In-Reply-To: <20110704153224.GA17358@suse.de>
References: <1309702581-16863-1-git-send-email-akinobu.mita@gmail.com>
	<1309702581-16863-3-git-send-email-akinobu.mita@gmail.com>
	<20110703162329.GA28131@suse.de>
	<CAC5umyh_25z9LV=T86807ey8yZRGwmhsPG44OqZdtcR-3wzb4Q@mail.gmail.com>
	<20110704153224.GA17358@suse.de>
Date: Tue, 5 Jul 2011 13:42:58 +0900
Message-ID: <CAC5umygN0Wy35Rb3zvfnSJ-uuBa17BGrhyi0kzSEW=fiLNLq=w@mail.gmail.com>
Subject: Re: [PATCH 2/7] debugfs: add debugfs_create_int
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/7/5 Greg KH <gregkh@suse.de>:
> On Mon, Jul 04, 2011 at 02:31:25PM +0900, Akinobu Mita wrote:
>> 2011/7/4 Greg KH <gregkh@suse.de>:
>> > On Sun, Jul 03, 2011 at 11:16:16PM +0900, Akinobu Mita wrote:
>> >> Introduce debugfs_create_int() for creating a debugfs file that is used to
>> >> read and write an int value.
>> >
>> > Um, what's wrong with the existing s32 and s64 versions that debugfs
>> > already provides?
>>
>> I couldn't find s32 version in linux/debugfs.h
>>
>> > userspace doesn't know what "int" means for the kernel as it might be
>> > running in 32bit mode with a 64bit kernel.  That is why this isn't a
>> > good idea, so please convert your other patch to use the existing api
>> > and change the variable type in your patch.
>>
>> Shoud I add debugfs_create_s32() instead of debugfs_create_int() for
>> this?
>
> Does it have to be a signed value?  If not, just use the
> debugfs_create_u32() function.  Or use that and just cast the result,
> right?

The debugfs file that I want to use needs to contain an error code
like -ENOMEM.

Now I realized that I should create a custom simple attribute that
is only allowed to store a valid errno (-MAX_ERRNO <= errno <= 0).

So I don't add new function like debugfs_create_s32 for now.
