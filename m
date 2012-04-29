Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752952Ab2D2OAS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 10:00:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:12174 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617Ab2D2OAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 10:00:16 -0400
X-Authority-Analysis: v=2.0 cv=bcnpoZzB c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=0JHAPgXzDBkA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=8kvYEkFOWdQmcfmSM5gA:9 a=PUjeQqilurYA:10 wl=env:18 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1335708011.28106.245.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 01/14] sysctl: provide callback for write into ctl_table
 entry
From: Steven Rostedt <rostedt@goodmis.org>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, viro@zeniv.linux.org.uk,
        fweisbec@gmail.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        paulus@samba.org, acme@ghostprotocols.net, james.l.morris@oracle.com,
        akpm@linux-foundation.org, tglx@linutronix.de,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-security-module@vger.kernel.org
Date: Sun, 29 Apr 2012 10:00:11 -0400
In-Reply-To: <CA+1xoqfX3hc7FP+8_9sn_mt4_WHkVfqTiPnE79Brs_kAfAFPCQ@mail.gmail.com>
References: <1335681937-3715-1-git-send-email-levinsasha928@gmail.com>
	 <m1haw33q35.fsf@fess.ebiederm.org>
	 <CA+1xoqfX3hc7FP+8_9sn_mt4_WHkVfqTiPnE79Brs_kAfAFPCQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-04-29 at 14:07 +0200, Sasha Levin wrote:
> On Sun, Apr 29, 2012 at 10:22 AM, Eric W. Biederman

> Exactly twp of the patches (out of 14) are taking updates out of
> locks. I'm quite sure that doing that in the ftrace case is perfectly
> fine, and I'll take a second look at the sched-rt one since there
> indeed might be a race caused due to the patch that I've missed.

The update of ftrace_enable must be done under the ftrace_lock mutex.
With the exception of ftrace_kill() which is a one shot deal that kills
ftrace updates until a reboot.

-- Steve


