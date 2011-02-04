Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752508Ab1BDUJt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 15:09:49 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40422 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752112Ab1BDUJs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 15:09:48 -0500
Message-ID: <4D4C5CE1.2090006@zytor.com>
Date: Fri, 04 Feb 2011 12:09:05 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Thunderbird/3.1.7
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Kamal Mostafa <kamal@canonical.com>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Len Brown <len.brown@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] x86: fix panic when handling "mem={invalid}" param
References: <1296783486-23033-1-git-send-email-kamal@canonical.com> <AANLkTimDrWESfmSwRSyhenZTwXovKKa4mSC=Y0=j9yPM@mail.gmail.com>
In-Reply-To: <AANLkTimDrWESfmSwRSyhenZTwXovKKa4mSC=Y0=j9yPM@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04/2011 11:44 AM, Yinghai Lu wrote:
> On Thu, Feb 3, 2011 at 5:38 PM, Kamal Mostafa <kamal@canonical.com> wrote:
>> Avoid removing all of memory and panicing when "mem={invalid}" is
>> specified, e.g. mem=blahblah, mem=0, or mem=nopentium (on platforms
>> other than x86_32).
>>
>> BugLink: http://bugs.launchpad.net/bugs/553464
>> Signed-off-by: Kamal Mostafa <kamal@canonical.com>
>> Cc: <stable@kernel.org>
>> ---
>>  arch/x86/kernel/e820.c |    3 +++
>>  1 files changed, 3 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
>> index 294f26d..55a59d8 100644
>> --- a/arch/x86/kernel/e820.c
>> +++ b/arch/x86/kernel/e820.c
>> @@ -856,6 +856,9 @@ static int __init parse_memopt(char *p)
>>
>>        userdef = 1;
>>        mem_size = memparse(p, &p);
>> +       /* don't remove all of memory when handling "mem={invalid}" param */
>> +       if (mem_size == 0)
>> +               return -EINVAL;
>>        e820_remove_range(mem_size, ULLONG_MAX - mem_size, E820_RAM, 1);
>>
>>        return 0;
>> --
> 
> then how about some one pass mem=32M etc?
> 
> or total wrongly usermap?
> 

All he looks at is when the value returned is zero.  It wouldn't be zero
for any actual value, including mem=32M.

	-hpa
