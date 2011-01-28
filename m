Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755213Ab1A1Omu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 09:42:50 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58454 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755032Ab1A1Oms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 09:42:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=OOM62gOix7cn9Ga32CBS1Vp5vRLeVAfeedQxCMunrz2D6Ytq+sN+vHO+VLIGSfThYF
         vVwqL4PTwtCjjz6dsF7e17anfr0F+B8NvMzSCHi0jteeuxaq4/kbnCHfKdlpQ9qNVF5T
         3rBxno/DTRbqMPUUi0Niw4wfKq5PlDqmYW3hI=
MIME-Version: 1.0
In-Reply-To: <20110127212001.GC4542@dumpdata.com>
References: <1294420304-24811-1-git-send-email-konrad.wilk@oracle.com>
	<1294420304-24811-5-git-send-email-konrad.wilk@oracle.com>
	<20110127212001.GC4542@dumpdata.com>
Date: Fri, 28 Jan 2011 09:42:48 -0500
Message-ID: <AANLkTimKgfKwtWpXBvTGmJbW-2uGhV+7nMahsScUM0pr@mail.gmail.com>
Subject: Re: [PATCH 4/5] radeon/ttm/PCIe: Use dma_addr if TTM has set it.
From: Jerome Glisse <j.glisse@gmail.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: dri-devel@lists.freedesktop.org, thomas@shipmail.org, airlied@linux.ie,
        linux-kernel@vger.kernel.org, Alex Deucher <alexdeucher@gmail.com>,
        Jerome Glisse <jglisse@redhat.com>, konrad@darnok.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 27, 2011 at 4:20 PM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
> On Fri, Jan 07, 2011 at 12:11:43PM -0500, Konrad Rzeszutek Wilk wrote:
>> If the TTM layer has used the DMA API to setup pages that are
>> TTM_PAGE_FLAG_DMA32 (look at patch titled: "ttm: Utilize the dma_addr_t
>> array for pages that are to in DMA32 pool."), lets use it
>> when programming the GART in the PCIe type cards.
>>
>> This patch skips doing the pci_map_page (and pci_unmap_page) if
>> there is a DMA addresses passed in for that page. If the dma_address
>> is zero (or DMA_ERROR_CODE), then we continue on with our old
>> behaviour.
>
> Hey Jerome,
>
> I should have CC-ed you earlier but missed that and instead just
> CC-ed the mailing list. I was wondering what your thoughts are
> about this patchset? Thomas took a look at the patchset and he is OK
> but more eyes never hurt.
>
> FYI, for clarity I hadn't made the old calls that got moved due
> to adding of "{" checkpatch.pl compliant. It complains about it being
> past 80 characters. I can naturally fix that up, but thought
> that it might detract from the nature of the patch.

What happen when we don't ask dma32 alloc to ttm ? Will this still
work in virtualized environnement ?

Code looks good but GART stuff can be picky, i will try to do a full
scale testing in next couple week.

Cheers,
Jerome
