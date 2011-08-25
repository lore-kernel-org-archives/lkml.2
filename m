Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753Ab1HYXXu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 19:23:50 -0400
Received: from smtp-out.google.com ([74.125.121.67]:25169 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705Ab1HYXXs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 19:23:48 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=g/MNkgNxB/nNi7VosRg8ycttONqb7/ZK8k1pT3Ix1s02TosTdxVuPWC1lqpPpc10b
	OZWNR02txr44Sh2cgLBOg==
MIME-Version: 1.0
In-Reply-To: <CAOfQC9-kS_nVg-+2OZRGHP1X-E7B12uG63QGfB64hPAGecgFLw@mail.gmail.com>
References: <1314167063-15785-1-git-send-email-dengcheng.zhu@gmail.com>
 <1314167063-15785-2-git-send-email-dengcheng.zhu@gmail.com>
 <CAErSpo4091J2pGvzZKPbKK68LWWkDyVApA7suZYn7miq=tXrQg@mail.gmail.com>
 <CAOfQC98Nkr7Ek3uQfiD3OdW=YC76XGjfQ4WSfoLpsm2kvqKnog@mail.gmail.com>
 <CAErSpo4zojYjYVd=6U72ToqiZOD-qL-saP8huwa6ShrNnaR3vA@mail.gmail.com> <CAOfQC9-kS_nVg-+2OZRGHP1X-E7B12uG63QGfB64hPAGecgFLw@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 25 Aug 2011 17:23:24 -0600
Message-ID: <CAErSpo4U6orULckFofbJON+x70m1G4w76rK4Y1Besh_K-m612g@mail.gmail.com>
Subject: Re: [RFC PATCH 1/3] MIPS: PCI: Use pci_bus_remove_resources()/pci_bus_add_resource()
 to set up root resources
To: Deng-Cheng Zhu <dengcheng.zhu@gmail.com>
Cc: jbarnes@virtuousgeek.org, ralf@linux-mips.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mips@linux-mips.org, eyal@mips.com,
        zenon@mips.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 25, 2011 at 5:14 PM, Deng-Cheng Zhu <dengcheng.zhu@gmail.com> wrote:
> 2011/8/25 Bjorn Helgaas <bhelgaas@google.com>:
>> No, I just mean that I don't see why you need this patch at all.  If
>> you pass the list of bus resources to pci_create_bus(), there's no
>> need to fix anything up later.  Or am I missing something?
>
> Well, doing the root resource fixups in here is a *paranoid* way. It's to
> deal with the 'unlikely' circumstance where controller_resources() returns
> the NULL pointer in pcibios_scanbus() due to memory allocation failure.
> Most of the time (always) it's nothing more than repeating the resource
> list setup. But maybe we can do something like this:
>
> if (unlikely(!dev && list_empty(&bus->resources))
>        pcibios_setup_root_resources(bus, hose);
>
>
> What do you think?

I don't think it's worth it.  Just check for failure of
controller_resources(), and if it fails, skip the pci_create_bus()
call.  You've already printed a message (you might add the PCI
domain/bus number).

Bjorn
