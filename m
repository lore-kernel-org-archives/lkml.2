Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932144Ab1I2XQd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 19:16:33 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:39813 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756771Ab1I2XQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 19:16:31 -0400
Message-ID: <4E84FC4D.3080506@xenotime.net>
Date: Thu, 29 Sep 2011 16:16:29 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.22) Gecko/20110907 SUSE/3.1.14 Thunderbird/3.1.14
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH -next] x86 mrst: fix build error when X86_MRST is not
 enabled
References: <20110929165730.661cf28c9bb27b8a85432cd2@canb.auug.org.au>	<4E84D684.107@xenotime.net> <20110929235708.1bbd1166@lxorguk.ukuu.org.uk>
In-Reply-To: <20110929235708.1bbd1166@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/29/11 15:57, Alan Cox wrote:
> On Thu, 29 Sep 2011 13:35:16 -0700
> Randy Dunlap <rdunlap@xenotime.net> wrote:
> 
>> From: Randy Dunlap <rdunlap@xenotime.net>
>>
>> Fix build when CONFIG_X86_INTEL_MID is enabled but
>> CONFIG_X86_MRST is not enabled.  Fixes this build error:
> 
> This looks wrong. Unfortunately until we get kernel.org back its hard to
> do much about it and see what is in all the trees.
> 
>> -#ifdef CONFIG_X86_INTEL_MID
>> +#ifdef CONFIG_X86_MRST
>>  
>>  static inline enum mrst_cpu_type mrst_identify_cpu(void)
>>  {
>>  	return __mrst_cpu_chip;
>>  }
>>  
>> -#else /* !CONFIG_X86_INTEL_MID */
>> +#else /* !CONFIG_X86_MRST */
>>  
>>  #define mrst_identify_cpu()    (0)
>>  
>> -#endif /* !CONFIG_X86_INTEL_MID */
>> +#endif /* !CONFIG_X86_MRST */
> 
> This breaks Medfield so NAK
> 
> The correct behaviour should be 
> 
> INTEL_MID defined -> mrst_cpu_chip has meaning
> INTEL_MID not defined -> mrst_identify_chip is 0
> 
> your change makes it 0 for Medfield which means it will crash on boot.

arch/x86/platform/mrst/mrst.c -- where __mrst_cpu_chip lives --
is only built when CONFIG_X86_MRST is enabled.  You make it sound like
__mrst_cpu_chip needs to live any time that CONFIG_X86_INTEL_MID
is enabled, which sounds reasonable to me.

caveat:  given the current linux-next merge trees (as you mentioned).

Does anyone care?  If so, please help fix this muck.


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
