Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602Ab0JRClz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 22:41:55 -0400
Received: from mga02.intel.com ([134.134.136.20]:41380 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752321Ab0JRCly (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 22:41:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,344,1283756400"; 
   d="scan'208";a="668309552"
Message-ID: <4CBBB3EC.9000609@linux.intel.com>
Date: Mon, 18 Oct 2010 10:41:48 +0800
From: Chen Gong <gong.chen@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; zh-CN; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: "Koornstra, Reinoud" <koornstra@hp.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Greg KH <gregkh@suse.de>,
        Sameer Nanda <snanda@chromium.org>,
        "lenb@kernel.org" <lenb@kernel.org>,
        "stefan.bader@canonical.com" <stefan.bader@canonical.com>,
        "brad.figg@canonical.com" <brad.figg@canonical.com>,
        "apw@canonical.com" <apw@canonical.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ACPI: Read TSC upon resume
References: <1286406919-6236-1-git-send-email-snanda@chromium.org> <AANLkTik=imw5XRpXSkboyB6txXio6Y65bLV+EdfvRXg3@mail.gmail.com> <20101007181536.GA24811@suse.de> <201010072344.22166.rjw@sisk.pl> <E92FAF79A8BBC642A36EEE3AA7F152D884DB9CA072@GVW1089EXB.americas.hpqcorp.net>
In-Reply-To: <E92FAF79A8BBC642A36EEE3AA7F152D884DB9CA072@GVW1089EXB.americas.hpqcorp.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 10/16/2010 11:03 AM, Koornstra, Reinoud 写道:
>> -----Original Message-----
>> From: linux-acpi-owner@vger.kernel.org [mailto:linux-acpi-
>> owner@vger.kernel.org] On Behalf Of Rafael J. Wysocki
>> Sent: Thursday, October 07, 2010 2:44 PM
>> To: Greg KH
>> Cc: Sameer Nanda; lenb@kernel.org; stefan.bader@canonical.com;
>> brad.figg@canonical.com; apw@canonical.com; linux-acpi@vger.kernel.org;
>> linux-kernel@vger.kernel.org
>> Subject: Re: [PATCH] ACPI: Read TSC upon resume
>>
>> On Thursday, October 07, 2010, Greg KH wrote:
>>> On Thu, Oct 07, 2010 at 11:05:21AM -0700, Sameer Nanda wrote:
>>>> On Thu, Oct 7, 2010 at 10:46 AM, Greg KH<gregkh@suse.de>  wrote:
>>>>> On Thu, Oct 07, 2010 at 10:43:34AM -0700, Sameer Nanda wrote:
>>>>>> On Wed, Oct 6, 2010 at 7:19 PM, Greg KH<gregkh@suse.de>  wrote:
>>>>>>> And are you always going to be printing this out?  Why do we
>> want to
>>>>>>> know this every time?
>>>>>>>
>>>>>>
>>>>>> Yes, every time.  This helps track variance in BIOS resume times
>> within a
>>>>>> single boot.
>>>>>
>>>>> Is that really something that users can do something about?
>>>>
>>>> Aside from complaining to the BIOS vendors, no :)
>>>
>>> Then I would not recommend adding this patch, as it is irrelevant for
>>> 99.9999% of all Linux users.
>>
>> It may be somewhat useful, but the rdtscll() call seems to be x86-
>> specific, in
>> which case it shouldn't be used at this place.
>
> Also, in the case of an intel core 2 duo cpu, the tsc is not stable, hence upon resume the cpu is spinning up and the first tsc's will be slower.
> During idle-time the tsc will not be incremented. The tsc is only stably incremented upon 100% cpu usage. It also doesn't increment faster in turbo mode in case of some core 2 duo and certainly the Nehalem cpu's. Calculating in time in terms of tsc might not be so reliable.
>
If I'm wrong, please feel free to fix me.

I have 2 questions to your answer:

1.  CPU has a flag named constant_tsc to keep TSC always working in a 
constant way, so it is irrelvant to the CPU freq. whether in turbo mode 
or any P-state CPU currently belongs to, TSC should be not affected. 
IIRC, this flag should exist long before, at least before Core 2 duo. If 
so, TSC shoule be stable in this kind of environment.

2. though during idle-time TSC will not be incremented, here I want to
remind it is right before Westmere (TSC not always running), and you 
mentioned "upon resume the cpu is spinning up and the first tsc's will 
be slower", I don't know if this commit cd7240c0b can fix it up.
