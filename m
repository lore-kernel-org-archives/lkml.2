Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482Ab1HYPfK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:35:10 -0400
Received: from smtp-out.google.com ([74.125.121.67]:61162 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754739Ab1HYPfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:35:07 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:x-system-of-record;
	b=vP86hFcIutjfhTxkJLXi21/bL8WoCLHjmn11KCq+NS29GuN1mrnnlY61GKP0xL6y9
	pmaQhLidx80KaJ8pOXXHg==
MIME-Version: 1.0
In-Reply-To: <CAOfQC98Nkr7Ek3uQfiD3OdW=YC76XGjfQ4WSfoLpsm2kvqKnog@mail.gmail.com>
References: <1314167063-15785-1-git-send-email-dengcheng.zhu@gmail.com>
 <1314167063-15785-2-git-send-email-dengcheng.zhu@gmail.com>
 <CAErSpo4091J2pGvzZKPbKK68LWWkDyVApA7suZYn7miq=tXrQg@mail.gmail.com> <CAOfQC98Nkr7Ek3uQfiD3OdW=YC76XGjfQ4WSfoLpsm2kvqKnog@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 25 Aug 2011 09:34:43 -0600
Message-ID: <CAErSpo4zojYjYVd=6U72ToqiZOD-qL-saP8huwa6ShrNnaR3vA@mail.gmail.com>
Subject: Re: [RFC PATCH 1/3] MIPS: PCI: Use pci_bus_remove_resources()/pci_bus_add_resource()
 to set up root resources
To: Deng-Cheng Zhu <dengcheng.zhu@gmail.com>
Cc: jbarnes@virtuousgeek.org, ralf@linux-mips.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mips@linux-mips.org, eyal@mips.com,
        zenon@mips.com
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 25, 2011 at 12:41 AM, Deng-Cheng Zhu
<dengcheng.zhu@gmail.com> wrote:
> 2011/8/24 Bjorn Helgaas <bhelgaas@google.com>:
>> Wouldn't it be enough to have [PATCH 2/3], which adds the
>> pci_create_bus() argument with nobody using it yet, then [PATCH 3/3],
>> which makes mips supply the new argument, and add a hunk to [PATCH
>> 3/3] that completely removes the bus->resource fixups in
>> pcibios_fixup_bus() at the same time?
>>
>> Bjorn
>>
>
> Do you mean to merge this patch to [PATCH 3/3]? OK, that's good!

No, I just mean that I don't see why you need this patch at all.  If
you pass the list of bus resources to pci_create_bus(), there's no
need to fix anything up later.  Or am I missing something?

Bjorn
