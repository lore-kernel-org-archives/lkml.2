Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757660Ab2HHWiE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 18:38:04 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:36865 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757185Ab2HHWiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 18:38:03 -0400
Message-ID: <5022EA1E.3010306@fb.com>
Date: Wed, 8 Aug 2012 15:37:18 -0700
From: Arun Sharma <asharma@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Namhyung Kim <namhyung.kim@lge.com>, Tom Zanussi <tzanussi@gmail.com>,
        <linux-perf-users@vger.kernel.org>
Subject: Re: [PATCH] perf: Add a new sort order: SORT_INCLUSIVE (v6)
References: <1333172421-6775-2-git-send-email-asharma@fb.com> <4F769976.3070203@fb.com> <5022BB0E.8050706@fb.com>
In-Reply-To: <5022BB0E.8050706@fb.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.18.254]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.7.7855,1.0.260,0.0.0000
 definitions=2012-08-08_09:2012-08-08,2012-08-08,1970-01-01 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/8/12 12:16 PM, Arun Sharma wrote:

>     and therefore breaks the invariant period == period_self
>     in the default mode (no sort inclusive).


hist_entry__decay() also needs an update to maintain the invariant.

--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -138,6 +138,7 @@ static void hist_entry__add_cpumode_period(struct 
hist_entry *he,
  static void hist_entry__decay(struct hist_entry *he)
  {
         he->period = (he->period * 7) / 8;
+       he->period_self = (he->period_self * 7) / 8;
         he->nr_events = (he->nr_events * 7) / 8;
  }

  -Arun
