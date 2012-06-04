Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932188Ab2FDNql (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 09:46:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23317 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069Ab2FDNqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 09:46:40 -0400
X-Authority-Analysis: v=2.0 cv=T6AOvo2Q c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=_Lo7k97aeKoA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=TAzbHfMftfy36mQzijwA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1338817598.13348.497.camel@gandalf.stny.rr.com>
Subject: Re: [RFC] [PATCH 0/5] Teach perf tool to profile sleep times (V4)
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrew Vagin <avagin@openvz.org>, Arun Sharma <asharma@fb.com>,
        Oleg Strikov <OSTRIKOV@nvidia.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org
Date: Mon, 04 Jun 2012 09:46:38 -0400
In-Reply-To: <1338813658.28282.43.camel@twins>
References: <1338797382-287275-1-git-send-email-avagin@openvz.org>
	 <1338813658.28282.43.camel@twins>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-04 at 14:40 +0200, Peter Zijlstra wrote:

> The one thing I'm not entirely sure of is if this is a sekjoerity issue
> or not.. anybody? I would think a task was entitled to know who woke it
> and wherefrom etc..

"sekjoerity"? Sure, play games with us native English speakers, who
would pronounce that as "seek-joe-rity" and be totally confused :-p
Who's joe, and why are we seeking him?

Anyway, the answer is yes it is. Well, that's because *everything* in
the kernel is a security issue. Now the real question is, can someone
use it to do harm. Well, yes. But can they use it to do more harm than
they can with other methods that exist today? Probably not.

An attacker with an unprivileged account could probably analyze a system
with just 'ps', to figure out what they can and cannot do. Perhaps they
could use perf to analyze what other things are happening, and even set
up their tools to use perf to time attacks. A wakeup can tell a user if
they were blocked on a mutex, and who just let go of that mutex to wake
the user up.

Can this information be used to continue some other kind of attack?
Maybe. But is it a big enough risk that it outweighs the usefulness of
the tool? Probably not.

As I said earlier, all kernel issues deal with finding joe. But the
question is a simple matter of risk vs usability. If you want your
system to be really secure, then lock it in a vault and do not allow
anything to connect to it. That is minimizing risk, but at the cost of
usability.

If a sysadmin doesn't want this open, then just have them keep the
paranoid level up for activating perf, and do not let users run it.

-- Steve


