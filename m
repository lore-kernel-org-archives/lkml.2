Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932558Ab1LEURK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 15:17:10 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:40781 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932147Ab1LEURH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 15:17:07 -0500
Message-ID: <4EDD26B9.8070007@fb.com>
Date: Mon, 5 Dec 2011 12:16:57 -0800
From: Arun Sharma <asharma@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, <mingo@elte.hu>,
        William Cohen <wcohen@redhat.com>, Vince Weaver <vince@deater.net>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 0/6] perf: x86 RDPMC and RDTSC support
References: <20111121145114.049265181@chello.nl> <4ED9267F.10106@fb.com> <CABPqkBRpYA-StOTDFwyFhFtBPynbn-FLUzqZvaQn3oM3SJpCWg@mail.gmail.com>
In-Reply-To: <CABPqkBRpYA-StOTDFwyFhFtBPynbn-FLUzqZvaQn3oM3SJpCWg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.18.252]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.5.7110,1.0.211,0.0.0000
 definitions=2011-12-05_04:2011-12-05,2011-12-05,1970-01-01 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/2/11 2:22 PM, Stephane Eranian wrote:
> Have you tried with inheritance disabled?
> I don't remember if perf stat has it enabled buy default.

Disabling inheritance using the -i switch as in:

(for i in `seq 1 10`; do numactl --cpunodebind 1 perf stat -i -e 
instructions ./lat_ctx -P1 -s32k 4; done)

shows numbers closer to baseline, since the threads used for 
benchmarking are not counting events.

This suggests that:

jump_label_dec(&perf_task_events);

itself doesn't hurt much.

  -Arun
