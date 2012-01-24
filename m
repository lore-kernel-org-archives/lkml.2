Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756832Ab2AXOk3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 09:40:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44231 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750885Ab2AXOk1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 09:40:27 -0500
Message-ID: <4F1EC2BA.90403@redhat.com>
Date: Tue, 24 Jan 2012 16:39:54 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Tony Luck <tony.luck@intel.com>
CC: Huang Ying <ying.huang@intel.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Borislav Petkov <bp@amd64.org>,
        Chen Gong <gong.chen@linux.intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: x86, mce, Use user return notifier in mce
References: <1326415001-2145-1-git-send-email-ying.huang@intel.com> <CA+8MBbJHsOHb-COG_y36VYDA9EeTs3KpLc86kw1OhVF9Z_p7Jw@mail.gmail.com> <1326436352.8294.22.camel@yhuang-dev> <CA+8MBb+oqJZDYvmh8E6RB2MRp5fDj298Qjc4zs-rmyGkA4F3cw@mail.gmail.com>
In-Reply-To: <CA+8MBb+oqJZDYvmh8E6RB2MRp5fDj298Qjc4zs-rmyGkA4F3cw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2012 09:41 AM, Tony Luck wrote:
> On Thu, Jan 12, 2012 at 10:32 PM, Huang Ying <ying.huang@intel.com> wrote:
> > You are right.  User return notifier can not be used for SRAR.  I think
> > that may be useful for SRAO.  Where we need a way to do notify earlier
> > in case of the corresponding work_queue item is not executed in time.
>
> OK - I've been so focused on SRAR that I didn't think of the SRAO case.
> But even there it seems odd to use user return notifier. We'd like the
> SRAO work item to be executed promptly - but we don't care where it
> is executed. So the "execute on this cpu" part of user return notifiers
> doesn't quite fit.
>

Also, nothing bounds the time until a urn executes.  If the cpu stays in
the kernel forever, it will never fire.

-- 
error compiling committee.c: too many arguments to function

