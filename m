Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754598Ab2FMUjH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 16:39:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6790 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752231Ab2FMUjF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 16:39:05 -0400
Message-ID: <4FD8FA37.10103@redhat.com>
Date: Wed, 13 Jun 2012 16:38:15 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] MM: Support more pagesizes for MAP_HUGETLB/SHM_HUGETLB
 v2
References: <1339542816-21663-1-git-send-email-andi@firstfloor.org> <4FD8F70F.7080405@redhat.com> <20120613203103.GG11413@one.firstfloor.org>
In-Reply-To: <20120613203103.GG11413@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/13/2012 04:31 PM, Andi Kleen wrote:
> On Wed, Jun 13, 2012 at 04:24:47PM -0400, Rik van Riel wrote:
>> This would also be useful for emulators such as qemu-kvm,
>> which want the guest memory to be 2MB aligned.
>
> hugetlbfs does implicit align, so right now I mash
> the two together and use up many of the remaining bits
>
> If you want align different than page sizes you may need
> to go 64bits with the flags.

All alignment is a power of two, so six bits should
be enough for up to 2^64 pages :)

> Is there a use case for alignment independent of page sizes?

No, but page size differs per architecture and it
would be nice if we could share arch_get_unmapped_area
and related code in mm/, instead of every architecture
having its own.

In fact, that is what I am working on right now, and
my current road block is the page colouring code :)
