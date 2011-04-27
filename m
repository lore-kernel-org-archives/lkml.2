Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758647Ab1D0LTr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 07:19:47 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:56169 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758613Ab1D0LTq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 07:19:46 -0400
From: "Nori, Sekhar" <nsekhar@ti.com>
To: Subhasish Ghosh <subhasish@mistralsolutions.com>, Greg KH <gregkh@suse.de>
CC: Greg KH <greg@kroah.com>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Watkins, Melissa" <m-watkins@ti.com>,
        "sachi@mistralsolutions.com" <sachi@mistralsolutions.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        open list <linux-kernel@vger.kernel.org>
Date: Wed, 27 Apr 2011 16:49:02 +0530
Subject: RE: [PATCH v4 08/11] tty: add pruss SUART driver
Thread-Topic: [PATCH v4 08/11] tty: add pruss SUART driver
Thread-Index: AcwEmyaOiuxO3JY3R7StrVG52j7yvwAGKCxA
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB593024CBA9959@dbde02.ent.ti.com>
References: <1303474109-6212-1-git-send-email-subhasish@mistralsolutions.com>
 <1303474109-6212-9-git-send-email-subhasish@mistralsolutions.com>
 <20110425212056.GA29313@kroah.com>
 <B85A65D85D7EB246BE421B3FB0FBB593024CAE36A6@dbde02.ent.ti.com>
 <20110426124519.GC5977@suse.de> <35F38DB5B5C4408EA80AF0DB8A6FA178@subhasishg>
In-Reply-To: <35F38DB5B5C4408EA80AF0DB8A6FA178@subhasishg>
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

On Wed, Apr 27, 2011 at 10:53:38, Subhasish Ghosh wrote:
> >> There should be no build time dependency with this patch
> >> (the above patch just changes which pool of SRAM the
> >> allocation happens from)
> >>
> >> But, this brings out an important dependency of the patch
> >> calling platform specific sram allocator functions. There
> >> has been SRAM allocator consolidation work done by Russell
> >> and as a result the SRAM allocator API for DaVinci will
> >> actually change.
> 
> I earlier had an implementation where I would get the sram memory addresses
> through the .resource structure and ioremap it in the driver.

This is wrong since it assumes the whole SRAM is available
for usage by your driver. We already have an allocator
for SRAM.

> 
> >>The driver should probably just get sram
> >> space through platform data so that it doesn't depend on the
> >> platform specific sram allocation function.
> 
> Are you suggesting that I go back to that implementation.

No, the platform code should use the SRAM allocator and
pass on the allocated memory to the driver.

Thanks,
Sekhar

