Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934199Ab1ESSu7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 14:50:59 -0400
Received: from smtp-out.google.com ([216.239.44.51]:5496 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934115Ab1ESSu5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 14:50:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=vbmghHKsAVuoTKpglJqB04EWjDIm1DXLmDDyByX31IzjVmRYIfwXmmfQIw7fMv3Yk9
         3rkgh151ZAgOcbx+oykw==
MIME-Version: 1.0
In-Reply-To: <sig.9120f46b2d.4DD5452F.9050108@radicalsystems.co.za>
References: <sig.9120f46b2d.4DD5452F.9050108@radicalsystems.co.za>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 19 May 2011 12:50:35 -0600
Message-ID: <BANLkTi=g=fKaXF4uwwjLSX-R+pk0FUa6OQ@mail.gmail.com>
Subject: Re: PCI BAR1 Unassigned
To: Jan Zwiegers <jan@radicalsystems.co.za>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 19, 2011 at 10:28 AM, Jan Zwiegers <jan@radicalsystems.co.za> wrote:
> I have the problem below where my PCI card's second BAR does not get
> assigned.
> What can be the cause of this problem?
> The last kernel I tested on which worked OK was 2.6.27.
> My current problematic kernel 2.6.35.
>
> 05:01.0 Unassigned class [ff00]: Eagle Technology PCI-703 Analog I/O Card
> (rev 5c)
>    Flags: bus master, slow devsel, latency 32, IRQ 22
>    Memory at 93b00000 (type 3, prefetchable) [size=2K]
>    Memory at <unassigned> (type 3, prefetchable)
>    Capabilities: [80] #00 [0600]
>    Kernel modules: pci703drv

Could be resource exhaustion or, more likely, we ran out because we
now assign resource to things that don't need them, leaving none for
things that *do* need them.  This sounds like a regression, so we
should open a bugzilla for it and attach dmesg logs from 2.6.27 and
2.6.35.

Does this problem keep the driver from working?  (Sometimes drivers
don't actually use all the BARs a device supports.)

Bjorn
