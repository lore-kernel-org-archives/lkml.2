Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756907Ab0I1QwV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 12:52:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47020 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755200Ab0I1QwU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 12:52:20 -0400
Message-ID: <4CA21D34.7010209@zytor.com>
Date: Tue, 28 Sep 2010 09:52:04 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Andreas Herrmann <andreas.herrmann3@amd.com>
CC: Jan Beulich <JBeulich@novell.com>, "Seidel, Conny" <Conny.Seidel@amd.com>,
        "borislav.petkov" <borislav.petkov@amd.com>,
        "mingo@elte.hu" <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: current TIP/master doesn't build on SLES10
References: <20100928163136.7a2355d0@marah.osrc.amd.com> <4CA22F1D020000780001961F@vpn.id2.novell.com> <20100928161912.GF5003@loge.amd.com>
In-Reply-To: <20100928161912.GF5003@loge.amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/28/2010 09:19 AM, Andreas Herrmann wrote:
> On Tue, Sep 28, 2010 at 12:08:29PM -0400, Jan Beulich wrote:
>>>>> On 28.09.10 at 16:31, Conny Seidel <conny.seidel@amd.com> wrote:
>>> Hi
>>>
>>> compiling TIP/master (44bc8c4f500fce7263803b4acd016fa03cf8a91a) on
>>> SLES10 fails with the following build error:
>>>
>>> arch/x86/kernel/entry_64.S: Assembler messages:
>>> arch/x86/kernel/entry_64.S:1181: Error: too many positional arguments
>>> arch/x86/kernel/entry_64.S:1181: Error: too many positional arguments
>>> make[2]: *** [arch/x86/kernel/entry_64.o] Error 1
>>> make[1]: *** [arch/x86/kernel] Error 2
>>> make: *** [arch/x86] Error 2
>>>
>>> I've bisected it to commit df5d1874ce1a1f0e0eceff4fa3a9d45620243a68.
>>>
>>> Reverting it fixes the issue. 
>>>
>>> I know that this is caused by binutils 2.16.91.0.5 which is distributed
>>> with SLES10.
>>
>> I'm generally doing almost all of my work on SLE10, and have not run
>> into this issue. Are you sure you've got it fully updated?
> 
> BTW, the build error looks similar to the build problem fixed by
> 
>   commit e8a0e27662186f8856a0a6242e7a8386c9a64a53
>   Author: Ingo Molnar <mingo@elte.hu>
>   Date:   Fri Nov 21 15:11:32 2008 +0100
> 
>     x86: clean up after: move entry_64.S register saving out of the macros, fix
> 

Well, yes of course... it can be summarized as "macros in binutils 2.16
are broken beyond anyone's wildest beliefs".

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

