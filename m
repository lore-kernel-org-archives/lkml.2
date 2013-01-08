Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750868Ab3AHFD6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 00:03:58 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57320 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750718Ab3AHFD5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 00:03:57 -0500
Message-ID: <50EBA8AB.2060003@zytor.com>
Date: Mon, 07 Jan 2013 21:03:39 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Shaohua Li <shli@kernel.org>
CC: Rik van Riel <riel@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        mingo@redhat.com, hughd@google.com
Subject: Re: [RFC]x86: clearing access bit don't flush tlb
References: <20130107081213.GA21779@kernel.org> <50EAE66B.1020804@redhat.com> <50EB4CB9.9010104@zytor.com> <20130108045519.GB2459@kernel.org>
In-Reply-To: <20130108045519.GB2459@kernel.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/2013 08:55 PM, Shaohua Li wrote:
> 
> I searched a little bit, the change (doing TLB flush to clear access bit) is
> made between 2.6.7 - 2.6.8, I can't find the changelog, but I found a patch:
> http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.7-rc2/2.6.7-rc2-mm2/broken-out/mm-flush-tlb-when-clearing-young.patch
> 
> The changelog declaims this is for arm/ppc/ppc64.
> 

Not really.  It says that those have stumbled over it already.  It is
true in general that this change will make very frequently used pages
(which stick in the TLB) candidates for eviction.

x86 would seem to be just as affected, although possibly with a
different frequency.

Do we have any actual metrics on anything here?

	-hpa

