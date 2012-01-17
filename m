Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752774Ab2AQJvs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 04:51:48 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:55052 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752615Ab2AQJvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 04:51:45 -0500
Message-ID: <4F1544AE.50206@kernel.org>
Date: Tue, 17 Jan 2012 04:51:42 -0500
From: Len Brown <lenb@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.22) Gecko/20110906 Fedora/3.1.14-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.14
MIME-Version: 1.0
To: Myron Stowe <myron.stowe@gmail.com>
CC: Huang Ying <ying.huang@intel.com>, linux-kernel@vger.kernel.org,
        Tony Luck <tony.luck@intel.com>, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 6/9] ACPI, Add RAM mapping support to ACPI atomic IO support
References: <1320719974-3598-1-git-send-email-ying.huang@intel.com>	<1320719974-3598-7-git-send-email-ying.huang@intel.com> <CAL-B5D1z35ReG9dKVBLNkktrJ-c8OVspsCYTUAO16wCK1B_4dA@mail.gmail.com>
In-Reply-To: <CAL-B5D1z35ReG9dKVBLNkktrJ-c8OVspsCYTUAO16wCK1B_4dA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08/2011 04:38 PM, Myron Stowe wrote:

> On Mon, Nov 7, 2011 at 7:39 PM, Huang Ying <ying.huang@intel.com> wrote:
>> On one of our testing machine, the following EINJ command lines:
>>
>>  # echo 0x10000000 > param1
>>  # echo 0xfffffffffffff000 > param2
>>  # echo 0x8 > error_type
>>  # echo 1 > error_inject
>>
>> Will get:
>>
>>  echo: write error: Input/output error
>>
>> The EIO comes from:
>>
>>    rc = apei_exec_pre_map_gars(&trigger_ctx);
>>
>> The root cause is as follow.  Normally, ACPI atomic IO support is used
>> to access IO memory.  But in EINJ of that machine, it is used to
>> access RAM to trigger the injected error.  And the ioremap() called by
>> apei_exec_pre_map_gars() can not map the RAM.
>>
>> This patch add RAM mapping support to ACPI atomic IO support to
>> satisfy EINJ requirement.
>>
>> Signed-off-by: Huang Ying <ying.huang@intel.com>
>> Tested-by: Tony Luck <tony.luck@intel.com>
>> ---
>>  drivers/acpi/atomicio.c |   34 ++++++++++++++++++++++++++++++----
>>  1 file changed, 30 insertions(+), 4 deletions(-)
>>
> 
> Hi Huang:
> 
> This patch collides with my series to remove atomicio.[ch]:
>   https://mail.google.com/mail/?shva=1#label/linux-acpi+list/133805812264a542
> and I don't want such functionality to get lost if/when the removal series
> is accepted.  I'm interested in working with you, not against you, so would
> you like me to do anything with respect to this patch within the osl.c based
> mapping routines so this capability would not become lost?
> 
> The obvious choices would be for me to post a new patch, copying this
> functionality into osl.c's mapping routines, that would apply on top of the
> removal series.  Another tact could be for me to do basically the same
> thing but within the removal series (by adding this into it, and reposting).
> The latter tactic seems like it could be a constant problem if more changes
> to atomicio occur during this interim period.  Of course you may have other
> ideas here as how to progress.
> 
> This type of occurrence, among many others, is a good example of why we
> need to get down to just one set of mapping routines as soon as possible.
> During this interim period I'll try and monitor the linux-acpi-list
> for future such
> occurrences but if you could, please try and cc me on any future atomicio
> modifications.
> 
> Thanks,
>  Myron


Hi Myron,
I've included your 1-3 of "ACPI: Re-factor and remove ./drivers/acpi/atomicio.[ch]"
on top of Ying's series "[PATCH 00/11] ACPI, APEI, Patches for 3.3"

Can you re-fresh your #4 so it applies on top?
Would be delightful to get rid of atomicio.

You can pull my branch from
git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux.git next

thanks!
-Len



thanks,
-Len

