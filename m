Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754942Ab2HHBQE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 21:16:04 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:47181 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788Ab2HHBQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 21:16:02 -0400
X-AuditID: 9c930197-b7b66ae000006a2c-53-5021bdd08511
From: Namhyung Kim <namhyung@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 1/2] perf tools: Initial bash completion support
References: <1344358801-16383-1-git-send-email-fweisbec@gmail.com>
	<1344358801-16383-2-git-send-email-fweisbec@gmail.com>
	<5021926E.2070202@gmail.com>
Date: Wed, 08 Aug 2012 10:10:02 +0900
In-Reply-To: <5021926E.2070202@gmail.com> (David Ahern's message of "Tue, 07
	Aug 2012 16:10:54 -0600")
Message-ID: <87ipcuyys5.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 07 Aug 2012 16:10:54 -0600, David Ahern wrote:
> On 8/7/12 11:00 AM, Frederic Weisbecker wrote:
>> diff --git a/tools/perf/Makefile b/tools/perf/Makefile
>> index 35655c3..ddfb7e5 100644
>> --- a/tools/perf/Makefile
>> +++ b/tools/perf/Makefile
>> @@ -951,6 +951,7 @@ install: all
>>   	$(INSTALL) scripts/python/Perf-Trace-Util/lib/Perf/Trace/* -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/python/Perf-Trace-Util/lib/Perf/Trace'
>>   	$(INSTALL) scripts/python/*.py -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/python'
>>   	$(INSTALL) scripts/python/bin/* -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/python/bin'
>> +	$(INSTALL) -m 755 bash_completion $(DESTDIR_SQ)/etc/bash_completion.d/perf
>
> still getting an error here:
>
> $ make DESTDIR=/tmp/junk-perf O=/tmp/pbuild -C tools/perf/ install
> ...
> install -m 755 bash_completion /tmp/junk-perf/etc/bash_completion.d/perf
> install: cannot create regular file
> /tmp/junk-perf/etc/bash_completion.d/perf': No such file or directory
> make: *** [install] Error 1
> make: Leaving directory `/opt/sw/ahern/perf.git/tools/perf'

Does patch below fix it?


diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index cfe4fc0b67f1..d0b27ba9663e 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -696,6 +696,7 @@ perfexecdir_SQ = $(subst ','\'',$(perfexecdir))
 template_dir_SQ = $(subst ','\'',$(template_dir))
 htmldir_SQ = $(subst ','\'',$(htmldir))
 prefix_SQ = $(subst ','\'',$(prefix))
+sysconfdir_SQ = $(subst ','\'',$(sysconfdir))
 
 SHELL_PATH_SQ = $(subst ','\'',$(SHELL_PATH))
 
@@ -947,7 +948,8 @@ install: all
 	$(INSTALL) scripts/python/Perf-Trace-Util/lib/Perf/Trace/* -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/python/Perf-Trace-Util/lib/Perf/Trace'
 	$(INSTALL) scripts/python/*.py -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/python'
 	$(INSTALL) scripts/python/bin/* -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/python/bin'
-	$(INSTALL) -m 755 bash_completion $(DESTDIR_SQ)/etc/bash_completion.d/perf
+	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(sysconfdir_SQ)/bash_completion.d'
+	$(INSTALL) bash_completion '$(DESTDIR_SQ)$(sysconfdir_SQ)/bash_completion.d/perf'
 
 install-python_ext:
 	$(PYTHON_WORD) util/setup.py --quiet install --root='/$(DESTDIR_SQ)'
