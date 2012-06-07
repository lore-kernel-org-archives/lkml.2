Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758660Ab2FGAEm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 20:04:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43913 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753693Ab2FGAEl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 20:04:41 -0400
Message-ID: <4FCFEFF0.5070108@zytor.com>
Date: Wed, 06 Jun 2012 17:04:00 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Fenghua Yu <fenghua.yu@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Suresh B Siddha <suresh.b.siddha@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Asit K Mallick <asit.k.mallick@intel.com>,
        Arjan Dan De Ven <arjan@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>,
        linux-pm <linux-pm@vger.kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [PATCH] kthread: Implement park/unpark facility
References: <1338833876-29721-1-git-send-email-fenghua.yu@intel.com>  <alpine.LFD.2.02.1206042203590.3086@ionos>  <1338842001.28282.135.camel@twins> <87zk8iioam.fsf@rustcorp.com.au>  <alpine.LFD.2.02.1206051135260.3086@ionos>  <alpine.LFD.2.02.1206051538280.3086@ionos> <1338905159.28282.186.camel@twins>
In-Reply-To: <1338905159.28282.186.camel@twins>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/2012 07:05 AM, Peter Zijlstra wrote:
> On Tue, 2012-06-05 at 15:41 +0200, Thomas Gleixner wrote:
>>  struct kthread {
>> -       int should_stop;
>> +       bool should_stop;
>> +       bool should_park;
>> +       bool is_parked;
>> +       bool is_percpu; 
> 
> bool doesn't have a well specified storage type. I typically try to
> avoid using it in structures for this reason. Others might not care
> though.
> 

On all known Linux platforms, bool is implemented as a single byte
having a value of either 0 or 1.  However, it might make more sense to
have a flags field here...

	-hpa

