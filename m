Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753036Ab2JAQES (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 12:04:18 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:41907 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390Ab2JAQER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 12:04:17 -0400
MIME-Version: 1.0
In-Reply-To: <20121001080841.GN4009@amd.com>
References: <1348835046-3262-1-git-send-email-joerg.roedel@amd.com>
	<1348835046-3262-15-git-send-email-joerg.roedel@amd.com>
	<CAKocOONaiMJs7pWeWxO=_bN5_KU=jZh=kvL7U_v-w9LmSrQ+Fw@mail.gmail.com>
	<20121001080841.GN4009@amd.com>
Date: Mon, 1 Oct 2012 10:04:16 -0600
Message-ID: <CAKocOOOLQD6wyA3x5ZtoS-YcbxzOmdSxW9FkH90c+Tt2pkHOfQ@mail.gmail.com>
Subject: Re: [PATCH 14/16] iommu/irq: Use amd_iommu_irq_ops if supported
From: Shuah Khan <shuahkhan@gmail.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 1, 2012 at 2:08 AM, Joerg Roedel <joerg.roedel@amd.com> wrote:
> On Fri, Sep 28, 2012 at 05:39:03PM -0600, Shuah Khan wrote:
>> On Fri, Sep 28, 2012 at 6:24 AM, Joerg Roedel <joerg.roedel@amd.com> wrote:
>> >  void __init setup_irq_remapping_ops(void)
>> >  {
>> >         remap_ops = &intel_irq_remap_ops;
>> > +
>> > +#ifdef CONFIG_AMD_IOMMU
>> > +       if (amd_iommu_irq_ops.prepare() == 0)
>> > +               remap_ops = &amd_iommu_irq_ops;
>> > +#endif
>>
>> Should remap_ops be set to null when amd_iommu_irq_ops.prepare()
>> fails?What happens if remap_ops left set to intel_irq_remap_ops?
>> Should remap_ops = &intel_irq_remap_ops; moved into #else case
>> forifdef CONFIG_AMD_IOMMU?
>
> Remap-Ops does not need to be set to NULL because irq_remapping_enabled
> will not get set to true then and remap_ops will not get called. The
> Intel path can't also be moved to #else because this would mean that
> kernels can only support eihter, Intel or AMD IOMMU. But Linux can
> support both in the same kernel.

Thanks for the explanation.

-- Shuah
