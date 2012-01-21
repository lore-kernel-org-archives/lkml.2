Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751717Ab2AUF4N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 00:56:13 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43460 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891Ab2AUF4K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 00:56:10 -0500
MIME-Version: 1.0
In-Reply-To: <1327113843.7922.27.camel@yhuang-dev>
References: <1326415001-2145-1-git-send-email-ying.huang@intel.com>
	<CA+8MBbJHsOHb-COG_y36VYDA9EeTs3KpLc86kw1OhVF9Z_p7Jw@mail.gmail.com>
	<1326436352.8294.22.camel@yhuang-dev>
	<CA+8MBb+oqJZDYvmh8E6RB2MRp5fDj298Qjc4zs-rmyGkA4F3cw@mail.gmail.com>
	<1326676875.8294.30.camel@yhuang-dev>
	<20120120173427.GC3336@dhcp-172-17-108-109.mtv.corp.google.com>
	<1327113843.7922.27.camel@yhuang-dev>
Date: Fri, 20 Jan 2012 21:56:08 -0800
X-Google-Sender-Auth: x77Cr-zBYuzTYoDsmKn4yPRXMNg
Message-ID: <CAOS58YP-4=Tf61mDNBTgvnhpYbisTjDVjAVmDdxyrFDXwVN1cg@mail.gmail.com>
Subject: Re: x86, mce, Use user return notifier in mce
From: Tejun Heo <tj@kernel.org>
To: Huang Ying <ying.huang@intel.com>
Cc: Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Borislav Petkov <bp@amd64.org>,
        Chen Gong <gong.chen@linux.intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Jan 20, 2012 at 6:44 PM, Huang Ying <ying.huang@intel.com> wrote:
> It appears that WQ_HIGHPRI only provides priority between work queue,
> not between the work queue backing kthread and other tasks.  Is there
> any mechanism for that?

No, it doesn't.

> If my understanding was correct, WQ_MEM_RECLAIM has some side-effect for
> that.  Because hardware errors occurs seldom, the reserved kthread for
> WQ_MEME_RECLAIM just sleeps most of the time.  When first hardware error
> occurs and the work item is queued, the reserved kthread is waked up.
> Because the reserved kthread sleeps for long time, it is highly possible
> for it to be scheduled at the next schedule point.

But rescuer is used only under memory pressure. It doesn't help latency at all.

> Because hardware error usually has no locality, WQ_UNBOUND can be used
> for it so that the work item can be put on relative low-load CPU.  From
> the document, it is said WQ_UNBOUND work items will be executed ASAP
> too.  Compared with WQ_HIGHPRI, how about the priority of WQ_UNBOUND?

Maybe, maybe not. I suggest just using WQ_HIGHPRI for now and worrying
about it later if the scheduling latency actually turns out to matter.

Thanks.

-- 
tejun
