Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756650Ab2EHPTH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 11:19:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57182 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756090Ab2EHPTE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 11:19:04 -0400
Message-ID: <4FA93946.2000302@zytor.com>
Date: Tue, 08 May 2012 08:18:30 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Alex Shi <alex.shi@intel.com>
CC: mgorman@suse.de, npiggin@gmail.com, tglx@linutronix.de, mingo@redhat.com,
        arnd@arndb.de, rostedt@goodmis.org, fweisbec@gmail.com,
        jeremy@goop.org, gregkh@linuxfoundation.org, glommer@redhat.com,
        riel@redhat.com, luto@mit.edu, avi@redhat.com, len.brown@intel.com,
        dhowells@redhat.com, fenghua.yu@intel.com, borislav.petkov@amd.com,
        yinghai@kernel.org, ak@linux.intel.com, cpw@sgi.com, steiner@sgi.com,
        akpm@linux-foundation.org, penberg@kernel.org, hughd@google.com,
        rientjes@google.com, kosaki.motohiro@jp.fujitsu.com,
        n-horiguchi@ah.jp.nec.com, paul.gortmaker@windriver.com, trenn@suse.de,
        tj@kernel.org, oleg@redhat.com, axboe@kernel.dk,
        a.p.zijlstra@chello.nl, kamezawa.hiroyu@jp.fujitsu.com,
        viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 4/7] x86/tlb: add tlb flush all factor for specific
 CPUs
References: <1336485790-30902-1-git-send-email-alex.shi@intel.com> <1336485790-30902-5-git-send-email-alex.shi@intel.com>
In-Reply-To: <1336485790-30902-5-git-send-email-alex.shi@intel.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/2012 07:03 AM, Alex Shi wrote:
>  
> -	if (!cpu_has_invlpg || vma->vm_flags & VM_HUGETLB) {
> +	if (!cpu_has_invlpg || vma->vm_flags & VM_HUGETLB
> +				|| !tlb_flushall_factor) {

OK nevermind on the division by zero, but this yet another test being
performed.

If nothing else you could fold these tests and make tlb_flushall_factor
zero if !cpu_has_invlpg.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

