Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759596Ab2EPR5R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 13:57:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54211 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752823Ab2EPR5Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 13:57:16 -0400
Message-ID: <4FB3E9FE.5020902@zytor.com>
Date: Wed, 16 May 2012 10:55:10 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Alex Shi <alex.shi@intel.com>
CC: tglx@linutronix.de, mingo@redhat.com, arnd@arndb.de, rostedt@goodmis.org,
        fweisbec@gmail.com, jeremy@goop.org, riel@redhat.com, luto@mit.edu,
        avi@redhat.com, len.brown@intel.com, dhowells@redhat.com,
        fenghua.yu@intel.com, borislav.petkov@amd.com, yinghai@kernel.org,
        ak@linux.intel.com, cpw@sgi.com, steiner@sgi.com,
        akpm@linux-foundation.org, penberg@kernel.org, hughd@google.com,
        rientjes@google.com, kosaki.motohiro@jp.fujitsu.com,
        n-horiguchi@ah.jp.nec.com, tj@kernel.org, oleg@redhat.com,
        axboe@kernel.dk, jmorris@namei.org, a.p.zijlstra@chello.nl,
        kamezawa.hiroyu@jp.fujitsu.com, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, yongjie.ren@intel.com
Subject: Re: [PATCH v5 5/7] x86/tlb: add tlb_flushall_shift for specific CPU
References: <1337072138-8323-1-git-send-email-alex.shi@intel.com> <1337072138-8323-6-git-send-email-alex.shi@intel.com> <4FB34DFB.2040902@intel.com>
In-Reply-To: <4FB34DFB.2040902@intel.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2012 11:49 PM, Alex Shi wrote:
> +	if (!cpu_has_invlpg || vma->vm_flags & VM_HUGETLB
> +			|| tlb_flushall_shift == (u16)TLB_FLUSH_ALL) {

I asked for you to fold the cpu_has_invlpg test into tlb_flushall_shift.
 Also, (u16)TLB_FLUSH_ALL really is hit up with the ugly stick... why on
earth is this u16?  It's a bit shift, so it can't be bigger than 6 bits
anyway... and if you want to be able to use -1 as a sentinel you might
as well make it a signed value and use < 0 or == -1 as the test.

Am I missing something really fundamental here?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

