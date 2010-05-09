Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549Ab0EIXsY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 19:48:24 -0400
Received: from crca.org.au ([74.207.252.120]:40810 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752657Ab0EIXsW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 19:48:22 -0400
X-Bogosity: Ham, spamicity=0.000006
Message-ID: <4BE749C2.50300@crca.org.au>
Date: Mon, 10 May 2010 09:48:18 +1000
From: Nigel Cunningham <ncunningham@crca.org.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>,
       Linux Power Management List <linux-pm@lists.osdl.org>
Subject: Re: 2.6.33 & 2.6.34-rc6: Huge number of Load Balancing tick wakeups.
References: <4BE4F5DF.70903@crca.org.au> <alpine.LFD.2.00.1005081511550.4103@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1005081511550.4103@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi again.

On 09/05/10 05:16, Len Brown wrote:
> What do you see if vmware is not present?
> What do you see if you boot single user mode,
> how about with maxcpusx=1?

Repeated the tests, just booting into X (xfce) - except for the init S 
test. No programs were started and wifi was turned off.

1) No vmware (etc)

Cn                Avg residency
C0 (cpu running)        ( 3.7%)
polling           0.0ms ( 0.0%)
C1 mwait          0.0ms ( 0.0%)
C2 mwait          0.1ms ( 0.3%)
C4 mwait          5.4ms (96.0%)
P-states (frequencies)
Turbo Mode     1.4%
   2.21 Ghz     0.0%
   1.60 Ghz     0.0%
   1200 Mhz     0.0%
    800 Mhz    98.6%
Wakeups-from-idle per second : 202.7    interval: 15.0s
no ACPI power usage estimate available
Top causes for wakeups:
   56.1% (128.5)   [kernel scheduler] Load balancing tick
   13.1% ( 30.1)   [extra timer interrupt]
    6.9% ( 15.9)   [ata_piix] <interrupt>

2) Above + maxcpus=1

Cn                Avg residency
C0 (cpu running)        ( 4.0%)
polling           0.0ms ( 0.0%)
C1 mwait          0.0ms ( 0.0%)
C2 mwait          0.4ms ( 0.2%)
C4 mwait         16.0ms (95.9%)
P-states (frequencies)
Turbo Mode     6.0%
   2.21 Ghz     0.0%
   1.60 Ghz     0.0%
   1200 Mhz     0.0%
    800 Mhz    94.0%
Wakeups-from-idle per second : 64.5     interval: 15.0s
no ACPI power usage estimate available
Top causes for wakeups:
   39.6% ( 46.3)   [kernel scheduler] Load balancing tick
   12.3% ( 14.3)   [ata_piix] <interrupt>

(No idea why you need a load balancing tick with one core!)

3) Init S, without maxcpus=1

Cn                Avg residency
C0 (cpu running)        ( 0.0%)
polling           0.0ms ( 0.0%)
C1 mwait          0.0ms ( 0.0%)
C2 mwait          0.1ms ( 0.0%)
C4 mwait         48.9ms (100.0%)
P-states (frequencies)
Turbo Mode     0.0%
   2.21 Ghz     0.0%
   1.60 Ghz     0.0%
   1200 Mhz     0.0%
    800 Mhz   100.0%
Wakeups-from-idle per second : 21.4     interval: 15.0s
no ACPI power usage estimate available
Top causes for wakeups:
   33.5% ( 10.3)   [kernel core] hrtimer_start (tick_sched_timer)
   16.1% (  4.9)   [kernel core] cursor_timer_handler (cursor_timer_handler)
   15.9% (  4.9)   [kernel scheduler] Load balancing tick
   12.8% (  3.9)   [kernel core] usb_hcd_poll_rh_status (rh_timer_func)
    9.3% (  2.9)   [ahci] <interrupt>

I also tried the patch Dominik provided, and it didn't seem to make a 
difference:

P-states (frequencies)
Turbo Mode     3.7%
   2.21 Ghz     0.0%
   1.60 Ghz     0.0%
   1200 Mhz     0.6%
    800 Mhz    95.7%
Wakeups-from-idle per second : 236.7    interval: 15.0s
no ACPI power usage estimate available
Top causes for wakeups:
   55.4% (119.7)   [kernel scheduler] Load balancing tick
    9.7% ( 20.9)   skype
    7.7% ( 16.5)   [ata_piix] <interrupt>

Regards,

Nigel
