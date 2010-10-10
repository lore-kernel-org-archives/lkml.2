Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006Ab0JJONO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 10:13:14 -0400
Received: from one.firstfloor.org ([213.235.205.2]:51725 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854Ab0JJONN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 10:13:13 -0400
Date: Sun, 10 Oct 2010 16:13:11 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Huang Ying <ying.huang@intel.com>, Don Zickus <dzickus@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Robert Richter <robert.richter@amd.com>
Subject: Re: [PATCH -v3 5/6] x86, NMI, treat unknown NMI as hardware error
Message-ID: <20101010141311.GB26728@basil.fritz.box>
References: <1286606987-19879-1-git-send-email-ying.huang@intel.com>
 <1286606987-19879-5-git-send-email-ying.huang@intel.com>
 <20101010150713.3cd3eed2@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101010150713.3cd3eed2@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 10, 2010 at 03:07:13PM +0100, Alan Cox wrote:
> On Sat,  9 Oct 2010 14:49:46 +0800
> Huang Ying <ying.huang@intel.com> wrote:
> 
> > In general, unknown NMI is used by hardware and firmware to notify
> > fatal hardware errors to OS. So the Linux should treat unknown NMI as
> > hardware error and go panic upon unknown NMI for better error
> > containment.
> 
> Not entirely true. Older machines use NMI for all sorts of interesting
> purposes. In particular many 486 laptops trigger NMI as part of power
> manaagement, (Hence the choice of the dazed and confused message)

In general, on any post stone age x86 system, ...

> > These systems are identified via the presentation of APEI HEST or
> > some PCI ID of the host bridge. The PCI ID of host bridge instead of
> > DMI ID is used, so that the checking can be done based on the platform
> > type instead of motherboard. This should be simpler and sufficient.
> > 
> > The method to identify the platforms is designed by Andi Kleen.
> 
> Why not make the new flag also a boot option so you can force it on for
> platforms where we don't auto whitelist it.

You can already set it at run time using sysctl.

echo 1 > /proc/sys/kernel/panic_on_unrecovered_nmi
echo 1 > /proc/sys/kernel/panic_on_io_nmi

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
