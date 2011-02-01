Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753661Ab1BAQbf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 11:31:35 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49290 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751948Ab1BAQbe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 11:31:34 -0500
Message-ID: <4D483518.6080404@zytor.com>
Date: Tue, 01 Feb 2011 08:30:16 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: castet.matthieu@free.fr
CC: Ingo Molnar <mingo@elte.hu>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-security-module@vger.kernel.org, Matthias Hopf <mhopf@suse.de>,
        rjw@sisk.pl, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] NX protection for kernel data : fix 32 bits S3 suspend
References: <4D473FD5.1090903@free.fr> <20110201080223.GB20372@elte.hu> <1296566732.4d4809cc1f963@imp.free.fr>
In-Reply-To: <1296566732.4d4809cc1f963@imp.free.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/2011 05:25 AM, castet.matthieu@free.fr wrote:
>
> The proper fix will be done in 2.6.29, when S3 resume 32 bit trampoline will be
> merged with 64 bit (ie call smp trampoline) [1]
>

That's insufficient; the actual unified lowmem trampoline allocator 
should take care of that bit per se.

However, the bottom line seems to be that this patch was done with some 
extreme lack of care.  To really be proper, every allocation from the 
get go -- including the brk and memblock based ones -- should be tagged 
with their execution status, and that information should be used, not 
some magic ranges.

	-hpa
