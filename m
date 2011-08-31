Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756166Ab1HaNsp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 09:48:45 -0400
Received: from smtp-out.google.com ([74.125.121.67]:5929 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755790Ab1HaNsk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 09:48:40 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=gkv/aiwSMz5xDx50TXFWA8HSQOJ2DGyD4v8G8HKKERsGSotU2Gbv8bonowI763fSn
	MZdVfaxg49XiaD7hWL+Tg==
MIME-Version: 1.0
In-Reply-To: <4E5DBDB0.4070505@mips.com>
References: <1314349633-13155-1-git-send-email-dczhu@mips.com>
 <CAErSpo5PgXs4tuihh_JZCePzD8FWWzwp=-VHxFGCCuRKRKOYFQ@mail.gmail.com>
 <CAErSpo506Mz3QSxxdpbxyCUuZvqMTNL+fT5R81ivoj7cDTFyJg@mail.gmail.com> <4E5DBDB0.4070505@mips.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 31 Aug 2011 07:48:16 -0600
Message-ID: <CAErSpo69wROKy-4jtFteeSTUSWXiX+qk7YQTvcotstCL=cjUdA@mail.gmail.com>
Subject: Re: [PATCH v3 0/2] Pass resources to pci_create_bus() and fix MIPS
 PCI resources
To: Deng-Cheng Zhu <dczhu@mips.com>
Cc: jbarnes@virtuousgeek.org, ralf@linux-mips.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mips@linux-mips.org, eyal@mips.com,
        zenon@mips.com, dengcheng.zhu@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 30, 2011 at 10:50 PM, Deng-Cheng Zhu <dczhu@mips.com> wrote:
> Hi, Bjorn
>
>
> Thanks for your constructive review.
>
>> One logistical issue here is that the first patch touches several
>> architectures at once, which puts Jesse in a bit of a pinch.  If he
>> applies it, there's always the possibility that an arch patch will
>> conflict with it, which makes merging harder.
>
> In case the conflicts happen, the effort to resolve them should be
> trivial (a matter of an extra NULL argument), I suppose. Also, the odds
> of other incoming arch patches making a reference to pci_create_bus()
> should not be great.
>
>> It might be easier if, instead of changing the pci_create_bus()
>> interface, you added a new one (it could call pci_create_bus() then
>> replace the resources, so the implementation could still be mostly
>> shared.)  We already have a plethora of "create bus" methods
>> (pci_create_bus(), pci_scan_bus_parented(), pci_scan_bus()), but if
>> you added a pci_create_root_bus() or something similar, maybe we could
>> try to converge on it and obsolete the others.
>>
>> Then the first patch would touch only the PCI core, and the second
>> would touch only MIPS, which would make merging more straightforward.
>>
>
> Hmm.. Adding a wrapper of pci_create_bus() does leave other
> architectures alone for this merging. But before all of them converge on
> it (a long way to go), the wrapper is adding naming confusion to the
> PCI core. Personally I think the current low-level transparent change to
> pci_create_bus() is appropriate enough. Does anybody have comments?
>
>
> Deng-Cheng

Just to be clear, I'm fine with it either way, as long as Jesse and
the arch maintainers are OK with it.
