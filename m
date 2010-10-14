Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754325Ab0JNCim (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 22:38:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38349 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754072Ab0JNCim (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 22:38:42 -0400
X-User-Agent: K-9 Mail for Android
References: <alpine.DEB.2.00.1010131713160.24646@chino.kir.corp.google.com> <4CB64D8F.9080800@zytor.com> <alpine.DEB.2.00.1010131739010.27124@chino.kir.corp.google.com> <4CB65262.3070507@zytor.com> <alpine.DEB.2.00.1010131744540.27124@chino.kir.corp.google.com> <cbd8b37e-a1a3-4275-8acb-a76476211366@email.android.com> <alpine.DEB.2.00.1010131832400.794@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1010131832400.794@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: Re: [patch] x86: allow ZONE_DMA to be configurable
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Wed, 13 Oct 2010 19:38:03 -0700
To: David Rientjes <rientjes@google.com>
CC: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Casey Dahlin <cdahlin@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <2d51a48e-0413-4bfb-b877-f6ebc4642f14@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

How do you know it is not a fatal condition?

"David Rientjes" <rientjes@google.com> wrote:

>On Wed, 13 Oct 2010, H. Peter Anvin wrote:
>
>> And the value of those additional options is what?  I'd consider adding 
>> this to the sewer pit called CONFIG_EMBEDDED (with a BUG_ON, not a 
>> warning... sheesh)
>
>BUG_ON() could panic the machine which would be rather unfortunate if we 
>simply tried to load a driver that the kernel no longer supports because 
>it doesn't have DMA.  A WARN_ON() seems much more appropriate to identify 
>what the problem was.  It's not a fatal condition.
>
>> but only if there is any demonstrable value other 
>> than a trivial amount of code (kilobytes?) in exchange for a bunch of 
>> crap #ifdef.
>> 
>
>The data savings is about 1% and the text savings is about 0.1% with all 
>three options disabled:
>
>7922297	1245500	 989600	10157397	 9afd55	vmlinux.before
>7914674	1232700	 989472	10136846	 9aad0e	vmlinux.after
>
>This is the only #ifdef necessary to make CONFIG_ZONE_DMA=n compile and 
>CONFIG_GENERIC_ISA_DMA=n would require two additional #ifdefs 
>(CONFIG_ISA_DMA_API=n would require none).  We carry this patch 
>internally, so it would be trivial to send follow-up patches that do that 
>if this patch is merged.

-- 
Sent from my mobile phone.  Please pardon any lack of formatting.
