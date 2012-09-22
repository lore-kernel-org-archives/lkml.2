Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226Ab2IVJOl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2012 05:14:41 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:42325 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755075Ab2IVJOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2012 05:14:37 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.00.1209201754450.31786@twin.jikos.cz>
References: <CAHODtZTFP=KJh1VmBvCcYLWD=M41vBnf_nyoEbvHKW1UzYx8dQ@mail.gmail.com>
 <alpine.LRH.2.00.1209201754450.31786@twin.jikos.cz>
From: Roel Kluin <roel.kluin@gmail.com>
Date: Sat, 22 Sep 2012 11:14:16 +0200
Message-ID: <CABPwjKfBohFKL0e6ywTRvybGz85Fp04Oy4uF7gg3RWDFj7hpVw@mail.gmail.com>
Subject: Re: Fix bug in end absolute address in drivers/mtd/devices/slram.c
To: Jiri Kosina <jkosina@suse.cz>
Cc: Jiri Engelthaler <engycz@gmail.com>, linux-kernel@vger.kernel.org,
        David Woodhouse <dwmw2@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2012 at 5:55 PM, Jiri Kosina <jkosina@suse.cz> wrote:
> On Thu, 20 Sep 2012, Jiri Engelthaler wrote:
>
>> Hello.
>>   I found a bug in parsing end absolute address in
>> drivers/mtd/devices/slram.c. There is checking for startaddress <
>> endaddress and endaddress subtracted by startaddress before check. The
>> bug is there from commit 3afd522de8d8ec446efe957b86e4f63e3dd8ce9d Mon,
>> 19 Jan 2009 01:24:21 +0000
>>
>> Here is the patch
>>
>> Signed-off-by: Jiri Engelthaler <engycz@gmail.com>
>>
>> --- linux-3.2.28/drivers/mtd/devices/slram.c  2012-08-19 19:15:38.000000000 +0200
>> +++ linux-3.2.28.mod/drivers/mtd/devices/slram.c      2012-09-19
>> 18:29:28.012740703 +0200
>> @@ -266,7 +266,7 @@ static int parse_cmdline(char *devname,
>>
>>       if (*(szlength) != '+') {
>>               devlength = simple_strtoul(szlength, &buffer, 0);
>> -             devlength = handle_unit(devlength, buffer) - devstart;
>> +             devlength = handle_unit(devlength, buffer);
>>               if (devlength < devstart)
>>                       goto err_out;
>
> ... adding the suspects to CC so that they are aware of this.

Yes, that's what it should have been. FWIW,

Acked-by: Roel Kluin <roel.kluin@gmail.com>
