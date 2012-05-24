Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755354Ab2EXNXm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 09:23:42 -0400
Received: from merlin.infradead.org ([205.233.59.134]:59872 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753352Ab2EXNXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 09:23:41 -0400
Subject: Re: [PATCH v7 8/8] x86/tlb: just do tlb flush on one of siblings
 of SMT
From: Peter Zijlstra <peterz@infradead.org>
To: Andrew Lutomirski <luto@mit.edu>
Cc: Jan Beulich <JBeulich@suse.com>, Alex Shi <alex.shi@intel.com>,
        borislav.petkov@amd.com, arnd@arndb.de, akinobu.mita@gmail.com,
        eric.dumazet@gmail.com, fweisbec@gmail.com, rostedt@goodmis.org,
        hughd@google.com, jeremy@goop.org, len.brown@intel.com,
        tony.luck@intel.com, yongjie.ren@intel.com,
        kamezawa.hiroyu@jp.fujitsu.com, seto.hidetoshi@jp.fujitsu.com,
        penberg@kernel.org, yinghai@kernel.org, tglx@linutronix.de,
        akpm@linux-foundation.org, ak@linux.intel.com, avi@redhat.com,
        dhowells@redhat.com, mingo@redhat.com, riel@redhat.com, cpw@sgi.com,
        steiner@sgi.com, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        hpa@zytor.com, Arjan Van De Ven <arjan@linux.intel.com>
In-Reply-To: <CAObL_7FK8Pb7Ahmr0SBaPg1BvPTspr=EKG8v_QfcpdmMyuE5dA@mail.gmail.com>
References: <1337782555-8088-1-git-send-email-alex.shi@intel.com>
	 <1337782555-8088-9-git-send-email-alex.shi@intel.com>
	 <4FBD18D20200007800085951@nat28.tlf.novell.com>
	 <1337792984.9783.37.camel@laptop> <1337793338.9783.38.camel@laptop>
	 <CAObL_7GEzHYV9RbinPmK5D3DkZLiV0Wbz6j8x-Agbi21BM_OgA@mail.gmail.com>
	 <1337845230.9783.51.camel@laptop>
	 <CAObL_7FK8Pb7Ahmr0SBaPg1BvPTspr=EKG8v_QfcpdmMyuE5dA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 May 2012 15:23:31 +0200
Message-ID: <1337865811.9783.152.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-24 at 06:19 -0700, Andrew Lutomirski wrote:
> 
> A decent heuristic might be to prefer idle SMT siblings for TLB
> invalidation.  I don't know what effect that would have on power
> consumption (it would be rather bad if idling one SMT thread while the
> other one is busy saves much power). 

Right, I've never really understood how C-states and SMT go together.
Arjan recently implied waking a thread sibling from C-state was
'expensive' which on first thought seems daft, the core is running
already.



