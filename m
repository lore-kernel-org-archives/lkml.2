Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759915Ab1LPAQc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 19:16:32 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:58448 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759671Ab1LPAQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 19:16:31 -0500
Message-ID: <4EEA8DB1.6060505@fb.com>
Date: Thu, 15 Dec 2011 16:15:45 -0800
From: Arun Sharma <asharma@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: <avagin@gmail.com>
CC: <avagin@openvz.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH 3/4] trace: add ability to collect call chain of non-current
 task.
References: <1317052535-1765247-1-git-send-email-avagin@openvz.org> <1317052535-1765247-4-git-send-email-avagin@openvz.org> <1317132351.15383.66.camel@twins> <20110927205548.GN18553@somewhere> <4EE01ACB.1000102@fb.com> <4EE1EC0B.4020600@openvz.org> <4EE903B1.7000600@fb.com> <4EEA101C.7060505@gmail.com> <4EEA45C6.2020106@fb.com>
In-Reply-To: <4EEA45C6.2020106@fb.com>
Content-Type: text/plain; charset="KOI8-R"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.18.252]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.5.7110,1.0.211,0.0.0000
 definitions=2011-12-15_07:2011-12-16,2011-12-15,1970-01-01 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/15/11 11:08 AM, Arun Sharma wrote:

> I still need to investigate why per-process mode (command line without
> -a) doesn't work. Will send an updated patch once that's fixed.
>

The per-process mode works fine after moving the trace point to be after:

         perf_event_task_sched_in(prev, current);

App developers using this feature here say they're fine not having the 
block vs sleep distinction because they intend to use it with "-g" and 
the callstack makes it obvious which one it was.

If we really need this info, we should be able to derive it in user 
space via perf inject.

  -Arun
