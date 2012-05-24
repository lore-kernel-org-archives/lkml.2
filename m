Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569Ab2EXJm5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 05:42:57 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45542 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161Ab2EXJm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 05:42:56 -0400
Subject: Re: [PATCH v7 8/8] x86/tlb: just do tlb flush on one of siblings
 of SMT
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Alex Shi <alex.shi@intel.com>
Cc: Jan Beulich <JBeulich@suse.com>, borislav.petkov@amd.com, arnd@arndb.de,
        akinobu.mita@gmail.com, eric.dumazet@gmail.com, fweisbec@gmail.com,
        rostedt@goodmis.org, hughd@google.com, jeremy@goop.org,
        len.brown@intel.com, tony.luck@intel.com, yongjie.ren@intel.com,
        kamezawa.hiroyu@jp.fujitsu.com, seto.hidetoshi@jp.fujitsu.com,
        penberg@kernel.org, yinghai@kernel.org, tglx@linutronix.de,
        akpm@linux-foundation.org, ak@linux.intel.com, luto@mit.edu,
        avi@redhat.com, dhowells@redhat.com, mingo@redhat.com, riel@redhat.com,
        cpw@sgi.com, steiner@sgi.com, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, hpa@zytor.com,
        Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <4FBDFF11.7030105@intel.com>
References: <1337782555-8088-1-git-send-email-alex.shi@intel.com>
	 <1337782555-8088-9-git-send-email-alex.shi@intel.com>
	 <4FBD18D20200007800085951@nat28.tlf.novell.com>
	 <1337792984.9783.37.camel@laptop>  <4FBDF200.7060608@intel.com>
	 <1337848970.9783.72.camel@laptop>  <4FBDFF11.7030105@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 May 2012 11:42:49 +0200
Message-ID: <1337852569.9783.88.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-24 at 17:27 +0800, Alex Shi wrote:

> I just want to know why it is too big on stack? Since if it causes
> trouble in using, that mean current kernel will fail to run on 4096 CPU
> system.

Because the stack is only 8k or so. If you add functions with 512+ bytes
of footprint you're done very very quickly indeed.

Now if you were able to build a call-graph using a static analysis tool
and were able to weight each edge with the stack usage of every
function, finding the actual max stack would be doable. Lacking this its
a matter of policy and 'luck'.

Our policy is to use as little stack as possible and 512 bytes is
definitely out.

Our 'luck' is that every so often people over-run their stack and we get
to spend time on figuring out wtf happened.

