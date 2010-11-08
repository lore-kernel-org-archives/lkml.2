Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926Ab0KHMNt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 07:13:49 -0500
Received: from smtprelay01.ispgateway.de ([80.67.31.39]:33833 "EHLO
	smtprelay01.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217Ab0KHMNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 07:13:48 -0500
Message-ID: <4CD7E925.6020608@ladisch.de>
Date: Mon, 08 Nov 2010 13:12:21 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Nico <segfault2@hotmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: AGP Aperture question
References: <SNT127-W65587F1714D03CB57D611DE64D0@phx.gbl>
In-Reply-To: <SNT127-W65587F1714D03CB57D611DE64D0@phx.gbl>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: linux-kernel@cl.domainfactory-kunde.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nico wrote:
> Your BIOS doesn't leave a aperture memory hole
> Please enable the IOMMU option in the BIOS setup
> This costs you 64 MB of RAM

This message is a little bit too optimistic.  I don't know of any
motherboard not specifically designed for Linux that has such an option
or that just silently reserves address space for the IOMMU.

> So, is the above something to be concerned about? Does it have any
> negative impact on the system?

There are three options for using the GART as an IOMMU:
1) Put the GART into some free address space below 4 GB.
2) Put the GART over some memory below 4 GB.
3) Don't use the GART.

The first one would be optimal, but requires that there is some free
address space below 4 GB.  The third one makes the computer slower
because any DMA from/to memory above the 4 GB limit requires copying
buffers to/from low memory.

Option 2) wastes 64 MB of memory, compared to 1), but is very much
superior to 3).

(AFAIK Windows uses 3), and this is why no BIOS bothers to set this.)


Regards,
Clemens
