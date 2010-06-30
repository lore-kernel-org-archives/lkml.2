Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932294Ab0F3Vgp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 17:36:45 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:49335 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756678Ab0F3Vgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 17:36:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=bRlXARDM7RA/NTxgPUeZu33oq1kl5LZ5/Ud1LcGD/oKFP4gq28/zHnREpHnsLn8qsq
         H6JM9JF8TAXZLotRXiwW5Z7pqIQt4JabCgpVkJ3w2p6GyLnVExyxynKbBb3jLIbJPKxe
         kNxfPZjiHi3N1LDBlFn8XiEwLmTZNbxir+ucM=
Message-ID: <4C2BB901.4060009@gmail.com>
Date: Wed, 30 Jun 2010 14:37:05 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100615 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]kernel.h Fix #warning message web address.
References: <1277840244-3436-1-git-send-email-justinmattock@gmail.com>	<alpine.LNX.2.00.1006301147490.13809@pobox.suse.cz>	<4C2BB52A.7070404@gmail.com> <20100630142259.a5f4dcb5.rdunlap@xenotime.net>
In-Reply-To: <20100630142259.a5f4dcb5.rdunlap@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/30/2010 02:22 PM, Randy Dunlap wrote:
> On Wed, 30 Jun 2010 14:20:42 -0700 Justin P. Mattock wrote:
>
>>
>>> Hehe, ugly. How about making it a single string? GCC preprocessor
>>> documentation suggests the same anyway ...
>>>
>>> 	Neither `#error' nor `#warning' macro-expands its argument.
>>> 	Internal whitespace sequences are each replaced with a single space.
>>> 	The line must consist of complete tokens.  It is wisest to make the
>>> 	argument of these directives be a single string constant; this avoids
>>> 	problems with apostrophes and the like.
>
> Doesn't that mean just put double quotation marks around the entire message string??
>

didnt even notice that. but to answer your question your right. updated 
patch below.

>
>
>> o.k. jiri, here is what I came up with, after re-reading and looking at
>> other in the kernel(below).
>>
>>
>>
>>   From 45f24db45faa06aad01cfc62ff4b475380e5cb11 Mon Sep 17 00:00:00 2001
>> From: Justin P. Mattock<justinmattock@gmail.com>
>> Date: Wed, 30 Jun 2010 14:06:18 -0700
>> Subject: [PATCH]kernel.h Fix #warning message according to the GCC
>> preprocessor docs.
>>
>> received this #warning from a simple printk program and noticed the web
>> address is not showing up:
>>    gcc printk.c -o printk
>> In file included from printk.c:3:
>> include/linux/kernel.h:733:2: warning: #warning Attempt to use kernel
>> headers from user space, see http:
>>
>> after the changes the warning should just say:
>> #warning Attempt to use kernel headers from user space!
>>
>>    Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
>> ---
>>    include/linux/kernel.h |    2 +-
>>    1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
>> index 8317ec4..b542961 100644
>> --- a/include/linux/kernel.h
>> +++ b/include/linux/kernel.h
>> @@ -730,7 +730,7 @@ extern int do_sysinfo(struct sysinfo *info);
>>
>>    #ifndef __EXPORTED_HEADERS__
>>    #ifndef __KERNEL__
>> -#warning Attempt to use kernel headers from user space, see
>> http://kernelnewbies.org/KernelHeaders
>> +#warning Attempt to use kernel headers from user space!
>>    #endif /* __KERNEL__ */
>>    #endif /* __EXPORTED_HEADERS__ */
>>
>> --
>> 1.7.1.rc1.21.gf3bd6
>>
>>
>> now I'm wondering if there should be a lead to the documentation with
>> this web address(seems grep is not finding anything that I might be able
>> to use).or just leave as is, and let people connect-the-dots!!
>>
>> let me know..
>>
>> Justin P. Mattock
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>
>
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
>



 From 5e0b59283521c4b222c1131626e306752cd157f3 Mon Sep 17 00:00:00 2001
From: Justin P. Mattock <justinmattock@gmail.com>
Date: Wed, 30 Jun 2010 14:30:22 -0700
Subject: [PATCH]kernel.h Add quotation marks around the message so the 
web address is shown.

Add quotation marks around the message so the web address is shown.
before:
gcc printk.c -o printk
In file included from printk.c:3:
include/linux/kernel.h:733:2: warning: #warning Attempt to use kernel
headers from user space, see http:
after:
gcc printk.c -o printk
In file included from printk.c:3:
warning: #warning "Attempt to use kernel headers from user space,
see http://kernelnewbies.org/KernelHeaders"
  Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
  include/linux/kernel.h |    2 +-
  1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 8317ec4..4055858 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -730,7 +730,7 @@ extern int do_sysinfo(struct sysinfo *info);

  #ifndef __EXPORTED_HEADERS__
  #ifndef __KERNEL__
-#warning Attempt to use kernel headers from user space, see 
http://kernelnewbies.org/KernelHeaders
+#warning "Attempt to use kernel headers from user space, see 
http://kernelnewbies.org/KernelHeaders"
  #endif /* __KERNEL__ */
  #endif /* __EXPORTED_HEADERS__ */

-- 
1.6.5.2.180.gc5b3e


of the two whatever works best.

Justin P. Mattock
