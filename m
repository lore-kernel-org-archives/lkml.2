Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933240Ab1JNPdx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 11:33:53 -0400
Received: from smtp-out.google.com ([216.239.44.51]:60251 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754713Ab1JNPdv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 11:33:51 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=pzKzHbFw7vBitwA+Ay76AVocopoaXl67LKKdXDCprzc84UEx3mef59VcsF4adYtBt
	Es70Owf87VU690XAJPj7Q==
MIME-Version: 1.0
In-Reply-To: <1318605254.3018.20.camel@dabdike.int.hansenpartnership.com>
References: <20111014042142.23504.70417.stgit@bhelgaas.mtv.corp.google.com> <1318605254.3018.20.camel@dabdike.int.hansenpartnership.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 14 Oct 2011 09:33:28 -0600
Message-ID: <CAErSpo7d3hHeJU87zYo=yJoG3eqOZ4QggkOyNnu7xuJe8oG9Qg@mail.gmail.com>
Subject: Re: [PATCH v2 00/29] Create PCI root buses with correct resources
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-pci@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 14, 2011 at 9:14 AM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Thu, 2011-10-13 at 22:27 -0600, Bjorn Helgaas wrote:
>> The most generic way to create a PCI root bus is with pci_scan_bus(), but
>> that doesn't allow you to specify what resources are available on the bus,
>> i.e., what the host bridge apertures are.
>
> Do you have an actual tree for this?  The PARISC pieces look a bit
> non-trivial and I'd like to test them out on the various sba/astro/dino
> systems.

I don't yet, but it'd be great if you were willing to test them out,
so I'll set one up.

While this is on your mind, I'm dubious about the pci_enable_bridges()
call in lba_driver_probe() and the pci_bus_assign_resources() call in
dino_probe().  These stand out as exceptions because no other arches
do that.

If they weren't there, both places could use pci_scan_root_bus() like
most other arches.

Bjorn
