Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109Ab1LUTPf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 14:15:35 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40625 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753535Ab1LUTPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 14:15:33 -0500
Date: Wed, 21 Dec 2011 14:02:11 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Samuel Ortiz <samuel@sortiz.org>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: linux-next: Tree for Dec 19 (nfc)
Message-ID: <20111221190211.GE11842@tuxdriver.com>
References: <20111219185556.f07c1f43e28cfd594aaa5fe0@canb.auug.org.au>
 <4EEFA21B.5010305@xenotime.net>
 <1324399181.5354.0.camel@sortiz-mobl>
 <4EF23A1F.60803@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EF23A1F.60803@xenotime.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 21, 2011 at 11:57:19AM -0800, Randy Dunlap wrote:
> On 12/20/2011 08:39 AM, Samuel Ortiz wrote:
> > Hi Randy,
> > 
> > On Mon, 2011-12-19 at 12:44 -0800, Randy Dunlap wrote:
> >> On 12/18/2011 11:55 PM, Stephen Rothwell wrote:
> >>> Hi all,
> >>>
> >>> Changes since 20111216:
> >>
> >>
> >> (not new today, just not reported earlier)
> > John applied my fix for this one. It should be fixed now.
> 
> Hi Samuel,
> 
> Is this supposed to be fixed in linux-next?
> It still fails today (linux-next 20111221).
> 
> 
> data.c:(.text+0x3e0): multiple definition of `nfc_llcp_mac_is_down'
> data.c:(.text+0x400): multiple definition of `nfc_llcp_mac_is_up'
> ntf.c:(.text+0xb60): multiple definition of `nfc_llcp_mac_is_down'
> ntf.c:(.text+0xb80): multiple definition of `nfc_llcp_mac_is_up'
> rsp.c:(.text+0x750): multiple definition of `nfc_llcp_mac_is_down'
> rsp.c:(.text+0x770): multiple definition of `nfc_llcp_mac_is_up'
> netlink.c:(.text+0x14e0): multiple definition of `nfc_llcp_mac_is_down'
> netlink.c:(.text+0x1500): multiple definition of `nfc_llcp_mac_is_up'
> af_nfc.c:(.text+0xe0): multiple definition of `nfc_llcp_mac_is_down'
> af_nfc.c:(.text+0x100): multiple definition of `nfc_llcp_mac_is_up'
> rawsock.c:(.text+0x1000): multiple definition of `nfc_llcp_mac_is_down'
> rawsock.c:(.text+0x1020): multiple definition of `nfc_llcp_mac_is_up'

I have this commit in wireless-next, been there a couple of days:

commit 645d35902c8f05a1b12fa838aa9052d8eeaf161e
Author: Samuel Ortiz <sameo@linux.intel.com>
Date:   Fri Dec 16 15:03:36 2011 +0100

    NFC: Fix LLCP related build failure
    
    llcp_mac routines should be static and inlined or build will fail with NFC
    selected without LLCP.
    
    This patch fixes:
    
    LD [M]  net/nfc/nfc.o
    net/nfc/netlink.o: In function `nfc_llcp_mac_is_down':
    netlink.c:(.text+0x0): multiple definition of `nfc_llcp_mac_is_down'
    net/nfc/core.o:(.text+0x0): first defined here
    net/nfc/netlink.o: In function `nfc_llcp_mac_is_up':
    netlink.c:(.text+0x10): multiple definition of `nfc_llcp_mac_is_up'
    net/nfc/core.o:(.text+0x10): first defined here
    net/nfc/af_nfc.o: In function `nfc_llcp_mac_is_down':
    (.text+0x0): multiple definition of `nfc_llcp_mac_is_down'
    net/nfc/core.o:(.text+0x0): first defined here
    net/nfc/af_nfc.o: In function `nfc_llcp_mac_is_up':
    (.text+0x10): multiple definition of `nfc_llcp_mac_is_up'
    net/nfc/core.o:(.text+0x10): first defined here
    net/nfc/rawsock.o: In function `nfc_llcp_mac_is_down':
    rawsock.c:(.text+0x0): multiple definition of `nfc_llcp_mac_is_down'
    net/nfc/core.o:(.text+0x0): first defined here
    net/nfc/rawsock.o: In function `nfc_llcp_mac_is_up':
    rawsock.c:(.text+0x10): multiple definition of `nfc_llcp_mac_is_up'
    net/nfc/core.o:(.text+0x10): first defined here
    
    Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
