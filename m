Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757692Ab2EVKSg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 06:18:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2759 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752129Ab2EVKSe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 06:18:34 -0400
Message-ID: <4FBB67ED.70606@redhat.com>
Date: Tue, 22 May 2012 07:18:21 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Borislav Petkov <borislav.petkov@amd.com>
CC: "Luck, Tony" <tony.luck@intel.com>, Ingo Molnar <mingo@kernel.org>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aristeu Rozanski <arozansk@redhat.com>,
        Doug Thompson <norsk5@yahoo.com>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH v24b] RAS: Add a tracepoint for reporting memory controller
 events
References: <4FB6866E.7090503@redhat.com> <20120518185258.GE20215@aftab.osrc.amd.com> <3908561D78D1C84285E8C5FCA982C28F192F1A33@ORSMSX104.amr.corp.intel.com> <20120518211211.GA26464@aftab.osrc.amd.com> <20120519092618.GC29991@aftab.osrc.amd.com> <4FBA5F59.5000604@redhat.com> <20120521160041.GJ3334@aftab.osrc.amd.com> <4FBA6FE8.50707@redhat.com> <20120521204042.GA14255@aftab.osrc.amd.com> <4FBB0250.20100@redhat.com> <20120522092832.GC18578@aftab.osrc.amd.com>
In-Reply-To: <20120522092832.GC18578@aftab.osrc.amd.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 22-05-2012 06:28, Borislav Petkov escreveu:
> On Tue, May 22, 2012 at 12:04:48AM -0300, Mauro Carvalho Chehab wrote:
>> +TRACE_EVENT(mc_event,
>> +
>> +	TP_PROTO(const unsigned int err_type,
>> +		 const unsigned int mc_index,
>> +		 const char *error_msg,
>> +		 const char *label,
>> +		 int layer0,
>> +		 int layer1,
>> +		 int layer2,
> 
> Those are EDAC-internal layer representation, why are they exported to
> userspace? Userspace needs only the location and label AFAICT.

Those are not the EDAC internal layer representation. They're the physical
location of the DIMM or rank.

> If you export them to userspace, they need much more meaningful names -
> layer{0,1,2} mean nothing outside of the kernel.

Ok. Do you have a better naming suggestion?

What about layer0_pos, layer1_pos, layer2_pos?

> 
>> +		 unsigned long pfn,
>> +		 unsigned long offset,
>> +		 unsigned long grain,
> 
> Why aren't those a single 'unsigned long address' since they all are
> computed from it?

We can merge pfn and offset into "unsigned long address".

With regards to the grain, it is an address mask, written with a "short" way.
So, grain 32, for example, means:
	ffff:ffff:ffff:fffe0

As the current EDAC API exports it as grain, IMO, it is better to keep it as-is,
but it won't be hard to do:
	unsigned long mask = ((unsigned long) -1) && (1 - grain)

What do you think?

>> +		 unsigned long syndrome,
>> +		 const char *driver_detail),
>> +
>> +	TP_ARGS(err_type, mc_index, error_msg, label, layer0, layer1, layer2,
>> +		pfn, offset, grain, syndrome, driver_detail),
>>
>> The address is there using the edac way to represent it (page, offset, grain).
> 

Regards,
Mauro
