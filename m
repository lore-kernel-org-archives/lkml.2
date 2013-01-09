Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932290Ab3AIXMi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 18:12:38 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:41848 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932173Ab3AIXMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 18:12:36 -0500
Message-ID: <50EDF95F.4070209@wwwdotorg.org>
Date: Wed, 09 Jan 2013 16:12:31 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Thierry Reding <thierry.reding@avionic-design.de>,
        linux-tegra@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 05/14] lib: Add I/O map cache implementation
References: <1357764194-12677-1-git-send-email-thierry.reding@avionic-design.de> <201301092119.57067.arnd@arndb.de> <20130109215428.GA13648@avionic-0098.adnet.avionic-design.de> <201301092210.49452.arnd@arndb.de>
In-Reply-To: <201301092210.49452.arnd@arndb.de>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/2013 03:10 PM, Arnd Bergmann wrote:
> On Wednesday 09 January 2013, Thierry Reding wrote:
>> What happens on Tegra is that we need to map 256 MiB of physical memory
>> to access all the PCIe extended configuration space. However, ioremap()
>> on such a large region fails if not enough vmalloc() space is available.
>>
>> This was observed when somebody tested this on CardHu which has a 1 GiB
>> of RAM and therefore remapping the full 256 MiB fails.
...
> Have you checked if the hardware supports an alternative config
> space access mechanism that does not depend on a huge address range?
> A lot of them provide an index/data register pair somewhere, as the
> original PC implementation did.

That would be nice, but I've talked to the HW engineers, and there's no
indication that any alternative mechanism exists.
