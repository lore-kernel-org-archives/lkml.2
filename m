Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698Ab2IUNFb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 09:05:31 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59514 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754014Ab2IUNFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 09:05:30 -0400
Message-ID: <505C6617.4010801@gmail.com>
Date: Fri, 21 Sep 2012 07:05:27 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Pekka Enberg <penberg@kernel.org>, Irina Tirdea <irina.tirdea@gmail.com>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Irina Tirdea <irina.tirdea@intel.com>
Subject: Re: [PATCH 1/4] perf tools: configure tmp path at build time
References: <1348179215-11160-1-git-send-email-irina.tirdea@gmail.com> <1348179215-11160-2-git-send-email-irina.tirdea@gmail.com> <CAOJsxLHYZyGkORudmXd5+f3_NBXTh7rmDC-Cw3=06vyVk7WZaA@mail.gmail.com>
In-Reply-To: <CAOJsxLHYZyGkORudmXd5+f3_NBXTh7rmDC-Cw3=06vyVk7WZaA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/21/12 1:47 AM, Pekka Enberg wrote:

>> diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
>> index e2e8c69..eb671d5 100644
>> --- a/tools/perf/util/symbol.c
>> +++ b/tools/perf/util/symbol.c
>> @@ -1051,7 +1051,7 @@ int dso__load(struct dso *dso, struct map *map, symbol_filter_t filter)
>>
>>          dso->adjust_symbols = 0;
>>
>> -       if (strncmp(dso->name, "/tmp/perf-", 10) == 0) {
>> +       if (strncmp(dso->name, PERF_TMP_DIR "/perf-", 10) == 0) {
>>                  struct stat st;

And, with "/tmp" as a variable the 10 in the strncmp might not be right.

David

