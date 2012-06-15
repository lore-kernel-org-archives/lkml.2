Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758180Ab2FOWS0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 18:18:26 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62906 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758050Ab2FOWSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 18:18:25 -0400
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 3/3] tools lib traceevent: Introduce pevent_strerror
References: <1339486959-25241-1-git-send-email-namhyung@kernel.org>
	<1339486959-25241-4-git-send-email-namhyung@kernel.org>
	<1339524114.13377.140.camel@gandalf.stny.rr.com>
	<87ehpj6hic.fsf@sejong.aot.lge.com>
	<1339730825.13377.311.camel@gandalf.stny.rr.com>
	<87ipet3pzf.fsf@sejong.aot.lge.com>
	<1339763129.13377.357.camel@gandalf.stny.rr.com>
Date: Sat, 16 Jun 2012 07:18:15 +0900
In-Reply-To: <1339763129.13377.357.camel@gandalf.stny.rr.com> (Steven
	Rostedt's message of "Fri, 15 Jun 2012 08:25:29 -0400")
Message-ID: <87pq9043tk.fsf@gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt <rostedt@goodmis.org> writes:
> On Fri, 2012-06-15 at 18:04 +0900, Namhyung Kim wrote:
>> > If you need the code to be thread safe, have all errors do:
>> >
>> > 	ret = pevent_foo();
>> > 	if (ret < 0) {
>> > 		pevent_strerr_val(ret, buf, buflen);
>> >
>> >
>> > For programs that do not need to be thread safe, then:
>> >
>> > 	ret = pevent_foo();
>> > 	if (ret < 0) {
>> > 		pevent_strerr(pevent, buf, buflen);
>> >
>> 
>> Do we really need these two? I think having a single API is just
>> enough, IMHO.
>
> Hmm, maybe not. I guess I was confused about the need to pass the pevent
> into the function. I think we only need the return val. Or is there
> other data in the future that you envision will require needing pevent
> passed in?
>

I was thinking about a way to provide additional information in case of
a parse error by saving them into the pevent. But it turned out to make
the API non-thread-safe. :/ I couldn't find a good way yet.

So, for now, passing the return value only would be enough. But I think
passing pevent into a function name started by pevent_ looks natural. :)

Thanks,
Namhyung

