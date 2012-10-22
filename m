Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751756Ab2JVHjN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 03:39:13 -0400
Received: from mail-ia0-f174.google.com ([209.85.210.174]:34288 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979Ab2JVHjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 03:39:12 -0400
MIME-Version: 1.0
In-Reply-To: <20121016151817.GB6807@ghostprotocols.net>
References: <1350344020-8071-1-git-send-email-irina.tirdea@gmail.com>
 <1350344020-8071-2-git-send-email-irina.tirdea@gmail.com> <20121016151817.GB6807@ghostprotocols.net>
From: Irina Tirdea <irina.tirdea@gmail.com>
Date: Mon, 22 Oct 2012 10:38:52 +0300
Message-ID: <CANg8OWLNwvrc7Zsknv3wOg_snKuUx7_THeg0jUK3vcXHYOM41w@mail.gmail.com>
Subject: Re: [PATCH v4 1/6] perf tools: configure tmp path at build time
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        David Ahern <dsahern@gmail.com>, Namhyung Kim <namhyung@kernel.org>,
        Pekka Enberg <penberg@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Irina Tirdea <irina.tirdea@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2012 at 6:18 PM, Arnaldo Carvalho de Melo
<acme@ghostprotocols.net> wrote:
> Em Tue, Oct 16, 2012 at 02:33:35AM +0300, Irina Tirdea escreveu:
>> From: Irina Tirdea <irina.tirdea@intel.com>
>>
>> Temporary perf files are hardcoded to point to /tmp. Android does not have
>> a /tmp directory so it needs to set this path at compile time.
>>
>> Add a compile-time definition (PERF_TMP_DIR) in the Makefile that sets the path
>> to temp directory. By default it points to /tmp.
>>
>>  $(OUTPUT)util/parse-events.o: $(OUTPUT)util/parse-events-flex.c $(OUTPUT)util/parse-events-bison.c
>> -$(OUTPUT)util/pmu.o: $(OUTPUT)util/pmu-flex.c $(OUTPUT)util/pmu-bison.c
>> +$(OUTPUT)util/pmu.o: util/pmu.c $(OUTPUT)util/pmu-flex.c $(OUTPUT)util/pmu-bison.c $(OUTPUT)PERF-CFLAGS
>> +     $(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DPERF_TMP_DIR='"$(PERF_TMP_DIR)"' $<
>>
>>  LIB_FILE=$(OUTPUT)libperf.a
>>
>> @@ -889,6 +892,21 @@ $(OUTPUT)util/exec_cmd.o: util/exec_cmd.c $(OUTPUT)PERF-CFLAGS
>>  $(OUTPUT)util/config.o: util/config.c $(OUTPUT)PERF-CFLAGS
>>       $(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
>
> Humm, so we need to add an specific rule for each source file that needs
> PERF_TMP_DIR? Why not make it available to all source files?
>

I've seen this is the way other defines are handled (PERF_HTML_PATH,
PERF_INFO_PATH, etc). But PERF_TMP_DIR is used in more places so it
makes sense to make it available to all source files. I'll make the
changes (for both PERF_TMP_DIR and PERF_SHELL_PATH) and resubmit.

>> +$(OUTPUT)util/dso-test-data.o: util/dso-test-data.c $(OUTPUT)PERF-CFLAGS
>> +     $(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DPERF_TMP_DIR='"$(PERF_TMP_DIR)"' $<
>> +
>> +$(OUTPUT)util/map.o: util/map.c $(OUTPUT)PERF-CFLAGS
>> +     $(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DPERF_TMP_DIR='"$(PERF_TMP_DIR)"' $<
>> +
>> +$(OUTPUT)util/symbol.o: util/symbol.c $(OUTPUT)PERF-CFLAGS
>> +     $(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DPERF_TMP_DIR='"$(PERF_TMP_DIR)"' $<
>> +
>> +$(OUTPUT)util/trace-event-info.o: util/trace-event-info.c $(OUTPUT)PERF-CFLAGS
>> +     $(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DPERF_TMP_DIR='"$(PERF_TMP_DIR)"' $<
>> +
>> +$(OUTPUT)util/vdso.o: util/vdso.c $(OUTPUT)PERF-CFLAGS
>> +     $(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DPERF_TMP_DIR='"$(PERF_TMP_DIR)"' $<
>> +
>>  $(OUTPUT)ui/browser.o: ui/browser.c $(OUTPUT)PERF-CFLAGS
>>       $(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DENABLE_SLFUTURE_CONST $<
>>

Thanks,
Irina
