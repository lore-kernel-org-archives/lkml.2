Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757194Ab2ATCU0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 21:20:26 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:37940 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201Ab2ATCUZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 21:20:25 -0500
MIME-Version: 1.0
In-Reply-To: <giipk7v2hv.fsf@mx10.gouders.net>
References: <gi39bcyff8.fsf@mx10.gouders.net>
	<20120119110121.GC9268@arm.com>
	<gi1uqvsx8n.fsf@karga.hank.lab>
	<20120119140058.GA19036@arm.com>
	<gik44nrc52.fsf@karga.hank.lab>
	<20120119153732.GB20558@arm.com>
	<gi1uqvwpt2.fsf@mx10.gouders.net>
	<gimx9jv50u.fsf@mx10.gouders.net>
	<giipk7v2hv.fsf@mx10.gouders.net>
Date: Thu, 19 Jan 2012 21:20:24 -0500
Message-ID: <CA+5PVA67g_2u6YkYtOMKwZOzmmkHs7FhYUASSOQbDozFvrzp-A@mail.gmail.com>
Subject: Re: [Problem] kernel hangs at boot (bisected 892d208bcf)
From: Josh Boyer <jwboyer@gmail.com>
To: Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 19, 2012 at 3:52 PM, Dirk Gouders
<gouders@et.bocholt.fh-gelsenkirchen.de> wrote:
>> I did some more testing and it turns out that I have to revert a single
>> line of commit b66930052abf2 to make the kernel boot:
>>
>> diff --git a/mm/kmemleak.c b/mm/kmemleak.c
>> index c833add..d8bbb68 100644
>> --- a/mm/kmemleak.c
>> +++ b/mm/kmemleak.c
>> @@ -1710,6 +1710,7 @@ static void kmemleak_disable(void)
>>                 return;
>>
>>         /* stop any memory operation tracing */
>> +       atomic_set(&kmemleak_early_log, 0);
>>         atomic_set(&kmemleak_enabled, 0);
>>
>>         /* check whether it is too early for a kernel thread */
>>
>> I started that kernel with initcall_debug and attach the dmesg output.
>
> Hi Catlin,
>
> I want to note that in my config CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF is
> set which causes kmemleak_disable() to be called in kmemleak_init().

I also had CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF=y in my .config.  Disabling that
option allowed the machine to boot just fine.  Dirk seems to be onto something
here.

josh
