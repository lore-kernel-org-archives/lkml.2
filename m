Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753700Ab2KPWhU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 17:37:20 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36954 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753450Ab2KPWhT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 17:37:19 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <1353104456.7586.27.camel@gandalf.local.home>
References: <20121116214644.8521.79072.stgit@ahduyck-cp1.jf.intel.com> <20121116215718.8521.24026.stgit@ahduyck-cp1.jf.intel.com> <1353104456.7586.27.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4 6/8] x86/ftrace: Use __pa_symbol instead of __pa on C visible symbols
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Fri, 16 Nov 2012 14:25:28 -0800
To: Steven Rostedt <rostedt@goodmis.org>,
        Alexander Duyck <alexander.h.duyck@intel.com>
CC: tglx@linutronix.de, mingo@redhat.com, andi@firstfloor.org,
        Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <a162a888-9892-43ca-ad17-61c19936c6f4@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is a performance improvement.

Steven Rostedt <rostedt@goodmis.org> wrote:

>On Fri, 2012-11-16 at 13:57 -0800, Alexander Duyck wrote:
>> Instead of using __pa which is meant to be a general function for
>converting
>> virtual addresses to physical addresses we can use __pa_symbol which
>is the
>> preferred way of decoding kernel text virtual addresses to physical
>addresses.
>> 
>> In this case we are not directly converting C visible symbols however
>if we
>> know that the instruction pointer is somewhere between _text and
>_etext we
>> know that we are going to be translating an address form the kernel
>text
>> space.
>
>Can I ask what the purpose of this is? I'm a little skeptical of a
>change that is just "the preferred way".
>
>Was there some bug that this fixes?
>
>-- Steve
>
>> 
>> Cc: Steven Rostedt <rostedt@goodmis.org>
>> Cc: Frederic Weisbecker <fweisbec@gmail.com>
>> Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
>> ---
>>  arch/x86/kernel/ftrace.c |    4 ++--
>>  1 files changed, 2 insertions(+), 2 deletions(-)
>> 
>> diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
>> index 1d41402..42a392a 100644
>> --- a/arch/x86/kernel/ftrace.c
>> +++ b/arch/x86/kernel/ftrace.c
>> @@ -89,7 +89,7 @@ do_ftrace_mod_code(unsigned long ip, const void
>*new_code)
>>  	 * kernel identity mapping to modify code.
>>  	 */
>>  	if (within(ip, (unsigned long)_text, (unsigned long)_etext))
>> -		ip = (unsigned long)__va(__pa(ip));
>> +		ip = (unsigned long)__va(__pa_symbol(ip));
>>  
>>  	return probe_kernel_write((void *)ip, new_code, MCOUNT_INSN_SIZE);
>>  }
>> @@ -279,7 +279,7 @@ static int ftrace_write(unsigned long ip, const
>char *val, int size)
>>  	 * kernel identity mapping to modify code.
>>  	 */
>>  	if (within(ip, (unsigned long)_text, (unsigned long)_etext))
>> -		ip = (unsigned long)__va(__pa(ip));
>> +		ip = (unsigned long)__va(__pa_symbol(ip));
>>  
>>  	return probe_kernel_write((void *)ip, val, size);
>>  }

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
