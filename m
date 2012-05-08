Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755878Ab2EHPCq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 11:02:46 -0400
Received: from casper.infradead.org ([85.118.1.10]:48663 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753843Ab2EHPCp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 11:02:45 -0400
Message-ID: <1336489319.16236.43.camel@twins>
Subject: Re: [PATCH v3] TLB flush optimization
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Alex Shi <alex.shi@intel.com>
Cc: mgorman@suse.de, npiggin@gmail.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, arnd@arndb.de, rostedt@goodmis.org, fweisbec@gmail.com,
        jeremy@goop.org, gregkh@linuxfoundation.org, glommer@redhat.com,
        riel@redhat.com, luto@mit.edu, avi@redhat.com, len.brown@intel.com,
        dhowells@redhat.com, fenghua.yu@intel.com, borislav.petkov@amd.com,
        yinghai@kernel.org, ak@linux.intel.com, cpw@sgi.com, steiner@sgi.com,
        akpm@linux-foundation.org, penberg@kernel.org, hughd@google.com,
        rientjes@google.com, kosaki.motohiro@jp.fujitsu.com,
        n-horiguchi@ah.jp.nec.com, paul.gortmaker@windriver.com, trenn@suse.de,
        tj@kernel.org, oleg@redhat.com, axboe@kernel.dk,
        kamezawa.hiroyu@jp.fujitsu.com, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org
Date: Tue, 08 May 2012 17:01:59 +0200
In-Reply-To: <1336485790-30902-1-git-send-email-alex.shi@intel.com>
References: <1336485790-30902-1-git-send-email-alex.shi@intel.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-08 at 22:03 +0800, Alex Shi wrote:
> This version just added 2 patches, the 6th and 7th. The first 5 patches are 
> same as v2.
> 
> Seems it is a little hard for me to find a real case to show performance gain.
> But the advantage is there ture.
> 
> Any comments are appreciated!
> 
> Alex
> 
> [PATCH v3 1/7] x86/tlb_info: get last level TLB entry number of CPU
> [PATCH v3 2/7] x86/flush_tlb: try flush_tlb_single one by one in
> [PATCH v3 3/7] x86/tlb: fall back to flush all when meet a THP large
> [PATCH v3 4/7] x86/tlb: add tlb flush all factor for specific CPUs
> [PATCH v3 5/7] x86/tlb: remove comments for tlb_flush_range
> [PATCH v3 6/7] x86/tlb: optimizing flush_tlb_mm
> [PATCH v3 7/7] x86/tlb: add tlb_flushall_factor into sysfs for user

Have you tried what happens if you get rid of the funny multi-vector-ipi
scheme and use the generic smp_call functions?
