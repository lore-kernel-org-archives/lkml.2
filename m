Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755054Ab0IMMJP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 08:09:15 -0400
Received: from compulab.co.il ([67.18.134.219]:56124 "EHLO compulab.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754534Ab0IMMJN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 08:09:13 -0400
Message-ID: <4C8E1417.4060204@compulab.co.il>
Date: Mon, 13 Sep 2010 14:07:51 +0200
From: Mike Rapoport <mike@compulab.co.il>
User-Agent: Thunderbird 2.0.0.23 (X11/20100106)
MIME-Version: 1.0
To: Robin Theunis <robint91@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-embedded mailing list <linux-embedded@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Subject: Re: ARM target not boot after remap memory
References: <AANLkTi=tWwaFHB0DY=j0UaqbYdYJpGJpmWdGC4aMufSw@mail.gmail.com>
In-Reply-To: <AANLkTi=tWwaFHB0DY=j0UaqbYdYJpGJpmWdGC4aMufSw@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ACL-Warn: {
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - compulab.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(add LAKLM to CC)

Robin Theunis wrote:
> Dear (Embedded)-Kernel-Devs,
> 
> I'm trying to build linux 2.6.34.1 for a AT91RM9200 target. The whole
> build process is successful because I get correct kernel images and
> also a uImage for U-boot.
> The U-boot version is 2010.08. I have build the whole system on a
> 64bit ubuntu machine. I use the latest buildroot to make the toolchain
> and etc. At this moment I have a
> openocd jtag dongle connected to my target for debug sessions.
> I have check that the machine id/type are correct. I have gotten those
> error messages of a unsupported target. I have resolved those errors.
> The target is self is a AT91RM9200 with 64MiB ram and 16MiB cfi flash.
> The boot args of u-boot are "console=ttyS0,115200n8
> root=/dev/mtdblock0 rootfstype=jffs2 mem=64M".
> 
> The problem is now when linux kernel is booting, nothing happens.
> 
> ---
> U-Boot> bootm
> ## Booting kernel from Legacy Image at 21000000 ...
>    Image Name:   Linux-2.6.34.1robin9200v1.0
>    Image Type:   ARM Linux Kernel Image (uncompressed)
>    Data Size:    1811796 Bytes = 1.7 MiB
>    Load Address: 20008000
>    Entry Point:  20008000
>    Verifying Checksum ... OK
>    Loading Kernel Image ... OK
> OK
> 
> Starting kernel ...
> 
> Uncompressing Linux... done, booting the kernel.
> ---
> 
> Here is stalls. With my jtag probe I can locate the problem.
> 
> ---
>> halt
> target state: halted
> target halted in ARM state due to debug-request, current mode: Supervisor
> cpsr: 0x600000d3 pc: 0xc000af3c
> MMU: enabled, D-Cache: enabled, I-Cache: enabled
>>   arm disassemble 0xc000af3c
> 0xc000af3c	0xeafffffe	B 0xc000af3c
> ---
> 
> This just loops at that address. Why does it that?
> You see that the mmu is enabled and the cpu has remapped the memory.
> Does someone have a clue what goes wrong?
> 
> Here is the .config and board file.
> http://www.on8rth.be/wp-content/uploads/2010/09/dotconfig.txt
> http://www.on8rth.be/wp-content/uploads/2010/09/board-robin9200.c
> 
> Thank you
> 
> Robin Theunis
> ON8RTH
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


-- 
Sincerely yours,
Mike.
