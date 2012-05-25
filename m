Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933428Ab2EYA0W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 20:26:22 -0400
Received: from mga02.intel.com ([134.134.136.20]:47666 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758913Ab2EYA0V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 20:26:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="148177888"
Message-ID: <4FBED148.70704@intel.com>
Date: Fri, 25 May 2012 08:24:40 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Arjan van de Ven <arjan@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Lutomirski <luto@mit.edu>, Jan Beulich <JBeulich@suse.com>,
        borislav.petkov@amd.com, arnd@arndb.de, akinobu.mita@gmail.com,
        eric.dumazet@gmail.com, fweisbec@gmail.com, rostedt@goodmis.org,
        hughd@google.com, jeremy@goop.org, len.brown@intel.com,
        tony.luck@intel.com, yongjie.ren@intel.com,
        kamezawa.hiroyu@jp.fujitsu.com, seto.hidetoshi@jp.fujitsu.com,
        penberg@kernel.org, yinghai@kernel.org, tglx@linutronix.de,
        akpm@linux-foundation.org, ak@linux.intel.com, avi@redhat.com,
        dhowells@redhat.com, mingo@redhat.com, riel@redhat.com, cpw@sgi.com,
        steiner@sgi.com, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        "asit.k.mallick@intel.com" <asit.k.mallick@intel.com>
Subject: Re: [PATCH v7 8/8] x86/tlb: just do tlb flush on one of siblings
 of SMT
References: <1337782555-8088-1-git-send-email-alex.shi@intel.com>  <1337782555-8088-9-git-send-email-alex.shi@intel.com>  <4FBD18D20200007800085951@nat28.tlf.novell.com>  <1337792984.9783.37.camel@laptop> <1337793338.9783.38.camel@laptop>  <CAObL_7GEzHYV9RbinPmK5D3DkZLiV0Wbz6j8x-Agbi21BM_OgA@mail.gmail.com>  <1337845230.9783.51.camel@laptop>  <CAObL_7FK8Pb7Ahmr0SBaPg1BvPTspr=EKG8v_QfcpdmMyuE5dA@mail.gmail.com> <1337865811.9783.152.camel@laptop> <4FBE39FE.4050001@linux.intel.com> <4FBE3D95.8030501@intel.com> <4FBE4335.6020602@linux.intel.com> <4FBE4671.2090408@intel.com> <4FBE4DB3.3070700@zytor.com>
In-Reply-To: <4FBE4DB3.3070700@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/24/2012 11:03 PM, H. Peter Anvin wrote:

> On 05/24/2012 07:32 AM, Alex Shi wrote:
>>>
>>> the TLB pool is shared as physical resource (dynamic or static, that
>>> depends), but each tlb entry will be tagged for which of the two HT
>>> pairs it's for, and on a logical level, they are completely separate as
>>> a result (as they should be)
>>
>> But, why just flush part of SMT doesn't crash kernel on many benchmarks
>> testing? Does it means flush tlb without PCID (doesn't enable in current
>> kernel) will flush both of 'TLB pool'?
>>
>> Oh, lots of questions of the TLB pool details. :) Could you like share
>> the URL of related documents?
>>
> 
> Hang on here... there is a huge difference between what a particular CPU
> implementation does and what is architecturally guaranteed.
> 
> Both wearing my Linux x86 maintainer hat, and wearing my Intel employee
> hat, I want to categorically state that Linux cannot rely on behavior
> that isn't architecturally guaranteed.  Unless we can get an
> architectural guarantee that this elision is safe, it cannot go in.  It
> doesn't work the other way -- the burden of proof is to prove that the
> change is safe, not that the change cannot be proven unsafe.


Understand and thanks for all of your time!

> 
> 	-hpa
> 


