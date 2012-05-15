Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757623Ab2EOOHb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 10:07:31 -0400
Received: from mga01.intel.com ([192.55.52.88]:9776 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754402Ab2EOOH3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 10:07:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="153191410"
Message-ID: <4FB26312.6060105@intel.com>
Date: Tue, 15 May 2012 22:07:14 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Nick Piggin <npiggin@gmail.com>, yongjie.ren@intel.com
CC: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, arnd@arndb.de,
        rostedt@goodmis.org, fweisbec@gmail.com, jeremy@goop.org,
        riel@redhat.com, luto@mit.edu, avi@redhat.com, len.brown@intel.com,
        dhowells@redhat.com, fenghua.yu@intel.com, borislav.petkov@amd.com,
        yinghai@kernel.org, ak@linux.intel.com, cpw@sgi.com, steiner@sgi.com,
        akpm@linux-foundation.org, penberg@kernel.org, hughd@google.com,
        rientjes@google.com, kosaki.motohiro@jp.fujitsu.com,
        n-horiguchi@ah.jp.nec.com, tj@kernel.org, oleg@redhat.com,
        axboe@kernel.dk, jmorris@namei.org, a.p.zijlstra@chello.nl,
        kamezawa.hiroyu@jp.fujitsu.com, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH v5 6/7] x86/tlb: optimizing flush_tlb_mm
References: <1337072138-8323-1-git-send-email-alex.shi@intel.com> <1337072138-8323-7-git-send-email-alex.shi@intel.com> <CAPa8GCDsSOrzQwX2qRJyocYAZdGbwjD4t4fjxmWXV6=EoXjXZw@mail.gmail.com> <CAPa8GCADw7cn+cGukfy6=gEJAqV2Ef3=YFcPriuPmhpE-xvX7A@mail.gmail.com>
In-Reply-To: <CAPa8GCADw7cn+cGukfy6=gEJAqV2Ef3=YFcPriuPmhpE-xvX7A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2012 05:17 PM, Nick Piggin wrote:

> On 15 May 2012 19:15, Nick Piggin <npiggin@gmail.com> wrote:
>> So this should go to linux-arch...
>>
>> On 15 May 2012 18:55, Alex Shi <alex.shi@intel.com> wrote:
>>> Not every flush_tlb_mm execution moment is really need to evacuate all
>>> TLB entries, like in munmap, just few 'invlpg' is better for whole
>>> process performance, since it leaves most of TLB entries for later
>>> accessing.
> 
> Did you have microbenchmarks for this like your mprotect numbers,
> by the way? Test munmap numbers and see how that looks. Also,
> does it show up on any macro-benchmarks like specjbb?


Yongjie has tested the patchset and get some positive data on Virtual
machine.
Yongjie, could you like to share your data?
