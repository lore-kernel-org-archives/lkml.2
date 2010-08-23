Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328Ab0HWNma (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 09:42:30 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:48397 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753306Ab0HWNm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 09:42:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=PNUk56++h9/rOL7W8cHHnYj2MB6PMSR4IvP0NJ4A0DIpfyTxTks+UhnG59VGM+Uo7q
         GNa7Ojpdmd0UZnNmpvU75B9OS2awycRUurwapTnqanpUp8Id9uDfE56UOBAZH5UHSZx/
         B8qm8QWjkFGrSxlnKWQPIMAxtMgmYIEE3Gh/U=
MIME-Version: 1.0
Date: Mon, 23 Aug 2010 15:42:25 +0200
Message-ID: <AANLkTimSKenWEDkMZ-MAHGWMyGvq9+MGXtNqHAZHM_oE@mail.gmail.com>
Subject: ACPI stuck for 45s at boot
From: Martin Pirker <lkml.collector@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi..
My kernel (2.6.35) gets stuck at boot, as dmesg documents:
....
[    0.006590] ACPI: Core revision 20100121
[   45.278951] DMAR: Host address width 36
...


Setting acpi debugging to give-me-all-you-can produces ~120Mb dump.
The interesting part appears to be:

.....
[   36.016976] Table [SSDT](id 0006) - 28 Objects with 0 Devices 21
Methods 0 Regions
[   36.017120]   dsinit-0214 [ffffffff81a32020] [00]
ds_initialize_objects : 21 Methods, 0 Regions
[   36.017292]   nsload-0136 [ffffffff81a32020] [00] ns_load_table
    : **** Completed Table Method Parsing and Object Initialization
[   36.017477]  utmutex-0247 [ffffffff81a32020] [00] ut_acquire_mutex
    : Thread ffffffff81a32020 attempting to acquire Mutex
[ACPI_MTX_Tables]
[   36.017666]      osl-0879 [ffffffff81a32020] [00] os_wait_semaphore
    : Waiting for semaphore[ffff88013341e120|1|65535]
[   36.017848]      osl-0898 [ffffffff81a32020] [00] os_wait_semaphore
    : Acquired semaphore[ffff88013341e120|1|65535] utmutex-0255
[ffffffff81a32020] [00] ut_acquire_mutex      : Thread
ffffffff81a32020 acquired Mutex [ACPI_MTX_Tables]
[   36.018189]  tbxface-0610 [ffffffff81a32020] [00] tb_load_namespace
    : ACPI Tables successfully acquired
[   36.018366]  utmutex-0289 [ffffffff81a32020] [00] ut_release_mutex
    : Thread ffffffff81a32020 releasing Mutex [ACPI_MTX_Tables]
[   36.018552]      osl-0918 [ffffffff81a32020] [00]
os_signal_semaphore   : Signaling semaphore[ffff88013341e120|1]
[   36.018733]  utxface-0141 [ffffffff81a32020] [00] enable_subsystem
    : [Init] Going into ACPI mode
[   36.018912]  hwvalid-0147 [ffffffff81a32020] [00]
hw_validate_io_request: Address 0000000000001004 LastAddress
0000000000001005 Length 2  hwregs-0188 [ffffffff81a32020] [00] hw_read
              : Read:  00001C00 width 16 from 0000000000001004
(SystemIO)
[   36.019290]  hwxface-0344 [ffffffff81a32020] [00] read_bit_register
    : BitReg E, ParentReg 3, Actual 00001C00, ReturnValue 00000000
[   36.019477]  hwvalid-0147 [ffffffff81a32020] [00]
hw_validate_io_request: Address 0000000000001004 LastAddress
0000000000001005 Length 2  hwregs-0188 [ffffffff81a32020] [00] hw_read
              : Read:  00001C00 width 16 from 0000000000001004
(SystemIO)
[   36.019849]  hwxface-0344 [ffffffff81a32020] [00] read_bit_register
    : BitReg E, ParentReg 3, Actual 00001C00, ReturnValue 00000000
[   36.020036]  hwvalid-0147 [ffffffff81a32020] [00]
hw_validate_io_request: Address 00000000000000b2 LastAddress
00000000000000b2 Length 1  hwacpi-0101 [ffffffff81a32020] [00]
hw_set_mode           : Attempting to enable ACPI mode
[   81.259054]  hwvalid-0147 [ffffffff81a32020] [00]
hw_validate_io_request: Address 0000000000001004 LastAddress
0000000000001005 Length 2  hwregs-0188 [ffffffff81a32020] [00] hw_read
              : Read:  00001C01 width 16 from 0000000000001004
(SystemIO)
[   81.259418]  hwxface-0344 [ffffffff81a32020] [00] read_bit_register
    : BitReg E, ParentReg 3, Actual 00001C01, ReturnValue 00000001
[   81.259604]  utmutex-0247 [ffffffff81a32020] [00] ut_acquire_mutex
    : Thread ffffffff81a32020 attempting to acquire Mutex
[ACPI_MTX_Tables]
[   81.259794]      osl-0879 [ffffffff81a32020] [00] os_wait_semaphore
    : Waiting for semaphore[ffff88013341e120|1|65535]
[   81.259976]      osl-0898 [ffffffff81a32020] [00] os_wait_semaphore
    : Acquired semaphore[ffff88013341e120|1|65535] utmutex-0255
[ffffffff81a32020] [00] ut_acquire_mutex      : Thread
ffffffff81a32020 acquired Mutex [ACPI_MTX_Tables]
[   81.260336]  utmutex-0289 [ffffffff81a32020] [00] ut_release_mutex
    : Thread ffffffff81a32020 releasing Mutex [ACPI_MTX_Tables]
[   81.260523]      osl-0918 [ffffffff81a32020] [00]
os_signal_semaphore   : Signaling semaphore[ffff88013341e120|1]
[   81.260704] ftrace: converting mcount calls to 0f 1f 44 00 00
[   81.260771] ftrace: allocating 21295 entries in 84 pages
[   81.268939] DMAR: Host address width 36
.....


So....
What is happening here and whose fault is it?
Is it a Linux kernel or ACPI firmware problem?

Thanks for any pointers,
Martin
