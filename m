Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932561Ab0HCWAt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 18:00:49 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:65316 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932521Ab0HCWAq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 18:00:46 -0400
MIME-Version: 1.0
In-Reply-To: <20100803215137.GU26313@bicker>
References: <Pine.LNX.4.64.1008032334420.20393@ask.diku.dk> 
	<20100803215137.GU26313@bicker>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 3 Aug 2010 16:00:25 -0600
X-Google-Sender-Auth: n_9GLQUP7XfiQ9FbPoR8iK-8tHs
Message-ID: <AANLkTi=yOJ0Zfsn_h_xWai5O=OPkccMb-hDwKK+dWZwf@mail.gmail.com>
Subject: Re: [PATCH 8/9] arch/powerpc/kernel: Drop unnecessary null test
To: Dan Carpenter <error27@gmail.com>, Julia Lawall <julia@diku.dk>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Grant Likely <grant.likely@secretlab.ca>, linuxppc-dev@ozlabs.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 3, 2010 at 3:51 PM, Dan Carpenter <error27@gmail.com> wrote:
> On Tue, Aug 03, 2010 at 11:35:17PM +0200, Julia Lawall wrote:
>> diff --git a/arch/powerpc/kernel/pci_of_scan.c b/arch/powerpc/kernel/pci_of_scan.c
>> index 6ddb795..62dd363 100644
>> --- a/arch/powerpc/kernel/pci_of_scan.c
>> +++ b/arch/powerpc/kernel/pci_of_scan.c
>> @@ -336,8 +336,7 @@ static void __devinit __of_scan_bus(struct device_node *node,
>>               if (dev->hdr_type == PCI_HEADER_TYPE_BRIDGE ||
>>                   dev->hdr_type == PCI_HEADER_TYPE_CARDBUS) {
>>                       struct device_node *child = pci_device_to_OF_node(dev);
>> -                     if (dev)
>> -                             of_scan_pci_bridge(child, dev);
>> +                     of_scan_pci_bridge(child, dev);
>
> The intention was probably to check "child" instead of "dev".
> pci_device_to_OF_node() can return NULL.  On the other hand the code
> has been this way for a year and no one has complained...

Still, it should be fixed.  It is likely that I'll be generalizing
this code for other architectures in the near future.  I'll spin a
patch.

g.
