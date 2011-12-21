Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233Ab1LUKoB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 05:44:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2382 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751390Ab1LUKn7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 05:43:59 -0500
Message-ID: <4EF1B85F.7060105@redhat.com>
Date: Wed, 21 Dec 2011 12:43:43 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>
CC: Ingo Molnar <mingo@elte.hu>, peterz@infradead.org,
        linux-kernel@vger.kernel.org, vatsa@linux.vnet.ibm.com,
        bharata@linux.vnet.ibm.com
Subject: Re: [RFC PATCH 0/4] Gang scheduling in CFS
References: <20111219083141.32311.9429.stgit@abhimanyu.in.ibm.com> <20111219112326.GA15090@elte.hu> <87sjke1a53.fsf@abhimanyu.in.ibm.com>
In-Reply-To: <87sjke1a53.fsf@abhimanyu.in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21/2011 12:39 PM, Nikunj A Dadhania wrote:
> On Mon, 19 Dec 2011 12:23:26 +0100, Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > * Nikunj A. Dadhania <nikunj@linux.vnet.ibm.com> wrote:
> > 
> > So could we please approach this from the benchmarked workload 
> > angle first? The highest improvement is in ebizzy:
> > 
> > >     ebizzy 2vm (improved 15 times, i.e. 1520%)
> > 
> > What's behind this huge speedup? Does ebizzy use user-space 
> > spinlocks perhaps? Could we do something on the user-space side 
> > to get a similar speedup?
> > 
> This is from the perf run on the host:
>
> Baseline:
>
> 16.22%         qemu-kvm  [kvm_intel]    [k] free_kvm_area
>  8.27%         qemu-kvm  [kvm]          [k] start_apic_timer
>  7.53%         qemu-kvm  [kvm]          [k] kvm_put_guest_fpu
>
> Gang:
>
> 24.44%         qemu-kvm  [kvm_intel]    [k] free_kvm_area
> 13.42%         qemu-kvm  [kvm]          [k] start_apic_timer 
>  9.91%         qemu-kvm  [kvm]          [k] kvm_put_guest_fpu
>
> Ingo, Avi, I am not getting anything obvious from this. Any ideas?
>

Looks like perf is confused, this sometimes happens if you rebuild the
kernel but only rmmod/insmod kvm.  Try a clean build + boot.

-- 
error compiling committee.c: too many arguments to function

