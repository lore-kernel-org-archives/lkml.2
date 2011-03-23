Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932491Ab1CWN6r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 09:58:47 -0400
Received: from ppsw-41.csi.cam.ac.uk ([131.111.8.141]:51400 "EHLO
	ppsw-41.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756103Ab1CWN6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 09:58:46 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4D89FCE0.1040005@cam.ac.uk>
Date: Wed, 23 Mar 2011 14:00:00 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20110122 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, greg@kroah.com, rusty@rustcorp.com.au,
        adobriyan@gmail.com
Subject: Re: [PATCH 1/3] Add a kstrtobool function matching semantics of existing
 in kernel equivalents.
References: <1300887554-19031-1-git-send-email-jic23@cam.ac.uk> <1300887554-19031-2-git-send-email-jic23@cam.ac.uk> <20110323135435.GE17108@twin.jikos.cz>
In-Reply-To: <20110323135435.GE17108@twin.jikos.cz>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/23/11 13:54, David Sterba wrote:
> Hi,
> 
> you've missed a few breaks :)
Gah!  This really isn't going well. Lets just pretend I'm not an idiot and
those were there in the first place.  One day I'll remember to never
refactor (and not check) my code just before sending the emails out.

Thanks,
> 
> On Wed, Mar 23, 2011 at 01:39:12PM +0000, Jonathan Cameron wrote:
>> Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
>> ---
>>  include/linux/kernel.h |    1 +
>>  lib/kstrtox.c          |   18 ++++++++++++++++++
>>  2 files changed, 19 insertions(+), 0 deletions(-)
>>
>> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
>> index 00cec4d..0babad3 100644
>> --- a/include/linux/kernel.h
>> +++ b/include/linux/kernel.h
>> @@ -247,6 +247,7 @@ int __must_check kstrtou16(const char *s, unsigned int base, u16 *res);
>>  int __must_check kstrtos16(const char *s, unsigned int base, s16 *res);
>>  int __must_check kstrtou8(const char *s, unsigned int base, u8 *res);
>>  int __must_check kstrtos8(const char *s, unsigned int base, s8 *res);
>> +int __must_check kstrtobool(const char *s, bool *res);
>>  
>>  extern unsigned long simple_strtoul(const char *,char **,unsigned int);
>>  extern long simple_strtol(const char *,char **,unsigned int);
>> diff --git a/lib/kstrtox.c b/lib/kstrtox.c
>> index 05672e8..84cf08f 100644
>> --- a/lib/kstrtox.c
>> +++ b/lib/kstrtox.c
>> @@ -225,4 +225,21 @@ int kstrtos8(const char *s, unsigned int base, s8 *res)
>>  	return 0;
>>  }
>>  EXPORT_SYMBOL(kstrtos8);
>> +
>> +int kstrtobool(const char *s, bool *res)
>> +{
>> +	switch (s[0]) {
>> +	case 'y':
>> +	case 'Y':
>> +	case '1':
>> +		*res = true;
>                 break;
> 
>> +	case 'n':
>> +	case 'N':
>> +	case '0':
>> +		*res = false;
>                 break;
> 
>> +	default:
>> +		return -EINVAL;
>> +	}
>> +	return 0;
>> +}
>> +EXPORT_SYMBOL(kstrtobool);
>> -- 
>> 1.7.3.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
> 

