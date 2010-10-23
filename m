Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757189Ab0JWNtD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 09:49:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39211 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757044Ab0JWNtC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 09:49:02 -0400
Message-ID: <4CC2E772.5040904@redhat.com>
Date: Sat, 23 Oct 2010 03:47:30 -1000
From: Zachary Amsden <zamsden@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Michael Tokarev <mjt@tls.msk.ru>
CC: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
        greg@kroah.com, stable-review@kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, mtosatti@redhat.com, avi@redhat.com
Subject: Re: [077/103] KVM: x86: Fix SVM VMCB reset
References: <20101022185234.270241682@clark.site> <4CC2B033.7020806@msgid.tls.msk.ru>
In-Reply-To: <4CC2B033.7020806@msgid.tls.msk.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2010 11:51 PM, Michael Tokarev wrote:
> 22.10.2010 22:51, Greg KH wrote:
>    
>> 2.6.35-stable review patch.  If anyone has any objections, please let us know.
>> ------------------
>>
>> From: Marcelo Tosatti<mtosatti@redhat.com>
>>
>> commit 58877679fd393d3ef71aa383031ac7817561463d upstream.
>>
>> On reset, VMCB TSC should be set to zero.  Instead, code was setting
>> tsc_offset to zero, which passes through the underlying TSC.
>>      
> Not an objection, but shouldn't this and subsequent 078 "KVM: x86: Move
> TSC reset out of vmcb_init" patches be applied to 2.6.32 too?  The same
> problem exists in 2.6.32, and the two patches allows an smp linux guest
> to boot in there, or such a guest just hangs at boot.  (078 patch needs
> to be adjusted a bit for 2.6.32, since the code there is a bit different
> and it does not apply correctly; but the change is trivial).
>
>    

I concur, although it's possible the backport could go even further.  
The problem has existed for some time, but only because of recent 
changes to selection of default clocksource as well as host side changes 
has it become an issue.

Zach
