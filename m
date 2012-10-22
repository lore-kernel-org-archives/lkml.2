Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751095Ab2JVHM2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 03:12:28 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:44287 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1749667Ab2JVHM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 03:12:27 -0400
X-AuditID: 9c930179-b7c8bae000003559-5b-5084f1d79318
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Stephane Eranian <eranian@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        "mingo\@elte.hu" <mingo@elte.hu>, David Ahern <dsahern@gmail.com>
Subject: Re: [BUG] perf list: --help option not implemented
References: <CABPqkBS9Wm2c=fnaQzKycXnuqRtAocAZ4qQ7ToAaaVDQbtVoyA@mail.gmail.com>
	<20121019084636.GB980@krava.brq.redhat.com>
Date: Mon, 22 Oct 2012 16:12:23 +0900
In-Reply-To: <20121019084636.GB980@krava.brq.redhat.com> (Jiri Olsa's message
	of "Fri, 19 Oct 2012 10:46:36 +0200")
Message-ID: <87r4orj7zc.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 19 Oct 2012 10:46:36 +0200, Jiri Olsa wrote:
> On Fri, Oct 19, 2012 at 10:27:35AM +0200, Stephane Eranian wrote:
>> Jiri,
>> 
>> When I run perf list, I see:
>> 
>> $ perf list
>>   ..
>>   rNNN                                               [Raw hardware
>> event descriptor]
>>   cpu/t1=v1[,t2=v2,t3 ...]/modifier                  [Raw hardware
>> event descriptor]
>>    (see 'perf list --help' on how to encode it)
>> 
>> But:
>> $ perf list --help
>> $
>> 
>> Shows nothing. Looked at the code and I don't see where you handle the --help
>> option. You need some help to figure out what the modifiers are.
>> 
>> Am I missing something here?
>
> nope, it's not working.. added on my todo list ;-)

I think it worked.

It seems that commit cc5848213329 ("perf help: Remove use of die and
handle errors") caused the problem - it changed the initial value of
'help_format' from HELP_FORMAT_MAN to HELP_FORMAT_NONE.

The following patch works well for me:

diff --git a/tools/perf/builtin-help.c b/tools/perf/builtin-help.c
index 411ee5664e98..178b88ae3d2f 100644
--- a/tools/perf/builtin-help.c
+++ b/tools/perf/builtin-help.c
@@ -414,7 +414,7 @@ static int show_html_page(const char *perf_cmd)
 int cmd_help(int argc, const char **argv, const char *prefix __maybe_unused)
 {
 	bool show_all = false;
-	enum help_format help_format = HELP_FORMAT_NONE;
+	enum help_format help_format = HELP_FORMAT_MAN;
 	struct option builtin_help_options[] = {
 	OPT_BOOLEAN('a', "all", &show_all, "print all available commands"),
 	OPT_SET_UINT('m', "man", &help_format, "show man page", HELP_FORMAT_MAN),
