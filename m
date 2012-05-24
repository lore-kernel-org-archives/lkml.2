Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755072Ab2EXJqV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 05:46:21 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:50025 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754359Ab2EXJqU convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:18:1>);
	Thu, 24 May 2012 05:46:20 -0400
Message-Id: <4FBE1FAA0200007800085CC4@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Thu, 24 May 2012 10:46:50 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Alex Shi" <alex.shi@intel.com>
Cc: <borislav.petkov@amd.com>, <arnd@arndb.de>,
        "Peter Zijlstra" <a.p.zijlstra@chello.nl>, <akinobu.mita@gmail.com>,
        <eric.dumazet@gmail.com>, <fweisbec@gmail.com>, <rostedt@goodmis.org>,
        <hughd@google.com>, <jeremy@goop.org>, <len.brown@intel.com>,
        <tony.luck@intel.com>, <yongjie.ren@intel.com>,
        <kamezawa.hiroyu@jp.fujitsu.com>, <seto.hidetoshi@jp.fujitsu.com>,
        <penberg@kernel.org>, <yinghai@kernel.org>, <tglx@linutronix.de>,
        <akpm@linux-foundation.org>, <ak@linux.intel.com>, <luto@mit.edu>,
        <avi@redhat.com>, <dhowells@redhat.com>, <mingo@redhat.com>,
        <riel@redhat.com>, "Rusty Russell" <rusty@rustcorp.com.au>,
        <cpw@sgi.com>, <steiner@sgi.com>, <linux-kernel@vger.kernel.org>,
        <viro@zeniv.linux.org.uk>, <hpa@zytor.com>
Subject: Re: [PATCH v7 8/8] x86/tlb: just do tlb flush on one of
 siblings of SMT
References: <1337782555-8088-1-git-send-email-alex.shi@intel.com>
 <1337782555-8088-9-git-send-email-alex.shi@intel.com>
 <4FBD18D20200007800085951@nat28.tlf.novell.com>
 <1337792984.9783.37.camel@laptop> <4FBDF200.7060608@intel.com>
 <1337848970.9783.72.camel@laptop> <4FBDFF11.7030105@intel.com>
In-Reply-To: <4FBDFF11.7030105@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 24.05.12 at 11:27, Alex Shi <alex.shi@intel.com> wrote:
> On 05/24/2012 04:42 PM, Peter Zijlstra wrote:
> 
>> On Thu, 2012-05-24 at 16:32 +0800, Alex Shi wrote:
>>> So, I use cpumask_t in stack.
>> 
>> cpumask_t is 512 bytes with NR_CPUS=4096, that's generally considered
>> too big to be on stack.
> 
> 
> I am not consistent with cpumask_t.
> I just want to know why it is too big on stack? Since if it causes
> trouble in using, that mean current kernel will fail to run on 4096 CPU
> system.

Why? Did you spot critical left-over instances of on-stack
cpumask_t-s anywhere?

Jan

