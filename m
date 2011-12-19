Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616Ab1LSR2Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 12:28:25 -0500
Received: from usindpps03.hds.com ([207.126.252.16]:58147 "EHLO
	usindpps03.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974Ab1LSR2X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 12:28:23 -0500
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Oleg Nesterov <oleg@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Masami Hiramatsu <mhiramat@redhat.com>,
        Seiji Aguchi <saguchi@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 19 Dec 2011 12:28:11 -0500
Subject: RE: [PATCH RESEND 0/2] tracing: signal tracepoints
Thread-Topic: [PATCH RESEND 0/2] tracing: signal tracepoints
Thread-Index: Acy+cTduINjcLlqdRj+e5pwaIvu/pwAAODmg
Message-ID: <5C4C569E8A4B9B42A84A977CF070A35B2C57FFA27F@USINDEVS01.corp.hds.com>
References: <20111121191920.GA24883@redhat.com>
 <1321905799.20742.20.camel@frodo> <20111121202110.GA27966@redhat.com>
 <1321912356.20742.24.camel@frodo> <20111122205239.GA20971@redhat.com>
 <1322848385.30977.50.camel@frodo> <20111219170447.GA31981@redhat.com>
In-Reply-To: <20111219170447.GA31981@redhat.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ja-JP, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=8 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1012030000
 definitions=main-1112190171
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thanks, Oleg.

This patchset is helpful for me.

When some applications fail to send signal, our customers sometimes ask its reason to us.
With this patchset, we can know behavior of signal event in detail and explain it to them.

Seiji

>-----Original Message-----
>From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Oleg Nesterov
>Sent: Monday, December 19, 2011 12:05 PM
>To: Steven Rostedt; Ingo Molnar; Andrew Morton
>Cc: Frederic Weisbecker; Jiri Olsa; Masami Hiramatsu; Seiji Aguchi; linux-kernel@vger.kernel.org
>Subject: [PATCH RESEND 0/2] tracing: signal tracepoints
>
>Steven, sorry for delay...
>
>On 12/02, Steven Rostedt wrote:
>>
>> On Tue, 2011-11-22 at 21:52 +0100, Oleg Nesterov wrote:
>> >
>> > > Is "result" used for anything but tracepoints? When tracing is disabled,
>> > > the tracepoints should be just nops (when jump_label is enabled). Thus
>> > > tracing is very light. But if we are constantly calculating "result",
>> > > this is unused by those that don't use the tracing infrastructure, which
>> > > is 99.99% of all users. This is what I meant.
>> >
>> > Ah I see. I thought you dislike OVERFLOW_FAIL/LOSE_INFO namely.
>> >
>> > Of course, you are right. OTOH, this patch shaves 1058 bytes from
>> > .text. And without CONFIG_TRACE* gcc doesn't generate the extra code.
>>
>> I was just noting that when tracing is disabled (CONFIG_TRACE* is set,
>> like it is on distros, but tracing is not happening), that we have extra
>> code. We usually strive to have tracing configured into the kernel, but
>> produces no (actually as little as possible) overhead when not actively
>> tracing.
>
>Yes, yes, I see. But I do not see any alternative. Of course, instead
>of adding "int result" we could add more trace_signal_generate's into
>the code, but imho this is too ugly. And in fact I am not sure this
>means less overhead with CONFIG_TRACE* even if this code is nop'ed.
>
>> That said, you know this code much more than I do. If this isn't a fast
>> path, and spinning a few more CPU cycles and perhaps dirtying a few
>> cache lines floats your boat. I'm OK with this change.
>
>I simply do not know. I _think_ that the overhead is negligible, the
>extra calculating just adds a couple of "mov CONSTANT, REGISTER" insns.
>
>> > Oh. I simply do not know what can I do. Obviously, I'd like to avoid
>> > the new tracepoints in __send_signal(), imho this would be ugly. But
>> > the users want more info.
>> >
>> > OK. let me send the patch at least for review. May be someone will
>> > nack it authoritatively, in this case I can relax and forward the
>> > nack back to bugzilla ;)
>>
>> Again, if you don't think adding very slight overhead to this path is an
>> issue. Go ahead and add it.
>
>OK, thanks.
>
>The next question is, how can I add it ;) May be Ingo or Andrew could
>take these patches? Original signal tracepoints were routed via tip-tree...
>
>Add them both to TO:, lets see who is kinder.
>
>
>> > However, at least 2/2 looks very reasonable to me. In fact it looks
>> > almost like the bug-fix.
>>
>> 2/2 looks to have the extra overhead to. Is the bug fix just with the
>> trace point.
>>
>> Again, if you don't mind the overhead, then here:
>>
>> Acked-by: Steven Rostedt <rostedt@goodmis.org>
>
>Thanks, included.
>
>Oleg.
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/
