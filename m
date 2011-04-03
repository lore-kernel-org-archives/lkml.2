Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480Ab1DCX5p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Apr 2011 19:57:45 -0400
Received: from mx.treblig.org ([80.68.94.177]:36834 "EHLO mx.treblig.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752527Ab1DCX5o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Apr 2011 19:57:44 -0400
X-Greylist: delayed 2318 seconds by postgrey-1.27 at vger.kernel.org; Sun, 03 Apr 2011 19:57:44 EDT
Date: Mon, 4 Apr 2011 00:19:02 +0100
From: "Dr. David Alan Gilbert" <linux@treblig.org>
To: linux-kernel@vger.kernel.org
Cc: joe@perches.com, segooon@gmail.com, randy.dunlap@oracle.com,
        russ.gorby@intel.com, akpm@linux-foundation.org
Subject: Outstanding patches for errors picked up via sparse
Message-ID: <20110403231902.GB25913@gallifrey>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/2.6.32.27-kvm-i386-20110114 (i686)
X-Uptime: 00:08:30 up 45 days, 41 min,  1 user,  load average: 0.00, 0.00,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
  I've been trawling through sparse logs for a few months now, and I've noticed
that there are a few fixes for errors that have been out there for a while.
This mail summarises those, so anyone else trawling through sparse knows not to
bother digging.

Note that these all fix actual screwups as opposed to just removing warnings.

(It would also be nice if it gently pushed them forward into the main kernel)

Dave
--
Fixed by Joe Perches 2010-10-31:

https://lkml.org/lkml/2010/10/31/123 (resent as https://lkml.org/lkml/2010/11/2/278)
Swapped kmalloc parameters:

drivers/scsi/pmcraid.c:4100:23: warning: incorrect type in argument 1 (different base types)
drivers/scsi/pmcraid.c:4100:23:    expected unsigned long [unsigned] [usertype] size
drivers/scsi/pmcraid.c:4100:23:    got restricted gfp_t
drivers/scsi/pmcraid.c:4100:35: warning: incorrect type in argument 2 (different base types)
drivers/scsi/pmcraid.c:4100:35:    expected restricted gfp_t [usertype] flags
drivers/scsi/pmcraid.c:4100:35:    got unsigned long


        hdr = kmalloc(GFP_KERNEL, sizeof(struct pmcraid_ioctl_header));

--
Fix by Vasiliy Kulikov 2010-09-12

https://patchwork.kernel.org/patch/173492/
http://liquorix.net/sources/patches/suse/patches.fixes/acpi_ec_sys_access_user_space_with_get_user.patch

missing get_user/put_user

drivers/acpi/ec_sys.c:46:21: warning: cast removes address space of expression
drivers/acpi/ec_sys.c:77:21: warning: cast removes address space of expression

--

Fixed by Randy Dunlap 2010-06-07
http://kerneltrap.org/mailarchive/linux-scsi/2010/6/8/6885298

minor firmware version printing problem:

drivers/scsi/megaraid.c:313:65: warning: right shift by bigger than source value
drivers/scsi/megaraid.c:315:65: warning: right shift by bigger than source value
drivers/scsi/megaraid.c:319:67: warning: right shift by bigger than source value
drivers/scsi/megaraid.c:321:67: warning: right shift by bigger than source value

                         adapter->product_info.fw_version[1] >> 8,
                         adapter->product_info.fw_version[1] & 0x0f,
                         adapter->product_info.fw_version[0] >> 8,
                         adapter->product_info.fw_version[0] & 0x0f);
                sprintf (adapter->bios_version, "%c%d%d.%d%d",
                         adapter->product_info.bios_version[2],
                         adapter->product_info.bios_version[1] >> 8,
                         adapter->product_info.bios_version[1] & 0x0f,
                         adapter->product_info.bios_version[0] >> 8,
                         adapter->product_info.bios_version[0] & 0x0f);

yet megaraid.h has:
        u8      fw_version[16];         /* printable ASCI string */
        u8      bios_version[16];       /* printable ASCI string */

Although you do have to wonder if the comment is right there then maybe the sprintf
is more wrong than the fix fixes.

--
Fix by Russ Gorby 2010-11-24
http://www.mail-archive.com/meego-kernel@lists.meego.com/msg00692.html


drivers/tty/serial/ifx6x60.c:354:31: warning: right shift by bigger than source value
drivers/tty/serial/ifx6x60.c:355:39: warning: right shift by bigger than source value
  Those are masking an 8 bit byte from a buffer but those are testing bits after 8th bit

Note that Russ's patch is a bit more complex and doesn't just fix that test.

-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    |       Running GNU/Linux       | Happy  \ 
\ gro.gilbert @ treblig.org |                               | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/
