Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834Ab1DSTvp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 15:51:45 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:53701 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752483Ab1DSTvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 15:51:44 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: brace@beardog.cce.hp.com
Subject: Re: How to create a kernel virtual mapping for physical addresses.
Date: Tue, 19 Apr 2011 21:51:41 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.38+; KDE/4.5.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, scameron@beardog.cce.hp.com
References: <20110408220321.GA777@beardog.cce.hp.com>
In-Reply-To: <20110408220321.GA777@beardog.cce.hp.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104192151.41511.arnd@arndb.de>
X-Provags-ID: V02:K0:Z2dG4J/ZjutiFdl2pCjtW5SAnL+jaWQUZNE+Tgv4zf6
 b2s9suZWAUrHvMkHsK2f1Her16DVXIttRwHjjSS1U2cIj6fce0
 JG+iR4hVIy2P3UU/FcbhiTf4VlskHJWawNsAsYer0Fh2msW1nf
 9AslfMzb31ELK9+aLdVMpgharVmzrJw9h9d8z2WhI/jaibU/pq
 WQSR45AdofvfzP/kQCKmA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 09 April 2011 00:03:21 brace@beardog.cce.hp.com wrote:
> Given a physical address and a length (which may span contiguous pages), how
> does one go about creating a virtual mapping for that address? That address may
> be in high memory (above 4GB) in a 32bit system.
> 
> ioremap() wants a 32bit physical address on 32bit systems. kmap() and
> kmap_atomic() wants a struct page which I am not sure how to get from a physical
> address.

Use kmap() on the page you get from pfn_to_page().

> If there already is a kernel mapping, then using the existing kernel mapping
> would be fine if I could figure out how to get it, but if there is not one,
> then I need to make one.
> 
> I think setting the DMA mask to 32bit would mean that I do not have to deal
> with highmem addresses in my particular case, but I still do not know how to
> get a virtual address from a physical.
 
DMA mask is only about devices doing DMA to your data, not about the
kernel touching it.

	Arnd
