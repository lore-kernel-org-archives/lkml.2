Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760556Ab1D1Q2U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 12:28:20 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:35780 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752780Ab1D1Q2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 12:28:18 -0400
X-Authority-Analysis: v=1.1 cv=qyUSAyc82z9xLljZQc9ErY9Tl2GSEfqK/XYZS35I9d8= c=1 sm=0 a=0i_OOtiXEx8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=RfCiLzTzPIp25TtctDUA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 3/7] seccomp_filter: Enable ftrace-based system call
 filtering
From: Steven Rostedt <rostedt@goodmis.org>
To: Will Drewry <wad@chromium.org>
Cc: linux-kernel@vger.kernel.org, kees.cook@canonical.com, eparis@redhat.com,
        agl@chromium.org, mingo@elte.hu, jmorris@namei.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Michal Marek <mmarek@suse.cz>, Oleg Nesterov <oleg@redhat.com>,
        Roland McGrath <roland@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Jiri Slaby <jslaby@suse.cz>,
        David Howells <dhowells@redhat.com>,
        "Serge E. Hallyn" <serge@hallyn.com>
In-Reply-To: <1303960136-14298-2-git-send-email-wad@chromium.org>
References: <1303960136-14298-1-git-send-email-wad@chromium.org>
	 <1303960136-14298-2-git-send-email-wad@chromium.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 28 Apr 2011 12:28:16 -0400
Message-ID: <1304008096.18763.151.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-27 at 22:08 -0500, Will Drewry wrote:

> The only other twist is that it is possible to delay enforcement by one
> system call by supplying a "on_next_syscall: 1" 'filter'.  This allows
> for a launcher process to fork(), prctl(), then execve() leaving the
> launched binary in a filtered state.

I wonder if the more "unixy" thing to do is, instead of on_next_sycall,
have "enable_on_exec". Where the user could do multiple syscalls but the
filter will not take place until an exec is made?

-- Steve


