Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751989Ab2FFBxF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 21:53:05 -0400
Received: from mga03.intel.com ([143.182.124.21]:40638 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751239Ab2FFBxD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 21:53:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="108326479"
Message-ID: <1338947674.1492.33.camel@rui.sh.intel.com>
Subject: Re: thermal_zone trip_point_0_temp =?ISO-8859-1?Q?200=B0C?=
From: Zhang Rui <rui.zhang@intel.com>
To: Mark <markieb.lists.20090330@gmail.com>
Cc: Clemens Ladisch <clemens@ladisch.de>, linux-kernel@vger.kernel.org
Date: Wed, 06 Jun 2012 09:54:34 +0800
In-Reply-To: <4FCCC92B.3080809@gmail.com>
References: <CABAQT1ChtWVauLisaRk_KpN3JSWsvUXKKWDTAW6yuW-G32vmMw@mail.gmail.com>
	  <4FC9D021.1030207@ladisch.de> <1338778611.1472.265.camel@rui.sh.intel.com>
	 <4FCCC92B.3080809@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 一, 2012-06-04 at 10:41 -0400, Mark wrote:
> Hi Rui,
> 
> Thanks for writing;
> 
> On 06/03/2012 10:56 PM, Zhang Rui wrote:
> > Usually, the critical trip point value is a hard coded number provided
> > by the BIOS.

This is the ASL code for critical trip point in the ACPI table,

            Name (DCRT, 0x127C)

            Method (_CRT, 0, NotSerialized)
            {
                Return (DCRT)
            }

_CRT, the control method which OS evaluates to get the thermal critical
trip point, returns DCRT, which is a hard coded value 0x127C. And this
equals 473.2 K, or 200C.

So I do not see ACPI thermal does anything wrong here.

> 200° though, possibly the kernel should set a default upper limit, unless there's
> a rational reason

you can use module parameter thermal.crt= to override the critical trip
point.
But I'm not sure if kernel should set a default upper limit or not.
Maybe we need another entry for this laptop in thermal_dmi_table.

> > About fan control, it seems that there is no ACPI FAN on this machine,
> > so the fan may be controlled either by firmware or by some platform
> > specific driver.
> > To make a double check, it would be great if you can refer to
> > http://www.lesswatts.org/projects/acpi/utilities.php
> > to get the acpidump output of this machine.
> >
> > thanks,
> > rui
> 
> I'm tending to a similar conclusion, it looks as though that's generally the case
> with many Aspires; there is a script for poking the hardware registers
> http://code.google.com/p/aceracpi/source/browse/trunk/acer_ec/acer_ec.pl referred
> to at http://www.linuxquestions.org/questions/showthread.php?p=4657451 though it
> sounds a somewhat risky/random business without the manufacturers' specifications
> at the ready
> 
> there are 2-3 symbols in the ACPI that may be relevant, FANG, FANW, possibly
> FANU; I attach the relevant files
> 
FANG/FANW/FANU can be used for fan control?
I do not know what these mean as they are not ACPI pre-defined control
method.
But if all the Aspires machines follow the same rule, then maybe we need
a kernel Acer platform driver that handles this.

thanks,
rui


