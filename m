Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755420Ab0GIVMt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 17:12:49 -0400
Received: from mail.tpi.com ([70.99.223.143]:4942 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755170Ab0GIVMr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 17:12:47 -0400
Message-ID: <4C3790CA.5070009@canonical.com>
Date: Fri, 09 Jul 2010 15:12:42 -0600
From: Tim Gardner <tim.gardner@canonical.com>
Reply-To: tim.gardner@canonical.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100528 Thunderbird/3.0.5
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Kees Cook <kees@outflux.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: [Bug #16294] [Q35 bisected] hang at init of i915 driver
References: <-IGZ64uxA6G.A.P0H.bLmNMB@chimera> <TXb9XdQzJoD.A.uoB.WMmNMB@chimera> <20100709004505.GU828@outflux.net> <201007092256.48672.rjw@sisk.pl>
In-Reply-To: <201007092256.48672.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/2010 02:56 PM, Rafael J. Wysocki wrote:
> On Friday, July 09, 2010, Kees Cook wrote:
>> Hi Rafael,
>>
>> On Fri, Jul 09, 2010 at 01:41:39AM +0200, Rafael J. Wysocki wrote:
>>> The following bug entry is on the current list of known regressions
>>> from 2.6.34.  Please verify if it still should be listed and let the tracking team
>>> know (either way).
>>
>> Yup, this is still a regression.  The fix is trivial (see below).
>
> Thanks for the update.
>
>>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16294
>>> Subject		: [Q35 bisected] hang at init of i915 driver
>>> Submitter	: Kees Cook<kees@outflux.net>
>>> Date		: 2010-06-25 18:20 (14 days old)
>>> First-Bad-Commit: http://git.kernel.org/linus/f1befe71fa7a79ab733011b045639d8d809924ad
>>
>> diff --git a/drivers/char/agp/intel-gtt.c b/drivers/char/agp/intel-gtt.c
>> index 9344216..0d9007d 100644
>> --- a/drivers/char/agp/intel-gtt.c
>> +++ b/drivers/char/agp/intel-gtt.c
>> @@ -1229,6 +1229,7 @@ static int intel_i915_get_gtt_size(void)
>>   				(gmch_ctrl&  G33_PGETBL_SIZE_MASK));
>>   			size = 512;
>>   		}
>> +		size = 1024;
>>   	} else {
>>   		/* On previous hardware, the GTT size was just what was
>>   		 * required to map the aperture.
>
> Rafael
> --

Rafael - I forgot to Cc you on the patch I just sent to Dave Arlie. Kees 
has confirmed that it fixes his problem.

http://marc.info/?l=linux-kernel&m=127870855118533&w=2

rtg
-- 
Tim Gardner tim.gardner@canonical.com
