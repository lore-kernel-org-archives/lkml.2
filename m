Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757116Ab1JOA35 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 20:29:57 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42295 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753535Ab1JOA34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 20:29:56 -0400
Message-ID: <4E98D402.2030600@gmail.com>
Date: Fri, 14 Oct 2011 18:29:54 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Chris Palmer <chris.palmer@pobox.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PROBLEM] ASUS Sandybridge motherboards + PCI not working (IRQ
 n: nobody cared)
References: <4E98175A.8040905@pobox.com>
In-Reply-To: <4E98175A.8040905@pobox.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2011 05:04 AM, Chris Palmer wrote:
> Interrupt handling for *PCI boards with ASUS Sandybridge motherboards*
> seems to be broken.
>
> It has been seen with network and non-network PCI boards. PCIx network
> boards work OK. And all reports are for ASUS motherboards.
>
> It always results in the infamous "IRQ n: nobody cared" message usually
> within an hour. It is possible to restart things by rmmod/modprobe on
> the appropriate PCI driver.
>
> Andrew Morton kindly took a quick look and thinks it is most likely an
> ACPI bug.
>
> Configuration summary:
>   - ASUS P8H67-V/R3 Motherboard (others have problems with similar M/Bs)
>   - M/B BIOS 0804 (just updated to that - no change)
>   - Core i5/2500K
>   - Onboard ethernet (at11c driver - works)
>   - Additional PCIx Intel ethernet board (e1000e driver - works)
>   - Additional PCI Broadcom BCM5702X ethernet board (tg3 driver - fails)
> 	[ Also fails with other PCI boards such as RTL8139 ]
>   - Kernel 3.0.6
>
>
> Any help much appreciated...
>
> Previous references:
>
> https://lkml.org/lkml/2011/6/30/197
> https://bugzilla.kernel.org/show_bug.cgi?id=38632
> https://bugzilla.redhat.com/show_bug.cgi?id=713351
> https://bugzilla.kernel.org/show_bug.cgi?id=35332
> https://bugzilla.kernel.org/show_bug.cgi?id=34242
> https://bugzilla.kernel.org/show_bug.cgi?id=32242
> https://bugzilla.kernel.org/show_bug.cgi?id=39122

The bugzilla reports aren't currently accessible so I don't know if it 
was posted there, but can you post the output of "lspci -vv" as root? 
Could be that some other device is configured on that IRQ and sometimes 
spuriously generates interrupts.

