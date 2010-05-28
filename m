Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757094Ab0E1Ad4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 20:33:56 -0400
Received: from mail.svr02.mucip.net ([83.170.6.69]:48752 "EHLO
	mailout.mucip.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756676Ab0E1AdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 20:33:08 -0400
X-Submitted: to mailout.mucip.net (Postfix) with ESMTPSA id E95CD496A
Message-ID: <4BFF0F3F.9050800@birkenwald.de>
Date: Fri, 28 May 2010 02:33:03 +0200
From: Bernhard Schmidt <berni@birkenwald.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Lightning/1.0b1 Thunderbird/3.0.4
MIME-Version: 1.0
To: john stultz <johnstul@us.ibm.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Clock jumps
References: <loom.20100524T171038-56@post.gmane.org>	 <20100525062100.GP22163@redhat.com>	<4BFD5616.6070302@cora.nwra.com>	 <4D7E210A-4694-4B6E-B721-6024CE96ABC0@suse.de>	 <htmdsk$9kn$1@dough.gmane.org>	 <AANLkTindrSuRdOI30l4P5XMuUVv3j7Zso9fMi1xREb3A@mail.gmail.com>	 <4BFEE8A2.30706@birkenwald.de> <1275004816.1813.15.camel@work-vm>
In-Reply-To: <1275004816.1813.15.camel@work-vm>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28.05.2010 02:00, john stultz wrote:

Hi John,

> Looking at the diff:
> --- dmesg-lenny 2010-05-27 16:45:33.000000000 -0700
> +++ dmesg-squeeze       2010-05-27 16:46:14.000000000 -0700
> @@ -132,8 +132,8 @@
>   console [ttyS1] enabled
>   hpet clockevent registered
>   Fast TSC calibration using PIT
> -Detected 2660.398 MHz processor.
> -Calibrating delay loop (skipped), value calculated using timer frequency.. 5320.79 BogoMIPS (lpj=10641592)
> +Detected 2613.324 MHz processor.
> +Calibrating delay loop (skipped), value calculated using timer frequency.. 5226.64 BogoMIPS (lpj=10453296)
>   Security Framework initialized
>   Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
>   Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
> @@ -160,7 +160,7 @@
>   CPU0: Intel(R) Xeon(R) CPU            3075  @ 2.66GHz stepping 0b
>   Booting Node   0, Processors  #1
>   Brought up 2 CPUs
> -Total of 2 processors activated (10640.79 BogoMIPS).
> +Total of 2 processors activated (10546.63 BogoMIPS).
>   NET: Registered protocol family 16
>   ACPI: bus type pci registered
>   PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
>
> So you can see in the above the during the second boot the TSC
> calibration was badly mis-calculated. This was the cause of the skew.
>
> Not sure how that might be linked to the distro upgrade. It could have
> been something like SMI damage during the calibration time, but I
> thought the calibration loop watched for that.
>
> Bernhard: I expect with all those vms, this machine isn't rebooted
> frequently. So could you look at the logs to see how much the  "Detected
> xxxx.yyy MHz processor." line varies by across a few other boots (if
> they still exist?).

Correct, the box isn't rebooted often, but I do have a few dmesg outputs 
laying around. lpj was always almost the same until the very last boot 
which screwed up the clock.

dmesg:[    0.000000] Linux version 2.6.33 (root@svr02) (gcc version 
4.3.2 (Debian 4.3.2-1.1) ) #1 SMP Sun Mar 7 23:01:45 CET 2010
dmesg:[    0.008005] Calibrating delay loop (skipped), value calculated 
using timer frequency.. 5226.64 BogoMIPS (lpj=10453296)
dmesg:[    0.288002] Total of 2 processors activated (10546.63 BogoMIPS).
dmesg.0:[    0.000000] Linux version 2.6.33 (root@svr02) (gcc version 
4.3.2 (Debian 4.3.2-1.1) ) #1 SMP Sun Mar 7 23:01:45 CET 2010
dmesg.0:[    0.008005] Calibrating delay loop (skipped), value 
calculated using timer frequency.. 5320.79 BogoMIPS (lpj=10641592)
dmesg.0:[    0.274022] Total of 2 processors activated (10640.79 BogoMIPS).
dmesg.1.gz:[    0.000000] Linux version 2.6.32-rc7 (root@svr02) (gcc 
version 4.3.2 (Debian 4.3.2-1.1) ) #1 SMP Thu Nov 19 14:36:03 CET 2009
dmesg.1.gz:[    0.012004] Calibrating delay loop (skipped), value 
calculated using timer frequency.. 5319.06 BogoMIPS (lpj=10638120)
dmesg.1.gz:[    0.016000] Calibrating delay using timer specific 
routine.. 5319.99 BogoMIPS (lpj=10639980)
dmesg.1.gz:[    0.260003] Total of 2 processors activated (10639.05 
BogoMIPS).
dmesg.2.gz:[    0.000000] Linux version 2.6.32-rc7 (root@svr02) (gcc 
version 4.3.2 (Debian 4.3.2-1.1) ) #1 SMP Thu Nov 19 14:36:03 CET 2009
dmesg.2.gz:[    0.012005] Calibrating delay loop (skipped), value 
calculated using timer frequency.. 5319.35 BogoMIPS (lpj=10638712)
dmesg.2.gz:[    0.016000] Calibrating delay using timer specific 
routine.. 5319.99 BogoMIPS (lpj=10639990)
dmesg.2.gz:[    0.261567] Total of 2 processors activated (10639.35 
BogoMIPS).
dmesg.3.gz:[    0.000000] Linux version 2.6.32-rc7 (root@svr02) (gcc 
version 4.3.2 (Debian 4.3.2-1.1) ) #1 SMP Thu Nov 19 14:36:03 CET 2009
dmesg.3.gz:[    0.012005] Calibrating delay loop (skipped), value 
calculated using timer frequency.. 5319.97 BogoMIPS (lpj=10639956)
dmesg.3.gz:[    0.016000] Calibrating delay using timer specific 
routine.. 5319.99 BogoMIPS (lpj=10639987)
dmesg.3.gz:[    0.257152] Total of 2 processors activated (10639.97 
BogoMIPS).
dmesg.4.gz:[    0.000000] Linux version 2.6.32-rc7 (root@svr02) (gcc 
version 4.3.2 (Debian 4.3.2-1.1) ) #1 SMP Thu Nov 19 14:36:03 CET 2009
dmesg.4.gz:[    0.012005] Calibrating delay loop (skipped), value 
calculated using timer frequency.. 5319.84 BogoMIPS (lpj=10639688)
dmesg.4.gz:[    0.016000] Calibrating delay using timer specific 
routine.. 5319.99 BogoMIPS (lpj=10639993)
dmesg.4.gz:[    0.253571] Total of 2 processors activated (10639.84 
BogoMIPS).

If necessary I can reboot once more, but I'd like to avoid it.

Bernhard
