Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733Ab2IXLnx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 07:43:53 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:43909 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754261Ab2IXLnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 07:43:46 -0400
Message-ID: <50604691.90904@linux.vnet.ibm.com>
Date: Mon, 24 Sep 2012 17:10:01 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Avi Kivity <avi@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Rik van Riel <riel@redhat.com>, Srikar <srikar@linux.vnet.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, Jiannan Ouyang <ouyang@cs.pitt.edu>,
        chegu vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Gleb Natapov <gleb@redhat.com>
Subject: Re: [PATCH RFC 1/2] kvm: Handle undercommitted guest case in PLE
 handler
References: <20120921115942.27611.67488.sendpatchset@codeblue> <20120921120000.27611.71321.sendpatchset@codeblue> <1348486423.11847.45.camel@twins>
In-Reply-To: <1348486423.11847.45.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12092411-6102-0000-0000-000002488FAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2012 05:03 PM, Peter Zijlstra wrote:
> On Fri, 2012-09-21 at 17:30 +0530, Raghavendra K T wrote:
>> +unsigned long rq_nr_running(void)
>> +{
>> +       return this_rq()->nr_running;
>> +}
>> +EXPORT_SYMBOL(rq_nr_running);
>
> Uhm,.. no, that's a horrible thing to export.
>

True.. I had the same fear :).  Other options I thought were something
like  nr_running()/num_online_cpus, this_cpu_load(), etc..

Could you please let me know, if we can rely some good metric to say,
system is not overcommitted/overcommitted?


