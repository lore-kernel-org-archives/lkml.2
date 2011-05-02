Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022Ab1EBRRO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 13:17:14 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:40930 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751198Ab1EBRRN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 13:17:13 -0400
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
Date: Mon, 2 May 2011 22:45:53 +0530
Subject: RE: [PATCH v4 08/11] tty: add pruss SUART driver
Thread-Topic: [PATCH v4 08/11] tty: add pruss SUART driver
Thread-Index: AcwIo45QBYecflReRyCZEfZ25IMRNgAR9/yw
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB593024CC3B025@dbde02.ent.ti.com>
References: <1303474109-6212-1-git-send-email-subhasish@mistralsolutions.com>
 <1303474109-6212-9-git-send-email-subhasish@mistralsolutions.com>
 <20110425212056.GA29313@kroah.com>
 <B85A65D85D7EB246BE421B3FB0FBB593024CAE36A6@dbde02.ent.ti.com>
 <20110426124519.GC5977@suse.de>
 <35F38DB5B5C4408EA80AF0DB8A6FA178@subhasishg>
 <B85A65D85D7EB246BE421B3FB0FBB593024CBA9959@dbde02.ent.ti.com>
 <F6E90395B84D4E9FA9497247841035FC@subhasishg>
 <B85A65D85D7EB246BE421B3FB0FBB593024CBA9B31@dbde02.ent.ti.com>
 <AD18C961F5D84B92B2611F80E80B3D6F@subhasishg>
In-Reply-To: <AD18C961F5D84B92B2611F80E80B3D6F@subhasishg>
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

On Mon, May 02, 2011 at 14:04:11, Subhasish Ghosh wrote:

> >> SG - So, should I call the sram_alloc() in the platform setup function. 
> > 
> > Can you please shed some light on how SRAM
> > is being used in the driver? Looking at the
> > driver, it looks like it is used as a shared
> > buffer between the PRU firmware and kernel.
> > 
> > If yes, how do you cope with dynamic allocation
> > of SRAM? That is, how do you inform the firmware
> > what portion of SRAM has been allocated to the
> > driver?
> > 
> > Also, usage of SRAM is not required for basic driver
> > function, correct? So, a platform which does not
> > have SRAM to spare for this driver could still have
> > a portion of SDRAM/DDR allocated to be used as the
> > shared buffer? I guess SRAM was used only for lower
> > access times. But it should still be possible to
> > sustain lower baudrates with SDRAM/DDR?
> 
> The sram is allocated dynamically in the driver. 
> After allocation, we write the pointer into the PRU, so in case the
> driver allocates memory form the DDR, it will write this info into the
> PRU and it will work. But, because of DDR access latencies, the UART
> will work only for lower baud rates. 

Thanks for the clarification. In this case, the driver
should use platform callbacks to get/put fast fifo
space. In case this callback is not populated by the
platform or returns an error, the driver should fall
back to allocating from DDR.

Thanks,
Sekhar

