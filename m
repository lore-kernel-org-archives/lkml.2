Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757919Ab1CaOZm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 10:25:42 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:64900 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757479Ab1CaOZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 10:25:40 -0400
Message-ID: <4D948EC1.9080208@kernel.org>
Date: Thu, 31 Mar 2011 07:25:05 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Robin Holt <holt@sgi.com>
CC: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [RFC 2/2] Make x86 calibrate_delay run in parallel.
References: <20101215015840.390204279@gulag1.americas.sgi.com> <20101215015849.051095242@gulag1.americas.sgi.com> <AANLkTinoctZFKo4wBmrrdFggnjSj74QfqvEpz59sW15x@mail.gmail.com> <20110331092945.GD24046@sgi.com>
In-Reply-To: <20110331092945.GD24046@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt358.oracle.com [141.146.40.158]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4D948ED1.01AA,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/2011 02:29 AM, Robin Holt wrote:
...
> I don't see how this patch would affect that.  Has this been tested on
> a multi-core intel cpu?  I will try to test it today when I get to the
> office.

Yes. I tested on our 8 sockets 10 cores intel cpu system and 8 cores system.
looks getting correct result.

>
> Additionally, it takes the bogomips value from being part of an output
> line and makes it a separate line.  On a 4096 cpu system, that will mean
> many additional lines of output.  In the past, we have seen that will
> cause a considerable slowdown as time is spent printing.  Fortunately,
> that is likely not going to slow things down as a secondary cpu will
> likely be doing that work while the boot cpu is allowed to continue with
> the boot.  Is there really a value for a normal boot to have this output?
> Can we remove the individual lines of output and just print the system
> BogoMips value?

that is easy. just update print_lpj.

static void __cpuinit print_lpj(int cpu, char *str, unsigned long lpj)
{
         static bool printed;

         if (printed)
                 return;

         pr_info("CPU%d: Calibrating delay%s"
                 "%lu.%02lu BogoMIPS (lpj=%lu)\n", cpu, str,
                 lpj/(500000/HZ), (lpj/(5000/HZ)) % 100, lpj);

         /* only print cpu0, and cpu1 */
         if (cpu)
                 printed = true;
}

current printing is for debug purpose, So we don't need to waiting the booting get done.
just checking it serial console.

Thanks

Yinghai
