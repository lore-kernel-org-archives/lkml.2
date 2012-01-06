Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759152Ab2AFUm1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 15:42:27 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:37452 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752928Ab2AFUmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 15:42:25 -0500
Message-ID: <4F075CAE.2040709@gmail.com>
Date: Fri, 06 Jan 2012 12:42:22 -0800
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>
Subject: Re: [PATCH] recordmcount: Fix handling of elf64 big-endian objects.
References: <1324345362-12230-1-git-send-email-ddaney.cavm@gmail.com> <1324350542.5916.48.camel@gandalf.stny.rr.com>
In-Reply-To: <1324350542.5916.48.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2011 07:09 PM, Steven Rostedt wrote:
> On Mon, 2011-12-19 at 17:42 -0800, David Daney wrote:
>> From: David Daney<david.daney@cavium.com>
>>
>> In ELF64, the sh_flags field is 64-bits wide.  recordmcount was
>> erroneously treating it as a 32-bit wide field.  For little endian
>> objects this works because the flags of interest (SHF_EXECINSTR)
>> reside in the lower 32 bits of the word, and you get the same result
>> with either a 32-bit or 64-bit read.  Big endian objects on the
>> other hand do not work at all with this error.
>>
>> The fix:  Correctly treat sh_flags as 64-bits wide in elf64 objects.
>>
>> The symptom I observed was that my
>> __start_mcount_loc..__stop_mcount_loc was empty even though ftrace
>> function tracing was enabled.
>>
>
> OUCH!
>
> This looks like something that needs to go to stable. Let me play with
> this on my PPC64 tomorrow.
>

Hi Steven,

Any more feedback on this patch?  Should I look for it to appear in 3.3?

Thanks,
David Daney

> Thanks!
>
> -- Steve
>
>> Signed-off-by: David Daney<david.daney@cavium.com>
>> ---
>>   scripts/recordmcount.h |    2 +-
>>   1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/scripts/recordmcount.h b/scripts/recordmcount.h
>> index f40a6af6..54e35c1 100644
>> --- a/scripts/recordmcount.h
>> +++ b/scripts/recordmcount.h
>> @@ -462,7 +462,7 @@ __has_rel_mcount(Elf_Shdr const *const relhdr,  /* is SHT_REL or SHT_RELA */
>>   		succeed_file();
>>   	}
>>   	if (w(txthdr->sh_type) != SHT_PROGBITS ||
>> -	    !(w(txthdr->sh_flags)&  SHF_EXECINSTR))
>> +	    !(_w(txthdr->sh_flags)&  SHF_EXECINSTR))
>>   		return NULL;
>>   	return txtname;
>>   }
>
>

