Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757761Ab0JWQCr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 12:02:47 -0400
Received: from kroah.org ([198.145.64.141]:44113 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755502Ab0JWQCp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 12:02:45 -0400
Date: Sat, 23 Oct 2010 08:59:10 -0700
From: Greg KH <greg@kroah.com>
To: Zachary Amsden <zamsden@redhat.com>
Cc: Michael Tokarev <mjt@tls.msk.ru>, mtosatti@redhat.com,
        Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        stable@kernel.org, avi@redhat.com, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable-review@kernel.org,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [stable] [077/103] KVM: x86: Fix SVM VMCB reset
Message-ID: <20101023155910.GB19447@kroah.com>
References: <20101022185234.270241682@clark.site> <4CC2B033.7020806@msgid.tls.msk.ru> <4CC2E772.5040904@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CC2E772.5040904@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 23, 2010 at 03:47:30AM -1000, Zachary Amsden wrote:
> On 10/22/2010 11:51 PM, Michael Tokarev wrote:
>> 22.10.2010 22:51, Greg KH wrote:
>>    
>>> 2.6.35-stable review patch.  If anyone has any objections, please let us know.
>>> ------------------
>>>
>>> From: Marcelo Tosatti<mtosatti@redhat.com>
>>>
>>> commit 58877679fd393d3ef71aa383031ac7817561463d upstream.
>>>
>>> On reset, VMCB TSC should be set to zero.  Instead, code was setting
>>> tsc_offset to zero, which passes through the underlying TSC.
>>>      
>> Not an objection, but shouldn't this and subsequent 078 "KVM: x86: Move
>> TSC reset out of vmcb_init" patches be applied to 2.6.32 too?  The same
>> problem exists in 2.6.32, and the two patches allows an smp linux guest
>> to boot in there, or such a guest just hangs at boot.  (078 patch needs
>> to be adjusted a bit for 2.6.32, since the code there is a bit different
>> and it does not apply correctly; but the change is trivial).
>>
>>    
>
> I concur, although it's possible the backport could go even further.  The 
> problem has existed for some time, but only because of recent changes to 
> selection of default clocksource as well as host side changes has it become 
> an issue.

Ok, please work with the KVM maintainers then, as they are the ones who
send -stable patches to me.

thanks,

greg k-h
