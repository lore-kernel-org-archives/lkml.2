Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751976Ab0CUInj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 04:43:39 -0400
Received: from casper.infradead.org ([85.118.1.10]:58917 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067Ab0CUInh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 04:43:37 -0400
Subject: Re: [PATCH 4/4] pci/dmar: Tone down warnings about invalid BIOS
 DMAR tables
From: David Woodhouse <dwmw2@infradead.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       linux-pci <linux-pci@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1269126446.18314.117.camel@localhost>
References: <1269126097.18314.111.camel@localhost>
	 <1269126446.18314.117.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 21 Mar 2010 08:43:30 +0000
Message-ID: <1269161010.4028.9824.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-03-20 at 23:07 +0000, Ben Hutchings wrote:
> We now know how to deal with these tables so that they are harmless.
> Use the TAINT_FIRMWARE_WORKAROUND flag and don't say the BIOS is
> 'broken' as this makes users think of hardware damage.

Nack to the string change. If you see this message, it's because your
BIOS is BROKEN, and this brokenness has caused us to have to disable the
VT-d feature completely. The fuckwits obviously never tested it even as
far as booting a VT-d enabled OS on it even once¹.

We _want_ people to think of it as hardware damage and return the board
to the vendor, as unfit for the purpose for which it was sold.

The rest of the series looks good though; thanks.

I haven't applied the first patch, although it stands alone -- your
other patches will depend on it and cause merge pain. Or do you want me
to take the whole lot through the intel-iommu tree?

-- 
dwmw2

¹ Or maybe they did, but the OS didn't tell them clearly enough that it
  was broken.

