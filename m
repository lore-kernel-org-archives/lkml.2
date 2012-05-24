Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752296Ab2EXFO3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 01:14:29 -0400
Received: from mga03.intel.com ([143.182.124.21]:53259 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751179Ab2EXFO2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 01:14:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="103632828"
Message-ID: <4FBDC34E.5090905@intel.com>
Date: Thu, 24 May 2012 13:12:46 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Andrew Lutomirski <luto@mit.edu>
CC: Peter Zijlstra <peterz@infradead.org>, Jan Beulich <JBeulich@suse.com>,
        borislav.petkov@amd.com, arnd@arndb.de, akinobu.mita@gmail.com,
        eric.dumazet@gmail.com, fweisbec@gmail.com, rostedt@goodmis.org,
        hughd@google.com, jeremy@goop.org, len.brown@intel.com,
        tony.luck@intel.com, yongjie.ren@intel.com,
        kamezawa.hiroyu@jp.fujitsu.com, seto.hidetoshi@jp.fujitsu.com,
        penberg@kernel.org, yinghai@kernel.org, tglx@linutronix.de,
        akpm@linux-foundation.org, ak@linux.intel.com, avi@redhat.com,
        dhowells@redhat.com, mingo@redhat.com, riel@redhat.com, cpw@sgi.com,
        steiner@sgi.com, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        hpa@zytor.com
Subject: Re: [PATCH v7 8/8] x86/tlb: just do tlb flush on one of siblings
 of SMT
References: <1337782555-8088-1-git-send-email-alex.shi@intel.com> <1337782555-8088-9-git-send-email-alex.shi@intel.com> <4FBD18D20200007800085951@nat28.tlf.novell.com> <1337792984.9783.37.camel@laptop> <1337793338.9783.38.camel@laptop> <CAObL_7GEzHYV9RbinPmK5D3DkZLiV0Wbz6j8x-Agbi21BM_OgA@mail.gmail.com>
In-Reply-To: <CAObL_7GEzHYV9RbinPmK5D3DkZLiV0Wbz6j8x-Agbi21BM_OgA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/24/2012 09:46 AM, Andrew Lutomirski wrote:

> On Wed, May 23, 2012 at 10:15 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>> On Wed, 2012-05-23 at 19:09 +0200, Peter Zijlstra wrote:
>>>> There is no comment or anything else indicating that this is
>>>> suitable for dual-thread CPUs only - when there are more than
>>>> 2 threads per core, the intended effect won't be achieved.
>>>
>>> Why would that be? Won't higher thread count still share the same
>>> resources just more so?
>>
>> Ah, I see, you're saying his code is buggy for >2 threads. Agreed.
>>
> 
> An evil knob to statically choose which SMT sibling gets the interrupt
> would be nice.  Then my compute-intensive thread could be (mostly)
> unaffected by the other thread on a different core that calls munmap
> frequently.


How to know we are in such situation? :)

> 
> --Andy


