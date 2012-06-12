Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752648Ab2FLGWK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 02:22:10 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53388 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751670Ab2FLGWH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 02:22:07 -0400
X-IronPort-AV: E=Sophos;i="4.77,394,1336320000"; 
   d="scan'208";a="5166319"
Message-ID: <4FD6E101.3010106@cn.fujitsu.com>
Date: Tue, 12 Jun 2012 14:26:09 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: rob@landley.net, tglx@linutronix.de, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        bhelgaas@google.com
Subject: Re: [PATCH 1/2 v2] x86: add max_addr boot option
References: <4FD5AFF2.3040306@cn.fujitsu.com> <4FD65FD4.4060705@zytor.com>
In-Reply-To: <4FD65FD4.4060705@zytor.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/06/12 14:22:39,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/06/12 14:22:40,
	Serialize complete at 2012/06/12 14:22:40
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 06/12/2012 05:15 AM, H. Peter Anvin Wrote:
> On 06/11/2012 01:44 AM, Wen Congyang wrote:
>> Currently, the boot option max_addr is only supported on ia64 platform.
>> We also need it on x86 platform.
>> For example:
>> There are two nodes:
>>  NODE#0  address range 0x00000000 00000000 - 0x00010000 00000000
>>  NODE#1  address range 0x00010000 00000000 - 0x00020000 00000000
>> If we only want to use node0, we can specify the max_addr. The boot
>> option "mem=" can do the same thing now. But the boot option "mem="
>> means the total memory used by the system. If we tell the user
>> that the boot option "mem=" can do this, it will confuse the user.
>> So we need an new boot option "max_addr" on x86 platform.
>>
> 
> I fail to see what this does that cannot be done with the
> since-long-existing memmap= option.  Could you address why memmap=
> doesn't match your needs?

The memmap= option is very diffcult to use. The end user should know the memory
map in the system. The end user can get the max address of NODE#0, but he
may not know the memory map for NODE#0. If the end user give the wrong memory
map, the kernel can not boot. For example: I add memmap=16G@0 in the kernel
parameter, and the kernel cannot boot. The max_addr is more easier to use.

Thanks
Wen Congyang

> 
> 	-hpa
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

