Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754958Ab1K1UCD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 15:02:03 -0500
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:35512 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754779Ab1K1UB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 15:01:58 -0500
Message-ID: <4ED3E8AD.6050304@linux.vnet.ibm.com>
Date: Tue, 29 Nov 2011 01:31:49 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Nicolas Kalkhof <nkalkhof@web.de>
CC: linux-kernel@vger.kernel.org,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
Subject: Re: Too many poll_idle cpu calls in kernel 3.2 rc-series
References: <1587582695.5658131.1322424808507.JavaMail.fmail@mwmweb005>
In-Reply-To: <1587582695.5658131.1322424808507.JavaMail.fmail@mwmweb005>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 11112820-9574-0000-0000-00000053817D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Adding linux-pm mailing list to CC.

Thanks,
Srivatsa S. Bhat

On 11/28/2011 01:43 AM, Nicolas Kalkhof wrote:

> the kernel v3.2 series shows excessive poll_idle calls during system idle phases causing the cpu
> (mobile i7 2620M) to heat up and draw additional 10% more power.  All kernel versions between
> 3.2-rc1 and 3.2-rc3 are affected. Perf Top and Powertop both show the same issue.
> I've posted a similar bug report before: http://marc.info/?l=linux-kernel&m=132164909313594&w=2
> and used perf top -U to verify the poll_idle calls as requested.
> 
> dmesg and kernel .config attached.
> 
> Could someone please confirm this issue?
> 
> Thanks and Regards
> Nic
> 
> perf top -U shows:
> Events: 30K cycles
>  97.88%  [kernel]   [k] poll_idle
>   0.17%  [kernel]   [k] sdhci_irq
>   0.08%  [kernel]   [k] unix_poll
>   0.06%  [kernel]   [k] _raw_spin_lock_irqsave
>   0.06%  [kernel]   [k] page_fault
>   0.05%  [kernel]   [k] fget_light
>   0.05%  [kernel]   [k] format_decode
>   0.04%  [kernel]   [k] kmem_cache_alloc
>   0.04%  [kernel]   [k] clear_page
>   0.04%  [kernel]   [k] _raw_spin_unlock_irqrestore
>   0.03%  [kernel]   [k] do_select
>   0.03%  [kernel]   [k] seq_printf
>   0.03%  [kernel]   [k] vfs_read
>   0.03%  [kernel]   [k] _raw_spin_lock
>   0.03%  [kernel]   [k] vsnprintf
>   0.03%  [kernel]   [k] number.clone.1
>   0.03%  [kernel]   [k] fput
> 
> Powertop shows:
> n                Avg residency       P-states (frequencies)
> C0 (cpu running)        ( 5.4%)       Turbo Mode     1.5%
> polling           1.8ms (94.6%)         2.71 Ghz     0.1%
> C1 mwait          0.0ms ( 0.0%)         2.21 Ghz     0.1%
> C2 mwait          0.0ms ( 0.0%)         1400 Mhz     0.1%
> C3 mwait          0.0ms ( 0.0%)          800 Mhz    98.2%
> C4 mwait          0.0ms ( 0.0%)
> Wakeups-from-idle per second : 529.4    interval: 5.0s
> 

