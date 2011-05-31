Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932350Ab1EaSk6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 14:40:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50455 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932176Ab1EaSk5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 14:40:57 -0400
Message-ID: <4DE5360D.5070809@zytor.com>
Date: Tue, 31 May 2011 11:40:13 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Matthew Garrett <mjg@redhat.com>
CC: Dan Rosenberg <drosenberg@vsecurity.com>, Tony Luck <tony.luck@gmail.com>,
        linux-kernel@vger.kernel.org, kees.cook@canonical.com,
        davej@redhat.com, torvalds@linux-foundation.org, adobriyan@gmail.com,
        eranian@google.com, penberg@kernel.org, davem@davemloft.net,
        Arjan van de Ven <arjan@infradead.org>, Valdis.Kletnieks@vt.edu,
        Andrew Morton <akpm@linux-foundation.org>, pageexec@freemail.hu,
        Ingo Molnar <mingo@elte.hu>, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [RFC][PATCH] Randomize kernel base address on boot
References: <1306269105.21443.20.camel@dan> <1306442367.2279.25.camel@dan> <20110531165252.GB8971@srcf.ucam.org>
In-Reply-To: <20110531165252.GB8971@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/31/2011 09:52 AM, Matthew Garrett wrote:
> On Thu, May 26, 2011 at 04:39:27PM -0400, Dan Rosenberg wrote:
> 
>> 1. I'm nearly finished a first draft of code to parse the BIOS E820
>> memory map to determine where it's safe to place the randomized kernel.
>> This code accounts for overlapping regions, as well as potential
>> conflicts in region types (free vs. reserved, etc.), in favor of
>> non-free types.  The end result is, I'll have a reasonable upper bound.
> 
> The BIOS E820 map, or the kernel representation? In either case, this 
> isn't going to work well with EFI. There are regions that will be marked 
> as available in the E820 map that we *mustn't* touch until we've entered 
> EFI virtual mode.
> 
> (This is, clearly, insane).
> 

I believe we could (should!) mark them reserved, not available, in the
E820 map and free them later.

	-hpa
