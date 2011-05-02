Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756768Ab1EBId0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 04:33:26 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:42193 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753920Ab1EBIdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 04:33:24 -0400
Message-ID: <AD18C961F5D84B92B2611F80E80B3D6F@subhasishg>
From: "Subhasish Ghosh" <subhasish@mistralsolutions.com>
To: "Nori, Sekhar" <nsekhar@ti.com>, "Greg KH" <gregkh@suse.de>
Cc: "Greg KH" <greg@kroah.com>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-arm-kernel@lists.infradead.org>,
        "Watkins, Melissa" <m-watkins@ti.com>, <sachi@mistralsolutions.com>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Randy Dunlap" <randy.dunlap@oracle.com>,
        "open list" <linux-kernel@vger.kernel.org>
References: <1303474109-6212-1-git-send-email-subhasish@mistralsolutions.com> <1303474109-6212-9-git-send-email-subhasish@mistralsolutions.com> <20110425212056.GA29313@kroah.com> <B85A65D85D7EB246BE421B3FB0FBB593024CAE36A6@dbde02.ent.ti.com> <20110426124519.GC5977@suse.de> <35F38DB5B5C4408EA80AF0DB8A6FA178@subhasishg> <B85A65D85D7EB246BE421B3FB0FBB593024CBA9959@dbde02.ent.ti.com> <F6E90395B84D4E9FA9497247841035FC@subhasishg> <B85A65D85D7EB246BE421B3FB0FBB593024CBA9B31@dbde02.ent.ti.com>
In-Reply-To: <B85A65D85D7EB246BE421B3FB0FBB593024CBA9B31@dbde02.ent.ti.com>
Subject: Re: [PATCH v4 08/11] tty: add pruss SUART driver
Date: Mon, 2 May 2011 14:04:11 +0530
Organization: Mistral Solutions
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
Importance: Normal
X-Mailer: Microsoft Windows Live Mail 14.0.8117.416
X-MimeOLE: Produced By Microsoft MimeOLE V14.0.8117.416
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Hi Subhasish,
> 
> On Wed, Apr 27, 2011 at 18:45:06, Subhasish Ghosh wrote:
>>  >> >>The driver should probably just get sram
>> >> >> space through platform data so that it doesn't depend on the
>> >> >> platform specific sram allocation function.
>> >>
>> >> Are you suggesting that I go back to that implementation.
>> >
>> > No, the platform code should use the SRAM allocator and
>> > pass on the allocated memory to the driver.
>> 
>> SG - So, should I call the sram_alloc() in the platform setup function. 
> 
> Can you please shed some light on how SRAM
> is being used in the driver? Looking at the
> driver, it looks like it is used as a shared
> buffer between the PRU firmware and kernel.
> 
> If yes, how do you cope with dynamic allocation
> of SRAM? That is, how do you inform the firmware
> what portion of SRAM has been allocated to the
> driver?
> 
> Also, usage of SRAM is not required for basic driver
> function, correct? So, a platform which does not
> have SRAM to spare for this driver could still have
> a portion of SDRAM/DDR allocated to be used as the
> shared buffer? I guess SRAM was used only for lower
> access times. But it should still be possible to
> sustain lower baudrates with SDRAM/DDR?

The sram is allocated dynamically in the driver. 
After allocation, we write the pointer into the PRU, so in case the
driver allocates memory form the DDR, it will write this info into the
PRU and it will work. But, because of DDR access latencies, the UART
will work only for lower baud rates. 
