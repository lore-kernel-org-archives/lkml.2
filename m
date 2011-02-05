Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753051Ab1BESGW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 13:06:22 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:27471 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752765Ab1BESGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 13:06:20 -0500
Message-ID: <4D4D911A.5080001@oracle.com>
Date: Sat, 05 Feb 2011 10:04:10 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Subject: Re: [patch fixup] memcg: remove direct page_cgroup-to-page pointer
 fix
References: <201102042349.p14NnQEm025834@imap1.linux-foundation.org> <20110204183810.76baf8f0.randy.dunlap@oracle.com> <20110205090451.GA2315@cmpxchg.org>
In-Reply-To: <20110205090451.GA2315@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4D4D9177.002E:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/11 01:04, Johannes Weiner wrote:
> On Fri, Feb 04, 2011 at 06:38:10PM -0800, Randy Dunlap wrote:
>> On Fri, 04 Feb 2011 15:15:17 -0800 akpm@linux-foundation.org wrote:
>>
>>> The mm-of-the-moment snapshot 2011-02-04-15-15 has been uploaded to
>>>
>>>    http://userweb.kernel.org/~akpm/mmotm/
>>>
>>> and will soon be available at
>>>
>>>    git://zen-kernel.org/kernel/mmotm.git
>>>
>>> It contains the following patches against 2.6.38-rc3:
>>
>>
>> Lots of these warnings in some kernel configs:
>>
>> mmotm-2011-0204-1515/include/linux/page_cgroup.h:144: warning: left shift count >= width of type
>> mmotm-2011-0204-1515/include/linux/page_cgroup.h:145: warning: left shift count >= width of type
>> mmotm-2011-0204-1515/include/linux/page_cgroup.h:150: warning: right shift count >= width of type
> 
> Thanks for the report, Randy, and sorry for the breakage.  Here is the
> fixup:
> 
> ---
> Since the non-flags field for pc array ids in pc->flags is offset from
> the end of the word, we end up with a shift count of BITS_PER_LONG in
> case the field width is zero.
> 
> This results in a compiler warning as we shift in both directions a
> long int by BITS_PER_LONG.
> 
> There is no real harm -- the mask is zero -- but fix up the compiler
> warning by also making the shift count zero for a non-existant field.
> 
> Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> ---

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

Thanks.

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
