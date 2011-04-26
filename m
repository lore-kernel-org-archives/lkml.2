Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757450Ab1DZGwG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 02:52:06 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:58981 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756895Ab1DZGwF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 02:52:05 -0400
From: "Nori, Sekhar" <nsekhar@ti.com>
To: Greg KH <greg@kroah.com>, Subhasish Ghosh <subhasish@mistralsolutions.com>
CC: "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Watkins, Melissa" <m-watkins@ti.com>,
        "sachi@mistralsolutions.com" <sachi@mistralsolutions.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        open list <linux-kernel@vger.kernel.org>
Date: Tue, 26 Apr 2011 12:21:04 +0530
Subject: RE: [PATCH v4 08/11] tty: add pruss SUART driver
Thread-Topic: [PATCH v4 08/11] tty: add pruss SUART driver
Thread-Index: AcwDjtvtV5t6U5PbSg6bfQzDj70LkQARAXgg
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB593024CAE36A6@dbde02.ent.ti.com>
References: <1303474109-6212-1-git-send-email-subhasish@mistralsolutions.com>
 <1303474109-6212-9-git-send-email-subhasish@mistralsolutions.com>
 <20110425212056.GA29313@kroah.com>
In-Reply-To: <20110425212056.GA29313@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 26, 2011 at 02:50:56, Greg KH wrote:
> On Fri, Apr 22, 2011 at 05:38:26PM +0530, Subhasish Ghosh wrote:
> > This patch adds support for the TTY compliant
> > Soft-UART device emulated on PRUSS.
> > 
> > This patch depends on:
> > davinci: macro rename DA8XX_LPSC0_DMAX to DA8XX_LPSC0_PRUSS.
> >             https://patchwork.kernel.org/patch/615681/

This is already in mainline. Plus this patch
doesn't really seem to depend on this commit.

> > davinci: changed SRAM allocator to shared ram.
> >             https://patchwork.kernel.org/patch/549351/

There should be no build time dependency with this patch
(the above patch just changes which pool of SRAM the
allocation happens from)

But, this brings out an important dependency of the patch
calling platform specific sram allocator functions. There
has been SRAM allocator consolidation work done by Russell
and as a result the SRAM allocator API for DaVinci will
actually change. The driver should probably just get sram
space through platform data so that it doesn't depend on the
platform specific sram allocation function.

> 
> Who is going to be applying these patches to the tree?
> 
> Should this driver go through a davinci subtree because of these
> dependancies?

No, driver and platform changes can be merged separately
if the above aspect is taken care of. Russell has been
pushing back on merging driver patches through his tree
unless absolutely required.

Thanks,
Sekhar

