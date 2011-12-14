Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932100Ab1LNPKO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 10:10:14 -0500
Received: from usindpps06.hds.com ([207.126.252.19]:56784 "EHLO
	usindpps06.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757403Ab1LNPKK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 10:10:10 -0500
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        Satoru Moriya <satoru.moriya@hds.com>
Date: Wed, 14 Dec 2011 10:09:11 -0500
Subject: RE: [PATCH 2/2] trace,x86: Add x86 irq vector entry/exit tracepoints
Thread-Topic: [PATCH 2/2] trace,x86: Add x86 irq vector entry/exit
 tracepoints
Thread-Index: Acy5zRUYU2YvExI4RMmlkL/GOCKZlwAorAIA
Message-ID: <5C4C569E8A4B9B42A84A977CF070A35B2C57F7A6D7@USINDEVS01.corp.hds.com>
References: <1311983978-10350-1-git-send-email-vnagarnaik@google.com>
 <1311983978-10350-3-git-send-email-vnagarnaik@google.com>
 <5C4C569E8A4B9B42A84A977CF070A35B2C57EE47BC@USINDEVS01.corp.hds.com>
 <20111213192556.GD2421@somewhere.redhat.com>
In-Reply-To: <20111213192556.GD2421@somewhere.redhat.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ja-JP, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=1 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1012030000
 definitions=main-1112140125
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you for giving me a comment.
Unfortunately, neither "perf record" nor "ftrace" works for me.

>What about using perf for that?
>
>Just run:
>
>	perf record -ag
>	^C
>	perf report
>
>And you should find in the callchains some informations about where your CPUs
>are spending time.
>
>If you system is too slow for that 

When system is too slow, user command such as "perf record" may not work.

>but you're doing background tracing with
>ftrace, you can use stacktrace with ftrace.

Actually, We're doing background tracing in our customer's system rather than kernel debugging. 
Ftrace doesn't work for me because it checks the size of the stack at every function call.
Our customers are seriously concerned about its overhead.

For reducing the overhead, I need tracepoints so we can hook minimal function calls.

Seiji
