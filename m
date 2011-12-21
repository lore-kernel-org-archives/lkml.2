Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437Ab1LUKi2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 05:38:28 -0500
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:59843 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429Ab1LUKiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 05:38:25 -0500
From: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>, Avi Kivity <avi@redhat.com>
Cc: peterz@infradead.org, linux-kernel@vger.kernel.org,
        vatsa@linux.vnet.ibm.com, bharata@linux.vnet.ibm.com
Subject: Re: [RFC PATCH 0/4] Gang scheduling in CFS
In-Reply-To: <20111219112326.GA15090@elte.hu>
References: <20111219083141.32311.9429.stgit@abhimanyu.in.ibm.com> <20111219112326.GA15090@elte.hu>
User-Agent: Notmuch/0.10.2+70~gf0e0053 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-redhat-linux-gnu)
Date: Wed, 21 Dec 2011 16:09:36 +0530
Message-ID: <87sjke1a53.fsf@abhimanyu.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
x-cbid: 11122110-9574-0000-0000-0000009C9287
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Dec 2011 12:23:26 +0100, Ingo Molnar <mingo@elte.hu> wrote:
> 
> * Nikunj A. Dadhania <nikunj@linux.vnet.ibm.com> wrote:
> 
> So could we please approach this from the benchmarked workload 
> angle first? The highest improvement is in ebizzy:
> 
> >     ebizzy 2vm (improved 15 times, i.e. 1520%)
> 
> What's behind this huge speedup? Does ebizzy use user-space 
> spinlocks perhaps? Could we do something on the user-space side 
> to get a similar speedup?
> 
This is from the perf run on the host:

Baseline:

16.22%         qemu-kvm  [kvm_intel]    [k] free_kvm_area
 8.27%         qemu-kvm  [kvm]          [k] start_apic_timer
 7.53%         qemu-kvm  [kvm]          [k] kvm_put_guest_fpu

Gang:

24.44%         qemu-kvm  [kvm_intel]    [k] free_kvm_area
13.42%         qemu-kvm  [kvm]          [k] start_apic_timer 
 9.91%         qemu-kvm  [kvm]          [k] kvm_put_guest_fpu

Ingo, Avi, I am not getting anything obvious from this. Any ideas?

Regards
Nikunj

