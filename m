Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757872Ab2EGXrP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 19:47:15 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:33828 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757349Ab2EGXrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 19:47:13 -0400
Message-ID: <4FA85EE5.9030102@fb.com>
Date: Mon, 7 May 2012 16:46:45 -0700
From: Arun Sharma <asharma@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Namhyung Kim <namhyung.kim@lge.com>, Tom Zanussi <tzanussi@gmail.com>,
        <linux-perf-users@vger.kernel.org>
Subject: Re: [PATCH 1/4] perf, x86: Allow multiple stacks
References: <1334961696-19580-1-git-send-email-asharma@fb.com> <1334961696-19580-2-git-send-email-asharma@fb.com>
In-Reply-To: <1334961696-19580-2-git-send-email-asharma@fb.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.18.252]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.6.7580,1.0.260,0.0.0000
 definitions=2012-05-07_05:2012-05-07,2012-05-07,1970-01-01 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/20/12 3:41 PM, Arun Sharma wrote:
> Without this patch, applications with two different stack
> regions (eg: native stack vs JIT stack) get truncated
> callchains even when RBP chaining is present. GDB shows proper
> stack traces and the frame pointer chaining is intact.
>
> This patch disables the (fp<  RSP) check, hoping that other checks
> in the code save the day for us. In our limited testing, this
> didn't seem to break anything.
>
> In the long term, we could potentially have userspace advise
> the kernel on the range of valid stack addresses, so we don't
> spend a lot of time unwinding from bogus addresses.

Ingo/Peter: Did you get a chance to look at this patch series (Support 
multiple stacks v3)?

  -Arun
