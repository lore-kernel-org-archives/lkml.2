Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932287Ab1J2JLA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Oct 2011 05:11:00 -0400
Received: from co202.xi-lite.net ([149.6.83.202]:34002 "EHLO co202.xi-lite.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932152Ab1J2JK7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Oct 2011 05:10:59 -0400
Date: Sat, 29 Oct 2011 11:09:46 +0200
From: Ivan Djelic <ivan.djelic@parrot.com>
To: Robert Jarzmik <robert.jarzmik@free.fr>
CC: "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "dedekind1@gmail.com" <dedekind1@gmail.com>,
        "mikedunn@newsguy.com" <mikedunn@newsguy.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 12/13] mtd/docg3: add ECC correction code
Message-ID: <20111029090946.GB12046@parrot.com>
References: <1319824292-11085-1-git-send-email-robert.jarzmik@free.fr>
 <1319824292-11085-13-git-send-email-robert.jarzmik@free.fr>
 <20111029085248.GA12046@parrot.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20111029085248.GA12046@parrot.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 29, 2011 at 10:52:48AM +0200, Ivan Djelic wrote:
> Just a side note: if you need to get maximum performance from the BCH library,
> you can set fixed values for M and T in your Kconfig, with something like:
> 
>  config MTD_DOCG3
>         tristate "M-Systems Disk-On-Chip G3"
> 	select BCH

Oops, just noticed that you would also need to add this line here:
	select BCH_CONST_PARAMS

>         ---help---
>           This provides an MTD device driver for the M-Systems DiskOnChip
>           G3 devices.
> 
> if MTD_DOCG3
> config BCH_CONST_M
> 	default 14
> config BCH_CONST_T
> 	default 4
> endif
> 
> 
> The only drawback is that it won't work if you select your DOCG3 driver and, at
> the same time, other MTD drivers that also use fixed, but different parameters.
