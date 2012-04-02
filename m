Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751854Ab2DBIoR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 04:44:17 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35799 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666Ab2DBIoQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 04:44:16 -0400
MIME-Version: 1.0
In-Reply-To: <4F788731.8020708@xenotime.net>
References: <CABexPfEdd0k9UGTJL9Ae5B=e_dDZMsTGg-LNYrOjLKzHBxuPwg@mail.gmail.com>
	<4F788731.8020708@xenotime.net>
Date: Mon, 2 Apr 2012 16:44:15 +0800
Message-ID: <CABexPfHsNB1-v34vG3tW3VCLw=mWeBFoY+7Ko2174q9wK7Wh-Q@mail.gmail.com>
Subject: Re: How can I turn off/disable -O2/-Os optimization?
From: Zhihua Che <zhihua.che@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

在 2012年4月2日 上午12:49，Randy Dunlap <rdunlap@xenotime.net> 写道：
> On 04/01/2012 09:31 AM, Zhihua Che wrote:
>
>> Hi, everyone
>>
>>     I'm debugging linux kernel using kgdb/qemu， but I find that the
>> execution order didn't math the program order usually.  I guess it was
>> because the compiling optimization. So I decided to remove -O options
>> in Makefiles.
>>     First I removed -Ox in variables HOSTCFLAGS/HOSTCXXFLAGS in
>> <src_root_dir>/Makefile around line 248 and -Ox in variable
>> KBUILD_CFLAGS in <src_root_dir>/arch/x86/boot/Makefile around line 55.
>> But it didn't work, the step execution still didn't follow the program
>> order. Then I found I missed -Ox in KBUILD_CFLAGS in
>> <src_root_dir>/Makefile around line 562, so I removed them, but this
>> time, the compiling failed, complaining
>>     rcupdate.h:917:2: error: size of unnamed array is negative
>>    And finally, after grep, I find there are a load of -O2 option are
>> assigned in a load of Makefiles. So, How could I disable -O
>> optimization for debugging?
>>
>>    Thanks for any tips
>> --
>
>
> You could try the new CONFIG_READABLE_ASM patch:
>  http://marc.info/?l=linux-kernel&m=133296079716268&w=2
>
>
> --
> ~Randy

Hi,
    I tried your patch, and it seemed not to work:-(. It still didn't
follow the program order
