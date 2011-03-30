Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755718Ab1C3JyN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 05:54:13 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:64488 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755549Ab1C3JyM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 05:54:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=DT1bQwFf6jIo0cBqoCA+k0ShfhtzV/hM+fAGFZ/t8N7QbqHfeGkY9k6EIUXXaait60
         01JXdQLw9kwX6guGAPua/D4luHK+4cTgq1AU7wsQQ5PBnd8U2ftDIQKxhCO9dal9mS7b
         LNeWIXPnbDda4Vr8KdwAmE+fyay3ySOYwE5bY=
MIME-Version: 1.0
In-Reply-To: <1301476505.29074.47.camel@e102109-lin.cambridge.arm.com>
References: <9bde694e1003020554p7c8ff3c2o4ae7cb5d501d1ab9@mail.gmail.com>
	<AANLkTinnqtXf5DE+qxkTyZ9p9Mb8dXai6UxWP2HaHY3D@mail.gmail.com>
	<1300960540.32158.13.camel@e102109-lin.cambridge.arm.com>
	<AANLkTim139fpJsMJFLiyUYvFgGMz-Ljgd_yDrks-tqhE@mail.gmail.com>
	<1301395206.583.53.camel@e102109-lin.cambridge.arm.com>
	<AANLkTim-4v5Cbp6+wHoXjgKXoS0axk1cgQ5AHF_zot80@mail.gmail.com>
	<1301399454.583.66.camel@e102109-lin.cambridge.arm.com>
	<AANLkTin0_gT0E3=oGyfMwk+1quqonYBExeN9a3=v=Lob@mail.gmail.com>
	<AANLkTi=gMP6jQuQFovfsOX=7p-SSnwXoVLO_DVEpV63h@mail.gmail.com>
	<1301476505.29074.47.camel@e102109-lin.cambridge.arm.com>
Date: Wed, 30 Mar 2011 12:54:11 +0300
Message-ID: <AANLkTi=YB+nBG7BYuuU+rB9TC-BbWcJ6mVfkxq0iUype@mail.gmail.com>
Subject: Re: kmemleak for MIPS
From: Daniel Baluta <daniel.baluta@gmail.com>
To: Maxin John <maxin.john@gmail.com>
Cc: naveen yadav <yad.naveen@gmail.com>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> unreferenced object 0x8f90d000 (size 4096):
>>   comm "swapper", pid 1, jiffies 4294937330 (age 815.000s)
>>   hex dump (first 32 bytes):
>>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>>   backtrace:
>>     [<80529644>] alloc_large_system_hash+0x2f8/0x410
>>     [<805383b4>] udp_table_init+0x4c/0x158
>>     [<805384dc>] udp_init+0x1c/0x94
>>     [<8053889c>] inet_init+0x184/0x2a0
>>     [<80100584>] do_one_initcall+0x174/0x1e0
>>     [<8051f348>] kernel_init+0xe4/0x174
>>     [<80103d4c>] kernel_thread_helper+0x10/0x18
>
> If you for the kmemleak scan (via echo) a few times, do you get more
> leaks? The udp_table_init() function looks like it could leak some
> memory but I haven't seen it before. I'm not sure whether this is a
> false positive or a real leak.

Looking again at udp_init_table it seem that a memory leak is possible.
Could you post your .config and the full output of dmesg after booting.

A situation where CONFIG_BASE_SMALL is 0, and
table->mask < UDP_HTABLE_SIZE_MIN - 1 would lead
to a memory leak.

Furthermore, you can add some printks inside udp_init_table
and check what is really happening there. ([1])

thanks,
Daniel.

[1] http://lxr.linux.no/linux+v2.6.38/net/ipv4/udp.c#L2125

thanks,
Daniel.
