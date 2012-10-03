Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933147Ab2JCAdg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 20:33:36 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:50752 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933134Ab2JCAdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 20:33:35 -0400
Message-ID: <506B87D9.9020800@gmail.com>
Date: Wed, 03 Oct 2012 10:33:29 +1000
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>, YAMANE Toshiaki <yamanetoshi@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 3/7] staging: rts_pstor: reuse kbasename()
References: <1349190062-13107-1-git-send-email-andriy.shevchenko@linux.intel.com> <1349190062-13107-3-git-send-email-andriy.shevchenko@linux.intel.com> <506B8731.3020408@gmail.com>
In-Reply-To: <506B8731.3020408@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10/12 10:30, Ryan Mallon wrote:
> On 03/10/12 01:00, Andy Shevchenko wrote:
>> The custom filename function mostly repeats the kernel's kbasename. This patch
>> simplifies it. The updated filename() will not check for the '\' in the
>> filenames. It seems redundant in Linux.
>>
>> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>> Cc: YAMANE Toshiaki <yamanetoshi@gmail.com>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> ---
>>  drivers/staging/rts_pstor/trace.h |   16 +++-------------
>>  1 file changed, 3 insertions(+), 13 deletions(-)
>>
>> diff --git a/drivers/staging/rts_pstor/trace.h b/drivers/staging/rts_pstor/trace.h
>> index cf60a1b..59c5686 100644
>> --- a/drivers/staging/rts_pstor/trace.h
>> +++ b/drivers/staging/rts_pstor/trace.h
>> @@ -24,26 +24,16 @@
>>  #ifndef __REALTEK_RTSX_TRACE_H
>>  #define __REALTEK_RTSX_TRACE_H
>>  
>> +#include <linux/string.h>
>> +
>>  #define _MSG_TRACE
>>  
>>  #ifdef _MSG_TRACE
>>  static inline char *filename(char *path)
>>  {
>> -	char *ptr;
>> -
>>  	if (path == NULL)
>>  		return NULL;
>> -
>> -	ptr = path;
>> -
>> -	while (*ptr != '\0') {
>> -		if ((*ptr == '\\') || (*ptr == '/'))
>> -			path = ptr + 1;
> 
> The original version here returns the string after the last '/' or '\',
> the new kbasename function only looks for '/'. Does that matter here, or
> was the original code over eager?

Nevermind, I didn't read the changelog fully :-/.

~Ryan


