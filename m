Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757360Ab2DTSTU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 14:19:20 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:52152 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754830Ab2DTSTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 14:19:18 -0400
Message-ID: <4F91A868.6090803@fb.com>
Date: Fri, 20 Apr 2012 11:18:16 -0700
From: Arun Sharma <asharma@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        "Arnaldo Carvalho de Melo" <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        "Stephane Eranian" <eranian@google.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Tom Zanussi" <tzanussi@gmail.com>, <linux-perf-users@vger.kernel.org>,
        "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [PATCH] perf, x86: Disable sanity check
References: <1334791449-402-1-git-send-email-asharma@fb.com> <1334913084.2463.29.camel@laptop>
In-Reply-To: <1334913084.2463.29.camel@laptop>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.18.252]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.6.7580,1.0.260,0.0.0000
 definitions=2012-04-20_06:2012-04-20,2012-04-20,1970-01-01 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/20/12 2:11 AM, Peter Zijlstra wrote:
> Makes me really nervous.. Ingo, Linus ?
>
> 'normal' usespace can suffer from this too with signal stacks. Arun's
> JIT case seems particularly weird in that his stacks don't strictly nest
> but can cross over multiple times (makes one wonder why they bother with
> multiple stacks..).

It's a tracing JIT, which dynamically chooses between interpreted mode 
and JIT mode. Translation is not necessarily a function at a time and 
has to be guarded by types inferred at runtime. Each time they switch 
between the two modes, they need to examine the non-native frames on the 
stack. With a single stack design, they'd have to unwind the stack 
looking for native frames vs JIT frames which adds complexity and cost.

Like you observed, this is needed for other less complex cases as well.

  -Arun

