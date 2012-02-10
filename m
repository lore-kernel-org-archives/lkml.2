Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759798Ab2BJS0H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 13:26:07 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:55793 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759776Ab2BJS0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 13:26:04 -0500
Message-ID: <4F356139.9000609@pobox.com>
Date: Fri, 10 Feb 2012 13:26:01 -0500
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: qiang.liu@freescale.com
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH V2] fsl-sata: I/O load balancing
References: <1327025958-10605-1-git-send-email-qiang.liu@freescale.com>
In-Reply-To: <1327025958-10605-1-git-send-email-qiang.liu@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/19/2012 09:19 PM, qiang.liu@freescale.com wrote:
> From: Qiang Liu<qiang.liu@freescale.com>
>
> Reduce interrupt signals through reset Interrupt Coalescing Control Reg.
> Provide dynamic method to adjust interrupt signals and timer ticks by sysfs.
> It is a tradeoff for different applications.
>
> Signed-off-by: Qiang Liu<qiang.liu@freescale.com>
> ---
>
> change for V2
> 	support dynamic config interrupt coalescing register by /sysfs
> 	test random small file with iometer
> Description:
>    1. fsl-sata interrupt will be raised 130 thousand times when write 8G file
>      (dd if=/dev/zero of=/dev/sda2 bs=128K count=65536);
>    2. most of interrupts raised because of only 1-4 commands completed;
>    3. only 30 thousand times will be raised after set max interrupt threshold,
>      more interrupts are coalesced as the description of ICC;
>
> Test methods and results:
>    1. test sequential large file performance,
>    [root@p2020ds root]# echo 31 524287>  \
>    	/sys/devices/soc.0/ffe18000.sata/intr_coalescing
>    [root@p2020ds root]# dd if=/dev/zero of=/dev/sda2 bs=128K count=65536&
>    [root@p2020ds root]# top
>
>    CPU %  |  dd   |  flush-8:0 | softirq
>    ---------------------------------------
>    before | 20-22 |    17-19   |    7
>    ---------------------------------------
>    after  | 18-21 |    15-16   |    5
>    ---------------------------------------
>    2. test random small file with iometer,
>   iometer paramters:
>     4 I/Os burst length, 1MB transfer request size, 100% write, 2MB file size
>     as default configuration of interrupt coalescing register, 1 interrupts and
>   no timeout config, total write performance is 119MB per second,
>     after config with the maximum value, write performance is 110MB per second.
>
>    After compare the test results, a configuable interrupt coalescing should be
>    better when cope with flexible context.
>
>   drivers/ata/sata_fsl.c |  111 ++++++++++++++++++++++++++++++++++++++++++++++--
>   1 files changed, 107 insertions(+), 4 deletions(-)

Doesn't seem to apply to upstream, or another less recent -rc...

	Jeff



