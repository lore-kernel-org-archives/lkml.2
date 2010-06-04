Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752466Ab0FDHXG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 03:23:06 -0400
Received: from cantor.suse.de ([195.135.220.2]:44128 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751239Ab0FDHXE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 03:23:04 -0400
Message-ID: <4C08A9D0.8000505@suse.cz>
Date: Fri, 04 Jun 2010 09:22:56 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4 Thunderbird/3.0.4
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>
Cc: alan <alan@clueserver.org>, linux-kernel@vger.kernel.org
Subject: Re: Additional info on modpost segfault
References: <Pine.LNX.4.64.1006032008220.30918@blackbox.fnordora.org> <20100604045118.GC5167@cr0.nay.redhat.com>
In-Reply-To: <20100604045118.GC5167@cr0.nay.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4.6.2010 06:51, Américo Wang wrote:
> On Thu, Jun 03, 2010 at 08:10:30PM -0700, alan wrote:
>> Missed adding the actual segfault message:
>>
>>  LD      drivers/usb/built-in.o
>>  LD      drivers/built-in.o
>>  LD      vmlinux.o
>>  MODPOST vmlinux.o
>> /bin/sh: line 1: 20665 Segmentation fault      (core dumped)
>> scripts/mod/modpost -o
>> /home/alan/GitTrees/linux-2.6-mid-ref/Module.symvers -S vmlinux.o
>> make[1]: *** [vmlinux.o] Error 139
>> make: *** [vmlinux.o] Error 2
>>
>> I have looked at the gcc 4.4.4 changelog and I can't see anything
>> that should cause this.
>>
> 
> Hmm, you need to find which program segfaults here.

It's the modpost command run on vmlinux.o. Alan, can you try
$ gdb --args scripts/mod/modpost -o Module.symvers -S vmlinux.o
(gdb) r
(wait for the segfault)
(gdb) bt full

and post the backtrace?

Thanks,
Michal
