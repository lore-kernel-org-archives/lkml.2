Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757606Ab0GBU6m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 16:58:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51612 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752619Ab0GBU6k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 16:58:40 -0400
Message-ID: <4C2E52DD.2050306@zytor.com>
Date: Fri, 02 Jul 2010 13:58:05 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, "Luck, Tony" <tony.luck@intel.com>
CC: Feng Tang <feng.tang@intel.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, jacob.jun.pan@intel.com, dtor@mail.ru,
       randy.dunlap@oracle.com
Subject: Re: [PATCH 5/5] input: i8042 - add runtime check in x86's i8042_platform_init
References: <1278059716-7147-1-git-send-email-feng.tang@intel.com> <1278059716-7147-6-git-send-email-feng.tang@intel.com> <alpine.LFD.2.00.1007022252480.2525@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1007022252480.2525@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Cc: Tony Luck]

On 07/02/2010 01:53 PM, Thomas Gleixner wrote:
> On Fri, 2 Jul 2010, feng.tang@intel.com wrote:
> 
>> From: Feng Tang <feng.tang@intel.com>
>>
>> Then it will first check x86_platforms's i8042 detection result,
>> then go on with normal probe.
>>
>> Cc: Dmitry Torokhov <dtor@mail.ru>
>> Signed-off-by: Feng Tang <feng.tang@intel.com>
>> ---
>>  drivers/input/serio/i8042-x86ia64io.h |    4 ++++
>>  1 files changed, 4 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/input/serio/i8042-x86ia64io.h b/drivers/input/serio/i8042-x86ia64io.h
>> index 6168469..2e14fc5 100644
>> --- a/drivers/input/serio/i8042-x86ia64io.h
>> +++ b/drivers/input/serio/i8042-x86ia64io.h
>> @@ -840,6 +840,10 @@ static int __init i8042_platform_init(void)
>>  {
>>  	int retval;
>>  
>> +	/* Just return if pre-detection shows no i8042 controller exist */
>> +	if (!x86_platform.i8042_detect())
>> +		return -ENODEV;
> 
> That's going to break IA64 :(
> 

I have to say there is an awful lot of code in that file which is
specific to x86 (more so than IA64)... anyone has a feel if it would
make sense to break it up?

	-hpa
