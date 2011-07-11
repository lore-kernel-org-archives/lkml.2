Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932140Ab1GKHeI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 03:34:08 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:64932 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757207Ab1GKHeH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 03:34:07 -0400
MIME-Version: 1.0
In-Reply-To: <1310333145.2269.6.camel@gandalf.stny.rr.com>
References: <AtAvQwe5sAK.A.loH.OlYGOB@chimera>
	<gK_efVqs2fP.A.Y3H.jlYGOB@chimera>
	<CAOJsxLEGqpcQP3S+TLBjpRsM=UTk=zyuHBoswXkVwbHsLaDqqg@mail.gmail.com>
	<1310333145.2269.6.camel@gandalf.stny.rr.com>
Date: Mon, 11 Jul 2011 10:34:05 +0300
X-Google-Sender-Auth: wyFeIoXN72uWTUQkphOz3wVetn4
Message-ID: <CAOJsxLHitazDJEjiD3j_nK_4hQoiGVo_08NP_nR3FpCTqa4HwQ@mail.gmail.com>
Subject: Re: [Bug #38132] [Warning] 2.6.39.x latencytop
From: Pekka Enberg <penberg@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Andrew Watts <akwatts@ymail.com>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arjan van de Ven <arjan@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 11, 2011 at 12:25 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Sun, 2011-07-10 at 14:53 +0300, Pekka Enberg wrote:
>> On Sun, Jul 10, 2011 at 1:58 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> > This message has been generated automatically as a part of a report
>> > of regressions introduced between 2.6.38 and 2.6.39.
>> >
>> > The following bug entry is on the current list of known regressions
>> > introduced between 2.6.38 and 2.6.39.  Please verify if it still should
>> > be listed and let the tracking team know (either way).
>> >
>> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=38132
>> > Subject         : [Warning] 2.6.39.x latencytop
>> > Submitter       : Andrew Watts <akwatts@ymail.com>
>> > Date            : 2011-06-14 17:07 (27 days old)
>> > Message-ID      : <80098.5633.qm@web111013.mail.gq1.yahoo.com>
>> > References      : http://marc.info/?l=linux-kernel&m=130807128506490&w=2
>>
>> This is a WARN_ON added in commit 6752ab4a ("tracing: Deprecate
>> tracing_enabled for tracing_on") that lets the user know about
>> deprecated ABI. It's somewhat unfortunate that there's no mention in
>> the changelog if everyone agreed on the deprecation or not...
>>
>> That said, assuming the deprecation is OK (hi Steven, Frederic, Ingo!)
>> I think this issue can be closed.
>
> I deprecated it because I said I would for the last year ;)
>
> The tracing_enabled never did what it was suppose to do. It was suppose
> to be a "quick" way to disable tracing without fully disabling it. It
> was suppose to try to turn things off to a low overhead but not fully
> off without any overhead. The problem is that it never really worked
> well. The only tracer that does anything different with it as suppose to
> tracing_on, is the irqsoff tracers. They stop looking at max latencies
> when you echo 0 into tracing_enabled. But that's it. Everything else,
> it's just the same as echoing 0 into tracing_on. I think the irqsoff
> tracers now even look at tracing_on if it should trace a max latency or
> not, so tracing_enabled doesn't even help with that.
>
> We can keep it around but I don't see any good reason for it besides not
> having latency top give a warning.

AFAICT, if you go ahead with the deprecation and actually remove the
file, you'll break latencytop fsync tracing.

On Mon, Jul 11, 2011 at 12:25 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> Question: Why is latency top even touching this file?

Looking at the sources, it seems to use it to enable fsync tracing. I
don't know the details so lets CC Arjan.
