Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760014Ab0JFWsK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 18:48:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36970 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759433Ab0JFWsI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 18:48:08 -0400
Message-ID: <4CACFC9D.3010803@zytor.com>
Date: Wed, 06 Oct 2010 15:47:57 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Yinghai Lu <yinghai@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] memblock: Fix big size with find_region()
References: <4CA1ABA4.6070803@kernel.org>	<20101006140604.982b22d6.akpm@linux-foundation.org>	<4CACF453.5020205@zytor.com> <20101006154503.db30e742.akpm@linux-foundation.org>
In-Reply-To: <20101006154503.db30e742.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/2010 03:45 PM, Andrew Morton wrote:
> 
> whomeidunno.  The question is "is this something we want to know
> about".  If it's a BIOS/acpi/whatever error then I'd think "yes",
> because that would then lead to useful kernel workarounds or BIOS
> updates?

I don't think it's inherently that... it could be in some cases, but not
in others.  In either case, an allocation failure should be handled in
the calling layer... or we have a much more serious problem.

However, I suspect the most common case where we'll hit this is when
something wants to fit inside a chunk where it simply doesn't fit ...
and it'll either move on to the next plausible chunk or fail at that point.

	-hpa
