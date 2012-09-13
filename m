Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573Ab2IMSmR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 14:42:17 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:55790 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828Ab2IMSmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 14:42:15 -0400
MIME-Version: 1.0
In-Reply-To: <CADnq5_OWLhvmGDaqCPDLk1Q_xpDFi9j4csOsdJ8uwMEV53dm1A@mail.gmail.com>
References: <1347545629-3474-1-git-send-email-Dmitrii.Cherkasov@amd.com>
	<CAH3drwZzMX_6fUkgWMf+vMz9+kyNQs6t3m-1W9aSjDJA2E_qEA@mail.gmail.com>
	<CADnq5_OWLhvmGDaqCPDLk1Q_xpDFi9j4csOsdJ8uwMEV53dm1A@mail.gmail.com>
Date: Thu, 13 Sep 2012 14:42:11 -0400
Message-ID: <CAH3drwZeW5zEswqcSfFvovBM_SGERCpoW99_G_NabyA1yERrUQ@mail.gmail.com>
Subject: Re: [PATCH] Add 2-level GPUVM pagetables support to radeon driver.
From: Jerome Glisse <j.glisse@gmail.com>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: Dmitry Cherkasov <dcherkassov@gmail.com>,
        Dmitry Cherkasov <Dmitrii.Cherkasov@amd.com>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Alex Deucher <alexander.deucher@amd.com>,
        Dave Airlie <airlied@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2012 at 2:37 PM, Alex Deucher <alexdeucher@gmail.com> wrote:
> On Thu, Sep 13, 2012 at 2:17 PM, Jerome Glisse <j.glisse@gmail.com> wrote:
>> On Thu, Sep 13, 2012 at 10:13 AM, Dmitry Cherkasov
>> <dcherkassov@gmail.com> wrote:
>>> PDE/PTE update code uses CP ring for memory writes.
>>> All page table entries are preallocated for now in alloc_pt().
>>>
>>> It is made as whole because it's hard to divide it to several patches
>>> that compile and doesn't break anything being applied separately.
>>>
>>> Tested on cayman card.
>>>
>>> Signed-off-by: Dmitry Cherkasov <Dmitrii.Cherkasov@amd.com>
>>> ---
>>> I couldn't test in on SI card, so would be happy if someone could check it there.
>>
>> I wonder how this could have work as you don't set
>> PAGE_TABLE_BLOCK_SIZE field so each page directory entry cover only 1
>> page.
>
> I think PAGE_TABLE_BLOCK_SIZE refers number of 4k pages used for PTE
> entries per PDE.  E.g., 1 4k page contains 512 64 bit PTEs. so if
> BLOCK_SIZE is set to 1 page, each PDE points to 1 page (4k) or PTE
> entries.  If BLOCK_SIZE is 2, each PDE points to 2 pages (8k) or PTEs,
> etc.
>
> Alex
>

If so then it's ok

Cheers,
Jerome
