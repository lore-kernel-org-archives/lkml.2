Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761352Ab2D0Uac (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 16:30:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40155 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760531Ab2D0Uab (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 16:30:31 -0400
Message-ID: <4F9B01A9.3000007@zytor.com>
Date: Fri, 27 Apr 2012 13:29:29 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Mike Frysinger <vapier@gentoo.org>
CC: Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        uclinux-dist-devel@blackfin.uclinux.org, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 1/2] asm-generic: io: remove {read,write} string functions
References: <1335523376-14695-1-git-send-email-will.deacon@arm.com> <201204271217.50048.vapier@gentoo.org>
In-Reply-To: <201204271217.50048.vapier@gentoo.org>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27/2012 09:17 AM, Mike Frysinger wrote:
> On Friday 27 April 2012 06:42:55 Will Deacon wrote:
>> The {read,write}s{b,w,l} functions are not defined across all 
>> architectures and therefore shouldn't be used by portable
>> drivers. We should encourage driver writers to use the
>> io{read,write}{8,16,32}_rep functions instead.
> 
> well, that isn't true today as a grep of the drivers/ tree shows.
> perhaps we should fix that first ?  quite a number of architectures
> do implement these.
> 
>> This patch removes the {read,write} string functions for the
>> generic IO header as they have no place in a new architecture
>> port.
> 
> i don't see any file anywhere that describes what the baseline API
> is supposed to be, and what each set of funcs are for.  there is
> just the random ugliness in each arch's asm/io.h cobbled together
> until things work.  i think that also needs to be addressed before
> we go extending/contracting the API provides by asm-generic/io.h.

And it's is much bigger than asm-generic/io.h, as evidenced by some
other recent events.

For example, we need streaming I/O (memory and I/O) with specific
access sizes, for example.

	-hpa


