Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030336Ab2CFTmT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 14:42:19 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:56827 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965176Ab2CFTmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 14:42:17 -0500
Message-ID: <4F566872.9010408@fb.com>
Date: Tue, 6 Mar 2012 11:41:38 -0800
From: Arun Sharma <asharma@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>, <linux-kernel@vger.kernel.org>,
        <linux-perf-users@vger.kernel.org>
Subject: Re: [RFC] Sort inclusive
References: <20120305221253.GA30250@dev3310.snc6.facebook.com> <20120306065753.GB5100@elte.hu>
In-Reply-To: <20120306065753.GB5100@elte.hu>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.18.252]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.6.7498,1.0.260,0.0.0000
 definitions=2012-03-06_06:2012-03-06,2012-03-06,1970-01-01 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/5/12 10:57 PM, Ingo Molnar wrote:

> Btw., assuming that you are profiling user-space applications
> via call-chains, how do you deal with the lack of dwarf decoding
> done by perf, in particular on 64-bit x86 systems where most
> distros don't compile call-chains into libraries and
> application? In what practical situations does that limitation
> hinder you and what do you do about it - rebuild your apps with
> frame pointers included?

Yes - we're rebuilding everything with frame pointers so we could get 
callchains. While this works for C/C++, I'm not convinced that we have a 
good solution for JITs where there may be multiple stacks (eg: one each 
for interpreted and JIT code), and the kernel may not be able to unwind 
without dwarf decoding. For now, we're going with the /tmp/perf-$pid.txt 
based solution for JITs.

I'll post a new patch with the code refactored into smaller functions.

  -Arun
