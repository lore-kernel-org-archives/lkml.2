Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423678Ab2LFPDx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 10:03:53 -0500
Received: from multi.imgtec.com ([194.200.65.239]:56806 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423662Ab2LFPDw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 10:03:52 -0500
Message-ID: <50C0B3D5.50707@imgtec.com>
Date: Thu, 6 Dec 2012 15:03:49 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Arnd Bergmann" <arnd@arndb.de>
Subject: Re: [PATCH v2 12/44] metag: TBX source
References: <1354723742-6195-1-git-send-email-james.hogan@imgtec.com>  <1354723742-6195-13-git-send-email-james.hogan@imgtec.com>  <1354733607.8320.3.camel@joe-AO722> <50C066D9.9010700@imgtec.com> <1354798778.17565.8.camel@joe-AO722>
In-Reply-To: <1354798778.17565.8.camel@joe-AO722>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2012_12_06_15_03_50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/12 12:59, Joe Perches wrote:
> On Thu, 2012-12-06 at 09:35 +0000, James Hogan wrote:
>> On 05/12/12 18:53, Joe Perches wrote:
>>> On Wed, 2012-12-05 at 16:08 +0000, James Hogan wrote:
>>>> Add source files from the Thread Binary Interface (TBI) library which
>>>> provides useful low level operations and traps/context management.
>>> []
>>>>  arch/metag/tbx/tbicache.c  |  462 ++++++++++++++++++++++++++++++++++++++++++++
>>>
>>> Could you please run checkpatch on this file?
>>
>> Hi Joe,
>>
>> Thanks for taking a look.
>>
>> I'd prefer to avoid making style modifications to the tbx/ files if
>> possible to ease maintenance, as the code is shared with other projects
>> and maintained by a separate group.
>>
>> Of course if cleaning up the style is deemed absolutely necessary then
>> so be it.
> 
> Your choice though the file looks to me to be linux
> specific as it uses #include <linux/stddef.h>

Yes, I have rearranged the TBX headers and includes a bit, including
this one to get the definition of NULL, but have avoided making changes
to the actual code so far.

> 
> Also, two functions, __TBIDataCacheFlush and
> __TBICodeCacheFlush, have an unnecessary indentation
> level after a test and return.

> void __TBICodeCacheFlush( const void *pStart, int Bytes )
> {
> 	volatile int *pCtrl = (volatile int *) SYSC_CACHE_MMU_CONFIG;
> 
> 	if ( !__TBICacheDoneInit )
> 		__TBICacheInit();
> 
> 	if ( (pCtrl[0] & SYSC_CMMUCFG_IC_ON_BIT) == 0 )
> 	{
> 		/* No need to flush the code cache it's not actually enabled */
> 		return;
> 	} 
> 
> 	{
> 		/* Use a sequence of writes to flush the cache region requested */	
> 		int Loops, Step;
> 
> 		etc.
> 
> I believe the automatics in the second blocks should
> be moved to the start of the function and the
> unnecessary braces and extra indentation removed.
> 

TBI_GETREG reads a control register so the compiler won't be able to
move it, so these should probably be kept in the same order, but yes I
agree with moving the declarations to the top and getting rid of the
extra indentation.

tbh since there are only 2 tbx/*.c files and they're both small, I'll
clean them both up properly.

Thanks
James

