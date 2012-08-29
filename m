Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639Ab2H2VCm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 17:02:42 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:43198 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000Ab2H2VCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 17:02:41 -0400
MIME-Version: 1.0
In-Reply-To: <1346267046-6724-6-git-send-email-jacob.shin@amd.com>
References: <1346267046-6724-1-git-send-email-jacob.shin@amd.com>
	<1346267046-6724-6-git-send-email-jacob.shin@amd.com>
Date: Wed, 29 Aug 2012 14:02:40 -0700
X-Google-Sender-Auth: BW7BSL7dkaL8KpUSx6MCy4qgJyE
Message-ID: <CAE9FiQUso7DWyGu8Xi3DjZDP3+8xrpow36DOv9KogHFBdjOMmQ@mail.gmail.com>
Subject: Re: [PATCH 5/6] x86: Fixup code testing if a pfn is direct mapped
From: Yinghai Lu <yinghai@kernel.org>
To: Jacob Shin <jacob.shin@amd.com>
Cc: X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Tejun Heo <tj@kernel.org>,
        Dave Young <dyoung@redhat.com>, Chao Wang <chaowang@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 29, 2012 at 12:04 PM, Jacob Shin <jacob.shin@amd.com> wrote:
> Update code that previously assumed pfns [ 0 - max_low_pfn_mapped ) and
> [ 4GB - max_pfn_mapped ) were always direct mapped, to now look up
> pfn_mapped ranges instead.

please swap patch 5 and patch 4 applying sequence.

aka.
should have
[PATCH 4/6] x86:Fixup code testing if a pfn is direct mapped
and it should have dummy function

bool pfn_range_is_mapped(u64 start_pfn, u64 end_pfn)
{
               return  end_pfn <= max_low_pfn_mapped
                   || (end_pfn > (1UL << (32 - PAGE_SHIFT))
                       && end_pfn <= max_pfn_mapped);
}

and

[PATCH 5/6] x86: Only direct map addresses that are marked as E820_RAM
will update pfn_range_is_mapped accordingly.

Thanks

Yinghai
