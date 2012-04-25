Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758813Ab2DYCol (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 22:44:41 -0400
Received: from mga02.intel.com ([134.134.136.20]:22660 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758014Ab2DYCok (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 22:44:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="133484314"
Message-ID: <1335321899.14538.105.camel@ymzhang.sh.intel.com>
Subject: Re: [RFC 1/2] kernel patch for dump user space stack tool
From: Yanmin Zhang <yanmin_zhang@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Cong Wang <xiyou.wangcong@gmail.com>,
        "Tu, Xiaobing" <xiaobing.tu@intel.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "Zuo, Jiao" <jiao.zuo@intel.com>
Date: Wed, 25 Apr 2012 10:44:59 +0800
In-Reply-To: <1335262311.28150.192.camel@twins>
References: <EE928378561BF1449699C96571234A740FCE3704@SHSMSX102.ccr.corp.intel.com>
	 <1334915073.2463.36.camel@laptop>
	 <1335231007.14538.71.camel@ymzhang.sh.intel.com>
	 <1335262311.28150.192.camel@twins>
Organization: MCG
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-04-24 at 12:11 +0200, Peter Zijlstra wrote:
> On Tue, 2012-04-24 at 09:30 +0800, Yanmin Zhang wrote:
> > Would you like to point out the workable userspace stack walker?
> > If there is, we would check if we could reuse it.
> > 
> > 
> arch/x86/kernel/cpu/perf_event.c:perf_callchain_user(), it also deals
> with compat stuffs.
Yes, it does. But it just collects the user stack call chain of
_current_ task.

When Xiaobing worked out the patch, we did think over if we could implement
it based on perf. We also checked ftrace. Both ftrace and perf collect
user stack of _current_ task.

Xiaobing wrote a similar tool based on ptrace one year ago and gave it up
as it was slow.

I was thinking if we could use the powerful symbol parsing capability of
perf to do the user space parse. I was busy and Xiaobing just changed
his old codes to work out a prototype quickly as other developers pushed hard
for the tool.

Yanmin


