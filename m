Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753098Ab2FLRtS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 13:49:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43942 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752040Ab2FLRtR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 13:49:17 -0400
Message-ID: <4FD780D2.603@zytor.com>
Date: Tue, 12 Jun 2012 10:48:02 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Nicolas Pitre <nicolas.pitre@linaro.org>
CC: Lasse Collin <lasse.collin@tukaani.org>, T Makphaibulchoke <tmac@hp.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, linux390@de.ibm.com,
        lethal@linux-sh.org, tglx@linutronix.de, mingo@redhat.com,
        x86@kernel.org, kaloz@openwrt.org, jj@chaosbits.net,
        matt.fleming@intel.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-sh@vger.kernel.org
Subject: Re: [PATCH v2] lib/decompress_unxz.c: removing all memory helper
 functions
References: <1339470307-28223-1-git-send-email-tmac@hp.com> <20120612191804.4211462a@tukaani.org> <alpine.LFD.2.02.1206121316190.23555@xanadu.home> <4FD77CAF.1020402@zytor.com> <alpine.LFD.2.02.1206121336060.23555@xanadu.home>
In-Reply-To: <alpine.LFD.2.02.1206121336060.23555@xanadu.home>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2012 10:44 AM, Nicolas Pitre wrote:
> On Tue, 12 Jun 2012, H. Peter Anvin wrote:
> 
>> On 06/12/2012 10:26 AM, Nicolas Pitre wrote:
>>>
>>> Instead of copying, maybe this would be much better to make the content 
>>> of lib/string.c usable in a pre-boot environment.
>>>
>>
>> Not sure about that... a lot of it is #ifndef __HAVE_ARCH_* and you
>> *really* want those optimizations on some arches.
> 
> Sure.  What about:
> 
> lib/boot/mem.c: lib/string.c
> 	sed 's/^#ifndef __HAVE_ARCH_/#ifndef __HAVE_PREBOOT_ARCH_/' < $< > $@
> 
> This is over simplified but you get the idea.  Maybe lib/string.c itself 
> should be split into several files to help with a finer grained 
> selection.
> 

The point is that I think we pretty much end up with a null usable set
in the end.

	-hpa

