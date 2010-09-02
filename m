Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753495Ab0IBSEz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 14:04:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45169 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752356Ab0IBSEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 14:04:53 -0400
Date: Thu, 2 Sep 2010 11:09:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Martin Pirker <lkml.collector@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: Re: ACPI stuck for 45s at boot
Message-Id: <20100902110919.a247d287.akpm@linux-foundation.org>
In-Reply-To: <AANLkTimSKenWEDkMZ-MAHGWMyGvq9+MGXtNqHAZHM_oE@mail.gmail.com>
References: <AANLkTimSKenWEDkMZ-MAHGWMyGvq9+MGXtNqHAZHM_oE@mail.gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc linux-acpi)

Probably raising a report against acpi at bugzilla.kernel.org would be
the best way to handle this, please.  The ACPI guys use bugzilla very
well.


On Mon, 23 Aug 2010 15:42:25 +0200 Martin Pirker <lkml.collector@gmail.com> wrote:

> Hi..
> My kernel (2.6.35) gets stuck at boot, as dmesg documents:
> ....
> [    0.006590] ACPI: Core revision 20100121
> [   45.278951] DMAR: Host address width 36
> ...
> 
> 
> Setting acpi debugging to give-me-all-you-can produces ~120Mb dump.
> The interesting part appears to be:
> 
> .....
> [   36.016976] Table [SSDT](id 0006) - 28 Objects with 0 Devices 21
> Methods 0 Regions
> [   36.017120]   dsinit-0214 [ffffffff81a32020] [00]
> ds_initialize_objects : 21 Methods, 0 Regions
> [   36.017292]   nsload-0136 [ffffffff81a32020] [00] ns_load_table
>     : **** Completed Table Method Parsing and Object Initialization
> [   36.017477]  utmutex-0247 [ffffffff81a32020] [00] ut_acquire_mutex
>     : Thread ffffffff81a32020 attempting to acquire Mutex
> [ACPI_MTX_Tables]
> [   36.017666]      osl-0879 [ffffffff81a32020] [00] os_wait_semaphore
>     : Waiting for semaphore[ffff88013341e120|1|65535]
> [   36.017848]      osl-0898 [ffffffff81a32020] [00] os_wait_semaphore
>     : Acquired semaphore[ffff88013341e120|1|65535] utmutex-0255
> [ffffffff81a32020] [00] ut_acquire_mutex      : Thread
> ffffffff81a32020 acquired Mutex [ACPI_MTX_Tables]
> [   36.018189]  tbxface-0610 [ffffffff81a32020] [00] tb_load_namespace
>     : ACPI Tables successfully acquired
> [   36.018366]  utmutex-0289 [ffffffff81a32020] [00] ut_release_mutex
>     : Thread ffffffff81a32020 releasing Mutex [ACPI_MTX_Tables]
> [   36.018552]      osl-0918 [ffffffff81a32020] [00]
> os_signal_semaphore   : Signaling semaphore[ffff88013341e120|1]
> [   36.018733]  utxface-0141 [ffffffff81a32020] [00] enable_subsystem
>     : [Init] Going into ACPI mode
> [   36.018912]  hwvalid-0147 [ffffffff81a32020] [00]
> hw_validate_io_request: Address 0000000000001004 LastAddress
> 0000000000001005 Length 2  hwregs-0188 [ffffffff81a32020] [00] hw_read
>               : Read:  00001C00 width 16 from 0000000000001004
> (SystemIO)
> [   36.019290]  hwxface-0344 [ffffffff81a32020] [00] read_bit_register
>     : BitReg E, ParentReg 3, Actual 00001C00, ReturnValue 00000000
> [   36.019477]  hwvalid-0147 [ffffffff81a32020] [00]
> hw_validate_io_request: Address 0000000000001004 LastAddress
> 0000000000001005 Length 2  hwregs-0188 [ffffffff81a32020] [00] hw_read
>               : Read:  00001C00 width 16 from 0000000000001004
> (SystemIO)
> [   36.019849]  hwxface-0344 [ffffffff81a32020] [00] read_bit_register
>     : BitReg E, ParentReg 3, Actual 00001C00, ReturnValue 00000000
> [   36.020036]  hwvalid-0147 [ffffffff81a32020] [00]
> hw_validate_io_request: Address 00000000000000b2 LastAddress
> 00000000000000b2 Length 1  hwacpi-0101 [ffffffff81a32020] [00]
> hw_set_mode           : Attempting to enable ACPI mode
> [   81.259054]  hwvalid-0147 [ffffffff81a32020] [00]
> hw_validate_io_request: Address 0000000000001004 LastAddress
> 0000000000001005 Length 2  hwregs-0188 [ffffffff81a32020] [00] hw_read
>               : Read:  00001C01 width 16 from 0000000000001004
> (SystemIO)
> [   81.259418]  hwxface-0344 [ffffffff81a32020] [00] read_bit_register
>     : BitReg E, ParentReg 3, Actual 00001C01, ReturnValue 00000001
> [   81.259604]  utmutex-0247 [ffffffff81a32020] [00] ut_acquire_mutex
>     : Thread ffffffff81a32020 attempting to acquire Mutex
> [ACPI_MTX_Tables]
> [   81.259794]      osl-0879 [ffffffff81a32020] [00] os_wait_semaphore
>     : Waiting for semaphore[ffff88013341e120|1|65535]
> [   81.259976]      osl-0898 [ffffffff81a32020] [00] os_wait_semaphore
>     : Acquired semaphore[ffff88013341e120|1|65535] utmutex-0255
> [ffffffff81a32020] [00] ut_acquire_mutex      : Thread
> ffffffff81a32020 acquired Mutex [ACPI_MTX_Tables]
> [   81.260336]  utmutex-0289 [ffffffff81a32020] [00] ut_release_mutex
>     : Thread ffffffff81a32020 releasing Mutex [ACPI_MTX_Tables]
> [   81.260523]      osl-0918 [ffffffff81a32020] [00]
> os_signal_semaphore   : Signaling semaphore[ffff88013341e120|1]
> [   81.260704] ftrace: converting mcount calls to 0f 1f 44 00 00
> [   81.260771] ftrace: allocating 21295 entries in 84 pages
> [   81.268939] DMAR: Host address width 36
> .....
> 
> 
> So....
> What is happening here and whose fault is it?
> Is it a Linux kernel or ACPI firmware problem?
> 
> Thanks for any pointers,
> Martin
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
