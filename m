Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753052Ab1K1RDX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 12:03:23 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:5127 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878Ab1K1RDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 12:03:21 -0500
Message-ID: <4ED3BED8.4000000@caviumnetworks.com>
Date: Mon, 28 Nov 2011 09:03:20 -0800
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: David Howells <dhowells@redhat.com>, David Daney <ddaney.cavm@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "ralf@linux-mips.org" <ralf@linux-mips.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        David Rientjes <rientjes@google.com>, DM <dm.n9107@gmail.com>,
        David Daney <david.daney@cavium.com>,
        "Pinski, Andrew" <Andrew.Pinski@caviumnetworks.com>
Subject: Re: [PATCH v3 0/2] Stop some of the abuse of BUG() where compile
 time checks should be used.
References: <1322092017-21471-1-git-send-email-ddaney.cavm@gmail.com> <CA+55aFwjUVhff6jADOSvAn=t4CTVf4ZODTNm7M6vYcmG6TikPA@mail.gmail.com> <4ECD91E4.5090504@gmail.com> <20469.1322130295@redhat.com>  <CA+55aFx9x7Q0urXJHk7g2Fxqot0J=9YxaWcdmduwy=sm0DOduA@mail.gmail.com>
In-Reply-To: <CA+55aFx9x7Q0urXJHk7g2Fxqot0J=9YxaWcdmduwy=sm0DOduA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Nov 2011 17:03:20.0771 (UTC) FILETIME=[A1A62130:01CCADEF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24/2011 10:31 AM, Linus Torvalds wrote:
> On Thu, Nov 24, 2011 at 2:24 AM, David Howells<dhowells@redhat.com>  wrote:
>>
>> Have you tried asking the gcc folks if this is likely to get fixed soon?
>
> I actually don't think it's a bug. The error message is associated
> with the function declaration symbol, so it actually makes sense that
> there can be only one error message per callee - not per caller.
>

Yes, that is correct.

> Using "__LINE__" to then create fairly unique symbols (modulo
> #include, of course) gets around it in a pretty natural way as ddaney
> said, so if we care enough.  I don't think it's a big issue (as
> mentioned, I'd worry more about us making sure it's reliable enough to
> be used - we've had gcc sometimes fail to compile things out just
> because some optimization was not working well enough).
>

Since these are *build* bugs, they are of a different nature than the 
*runtime* variety.  They will never be seen at random times by someone 
running the kernel, so making it easier to determine their cause is less 
important.  Really, I would expect it to never really be an issue.

We will always know which file is the culprit.  Finding the line number 
can be done like this:

objdump -r $file | grep build_bug | addr2line -e $file

David Daney
