Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756805Ab0DOUs4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 16:48:56 -0400
Received: from fanny.its.uu.se ([130.238.4.241]:59456 "EHLO fanny.its.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756776Ab0DOUsz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 16:48:55 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19399.31662.714469.619828@pilspetsen.it.uu.se>
Date: Thu, 15 Apr 2010 22:48:46 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: "Justin P. mattock" <justinmattock@gmail.com>
Cc: Mikael Pettersson <mikpe@it.uu.se>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [BUG] 2.6.34-rc4: acpi boot-time oops on FSC Amilo Pa 3553
In-Reply-To: <4BC774EA.1020002@gmail.com>
References: <19399.23074.26023.534765@pilspetsen.it.uu.se>
	<4BC76645.50401@gmail.com>
	<19399.29421.508520.647456@pilspetsen.it.uu.se>
	<4BC774EA.1020002@gmail.com>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin P. mattock writes:
 > On 04/15/2010 01:11 PM, Mikael Pettersson wrote:
 > > Justin P. mattock writes:
 > >   >  On 04/15/2010 11:25 AM, Mikael Pettersson wrote:
 > >   >  >  Kernels up to and including 2.6.34-rc3 boot fine on my Amilo Pa 3553,
 > >   >  >  but 2.6.34-rc4 always oopses during boot in acpi.  Without a serial port
 > >   >  >  I cannot capture the entire oops, but it goes something like this:
 > >   >  >
 > >   >  >  __driver_attach
 > >   >  >  bus_for_each_dev
 > >   >  >  driver_attach
 > >   >  >  __driver_attach
 > >   >  >  bus_add_driver
 > >   >  >  acpi_device_remove
 > >   >  >  driver_register
 > >   >  >  async_thread
 > >   >  >  proc_mkdir_mode
 > >   >  >  async_thread
 > >   >  >  acpi_battery_init_async
 > >   >  >  async_thread
 > >   >  >  schedule
 > >   >  >  default_wake_function
 > >   >  >  async_thread
 > >   >  >  kthread
 > >   >  >  kthread
 > >   >  >  kernel_thread_helper
 > >   >  >  EIP: acpi_ex_read_data_from_field+0x16e
 > >   >  >
 > >   >  >  Any suggestions for revisions to try to revert?
 > >   >  >  --
 > >   >  >  To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
 > >   >  >  the body of a message to majordomo@vger.kernel.org
 > >   >  >  More majordomo info at  http://vger.kernel.org/majordomo-info.html
 > >   >  >  Please read the FAQ at  http://www.tux.org/lkml/
 > >   >  >
 > >   >
 > >   >
 > >   >  sounds similar to this:
 > >   >  https://bugzilla.kernel.org/show_bug.cgi?id=%2015749
 > >   >  if so try the patch there and see if
 > >   >  you can boot.
 > >
 > > Yes, that patch (https://bugzilla.kernel.org/attachment.cgi?id=25962)
 > > fixed the problem.  Thanks.
 > >
 > > /Mikael
 > >
 > 
 > cool.. if you can send a post on the bug report
 > so they know, and can push that patch forward
 > and so forth.

I've added a note to 15749 that the patch also fixed my machine.
