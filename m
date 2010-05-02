Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758285Ab0EBRpM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 May 2010 13:45:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20254 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758183Ab0EBRpK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 May 2010 13:45:10 -0400
Message-ID: <4BDDBA18.3080909@redhat.com>
Date: Sun, 02 May 2010 20:44:56 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Brian Gerst <brgerst@gmail.com>
CC: Dexuan Cui <dexuan.cui@intel.com>, Sheng Yang <sheng@linux.intel.com>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 1/2] x86: eliminate TS_XSAVE
References: <1272812038-32484-1-git-send-email-avi@redhat.com>	 <1272812038-32484-2-git-send-email-avi@redhat.com> <u2p73c1f2161005021038gce35c1bbpca6ec119d24e646e@mail.gmail.com>
In-Reply-To: <u2p73c1f2161005021038gce35c1bbpca6ec119d24e646e@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/02/2010 08:38 PM, Brian Gerst wrote:
> On Sun, May 2, 2010 at 10:53 AM, Avi Kivity<avi@redhat.com>  wrote:
>    
>> The fpu code currently uses current->thread_info->status&  TS_XSAVE as
>> a way to distinguish between XSAVE capable processors and older processors.
>> The decision is not really task specific; instead we use the task status to
>> avoid a global memory reference - the value should be the same across all
>> threads.
>>
>> Eliminate this tie-in into the task structure by using an alternative
>> instruction keyed off the XSAVE cpu feature; this results in shorter and
>> faster code, without introducing a global memory reference.
>>      
> I think you should either just use cpu_has_xsave, or extend this use
> of alternatives to all cpu features.  It doesn't make sense to only do
> it for xsave.
>    

I was trying to avoid a performance regression relative to the current 
code, as it appears that some care was taken to avoid the memory reference.

I agree that it's probably negligible compared to the save/restore 
code.  If the x86 maintainers agree as well, I'll replace it with 
cpu_has_xsave.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

