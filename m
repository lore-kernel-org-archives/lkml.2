Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757951Ab2CEXg1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 18:36:27 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:59901 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757799Ab2CEXgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 18:36:08 -0500
Message-ID: <4F554DC7.8010504@fb.com>
Date: Mon, 5 Mar 2012 15:35:35 -0800
From: Arun Sharma <asharma@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Stephane Eranian <eranian@google.com>, <linux-kernel@vger.kernel.org>,
        <dsahern@gmail.com>, <ravitillo@lbl.gov>,
        <khandual@linux.vnet.ibm.com>, <robert.richter@amd.com>,
        <ming.m.lin@intel.com>, <vweaver1@eecs.utk.edu>, <andi@firstfloor.org>
Subject: Re: [PATCH] perf report: auto-detect branch stack sampling mode
References: <20120224094048.GA7952@quad> <20120305154753.GA14604@elte.hu> <20120305155011.GA32413@elte.hu> <20120305155642.GB32413@elte.hu> <1330965033.11248.240.camel@twins> <20120305203518.GA5656@infradead.org> <4F55337B.4080807@fb.com> <20120305222614.GB5656@infradead.org>
In-Reply-To: <20120305222614.GB5656@infradead.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.18.252]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.6.7498,1.0.260,0.0.0000
 definitions=2012-03-05_07:2012-03-05,2012-03-05,1970-01-01 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Like you probably figured from my other mail, we deal with deeply nested 
callchains with unwieldy function names a lot -- thanks to C++ and 
template programming. --tui's collapsing/expanding functionality is 
quite useful to navigate that mess. I'm just taking this opportunity to 
get some attention focused on improving it :)

On 3/5/12 2:26 PM, Arnaldo Carvalho de Melo wrote:

>> Here's an example:
>>
>> # perf record -ag -- sleep 3
>> # perf report -G -s pid --tui # SIGSEGV
>
> Ok, now this is a good report, I managed to reproduce and will work on a
> fix, thanks,

Something like this seems to do it for me.

         offset = addr - sym->start;
+       len = sym->end - sym->start;
+       if (offset >= len)
+               return 0;
+

The other problem area seems to be callchains when using -p regexp -x 
options. I'll try to summarize problems there in a separate thread.

  -Arun
