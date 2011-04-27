Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759796Ab1D0Rvf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 13:51:35 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:40878 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756501Ab1D0Rve convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 13:51:34 -0400
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
Date: Wed, 27 Apr 2011 23:20:18 +0530
Subject: RE: [PATCH v4 08/11] tty: add pruss SUART driver
Thread-Topic: [PATCH v4 08/11] tty: add pruss SUART driver
Thread-Index: AcwE3P+e9lEbOmpXQEiZ7nC1fLVr2QAJPTBA
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB593024CBA9B31@dbde02.ent.ti.com>
References: <1303474109-6212-1-git-send-email-subhasish@mistralsolutions.com>
 <1303474109-6212-9-git-send-email-subhasish@mistralsolutions.com>
 <20110425212056.GA29313@kroah.com>
 <B85A65D85D7EB246BE421B3FB0FBB593024CAE36A6@dbde02.ent.ti.com>
 <20110426124519.GC5977@suse.de>
 <35F38DB5B5C4408EA80AF0DB8A6FA178@subhasishg>
 <B85A65D85D7EB246BE421B3FB0FBB593024CBA9959@dbde02.ent.ti.com>
 <F6E90395B84D4E9FA9497247841035FC@subhasishg>
In-Reply-To: <F6E90395B84D4E9FA9497247841035FC@subhasishg>
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

Hi Subhasish,

On Wed, Apr 27, 2011 at 18:45:06, Subhasish Ghosh wrote:
>  >> >>The driver should probably just get sram
> >> >> space through platform data so that it doesn't depend on the
> >> >> platform specific sram allocation function.
> >>
> >> Are you suggesting that I go back to that implementation.
> >
> > No, the platform code should use the SRAM allocator and
> > pass on the allocated memory to the driver.
> 
> SG - So, should I call the sram_alloc() in the platform setup function. 

Can you please shed some light on how SRAM
is being used in the driver? Looking at the
driver, it looks like it is used as a shared
buffer between the PRU firmware and kernel.

If yes, how do you cope with dynamic allocation
of SRAM? That is, how do you inform the firmware
what portion of SRAM has been allocated to the
driver?

Also, usage of SRAM is not required for basic driver
function, correct? So, a platform which does not
have SRAM to spare for this driver could still have
a portion of SDRAM/DDR allocated to be used as the
shared buffer? I guess SRAM was used only for lower
access times. But it should still be possible to
sustain lower baudrates with SDRAM/DDR?

Thanks,
Sekhar

