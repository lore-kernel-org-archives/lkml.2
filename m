Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731Ab2BSTHz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 14:07:55 -0500
Received: from smtp.infotech.no ([82.134.31.41]:57670 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753949Ab2BSTHy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 14:07:54 -0500
Message-ID: <4F414882.6080304@interlog.com>
Date: Sun, 19 Feb 2012 14:07:46 -0500
From: Douglas Gilbert <dgilbert@interlog.com>
Reply-To: dgilbert@interlog.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: SCSI development list <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
CC: =?ISO-8859-1?Q?Dan_Hor=E1k?= <dhorak@redhat.com>,
        Matt Taggart <taggart@debian.org>
Subject: [ANNOUNCE] lsscsi-0.26 released
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lsscsi currently can provide some transport related
identifiers when the --transport (-t) option is used. This
will probably be a target port identifier rather than a LU
name (a.k.a. the WWN). Fetching the LU name has proven
elusive. The most direct way would be to issue an INQUIRY
to get the device identification VPD page but that would
require root permissions. A feature of lsscsi is that it
does not need root permissions (or related tricks).

This version adds a --wwn (-w) option which searches the udev
provided /dev/disk/by-id/wwn-* symlinks. This will find
WWNs (LU names) for disks if udev can find them.


There are two SATA disks in the example below: /dev/sda and
/dev/sdd . /dev/sda is older and has no WWN plus it is
directly connected to a SATA controller on the motherboard.
/dev/sdd has a WNN and is connected via a SAS expander.

# lsscsi
[1:0:0:0]    disk    ATA      ST3320620AS      3.AA  /dev/sda
[6:0:0:0]    enclosu Intel    RES2SV240        0600  -
[6:0:1:0]    disk    SEAGATE  ST33000650SS     0002  /dev/sdb
[6:0:2:0]    disk    SEAGATE  ST32000444SS     0006  /dev/sdc
[6:0:3:0]    disk    ATA      ST3500418AS      CC34  /dev/sdd

# lsscsi -w
[1:0:0:0]    disk                                    /dev/sda
[6:0:0:0]    enclosu                                 -
[6:0:1:0]    disk    0x5000c50033fe58db              /dev/sdb
[6:0:2:0]    disk    0x5000c500215725bf              /dev/sdc
[6:0:3:0]    disk    0x5000c500120bfe84              /dev/sdd

# lsscsi -t
[1:0:0:0]    disk    sata:                           /dev/sda
[6:0:0:0]    enclosu sas:0x5001517e85c3effd          -
[6:0:1:0]    disk    sas:0x5000c50033fe58d9          /dev/sdb
[6:0:2:0]    disk    sas:0x5000c500215725bd          /dev/sdc
[6:0:3:0]    disk    sas:0x5001517e85c3efe2          /dev/sdd


Version 0.26 is available at:
     http://sg.danny.cz/scsi/lsscsi.html
More information can be found on that page including examples
and a Download section for the tarball, Debian and Redhat
packages.

ChangeLog:

Version 0.26 2012/01/31 [svn: r97]
   - add 'fcoe' transport indicator
   - add '--wwn' option, datamine /dev/disk/by-id/wwn*
   - move lsscsi.c into src directory

Version 0.25 2011/05/09 [svn: r92]
...

Doug Gilbert
