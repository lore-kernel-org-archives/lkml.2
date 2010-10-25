Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756533Ab0JYPvk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 11:51:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37689 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751542Ab0JYPvi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 11:51:38 -0400
Message-ID: <4CC5A748.6050903@zytor.com>
Date: Mon, 25 Oct 2010 08:50:32 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Jan Beulich <JBeulich@novell.com>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        David Howells <dhowells@redhat.com>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Partially revert patch that encloses asm-offset.h numbers
 in brackets
References: <4CC5B1A1020000780001EF7C@vpn.id2.novell.com> <20101025140218.5092.74117.stgit@warthog.procyon.org.uk> <28707.1288018465@redhat.com> <4CC5B8D3020000780001EFB4@vpn.id2.novell.com> <AANLkTi=mpKRQgZp5zCoCsBtkuWHrpkOq2Zch-OOGu4CC@mail.gmail.com>
In-Reply-To: <AANLkTi=mpKRQgZp5zCoCsBtkuWHrpkOq2Zch-OOGu4CC@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/2010 08:17 AM, Linus Torvalds wrote:
> 
> How about just removing the idiotic workaround entirely, and then on
> x86 passing "-traditional" to cpp for asm input so that it doesn't add
> spaces in argument expansion? Make the workaround more targeted to the
> actual problem, rather than working around it in some unrelated
> thing..
> 

We already tried using -traditional, it didn't help the gas braindamage
and it caused severe problems with header files (since -traditional
removes the support for #x and x ## y).  Bringing it back won't help.

As such, the only options I can really think about overriding the sed
expression for x86 or just saying gcc 2.16.90 or later is required...

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.
