Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063Ab0FOHD6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 03:03:58 -0400
Received: from dtp.xs4all.nl ([80.101.171.8]:29869 "HELO abra2.bitwizard.nl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752777Ab0FOHD5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 03:03:57 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Jun 2010 03:03:56 EDT
Date: Tue, 15 Jun 2010 08:57:14 +0200
From: Rogier Wolff <R.E.Wolff@BitWizard.nl>
To: Alan <alan@clueserver.org>
Cc: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org
Subject: Re: Question on siig sata 3 controller
Message-ID: <20100615065714.GA9034@bitwizard.nl>
References: <34979.10.6.6.23.1276144792.squirrel@10.6.6.2> <4C10A81F.50801@garzik.org> <54318.10.6.6.23.1276222123.squirrel@10.6.6.2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54318.10.6.6.23.1276222123.squirrel@10.6.6.2>
Organization: BitWizard.nl
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 10, 2010 at 07:08:43PM -0700, Alan wrote:
> When writing large amounts of data I see messages like the following:

yeah! I'm trying to write some 2.5Tb to my raid array, where 2 of 8
disks are connected to an Asus U3S6 board.
   http://www.asus.com/product.aspx?P_ID=lGYmelQ8mJvPtYTv

After a while, those two disks bomb out, and make the raid
inaccessible.

A reboot brings the disks back to life. So in theory, Linux should be
able to restore life into these drives by doing the right magic with
the hardware bits... 

I'm running 2.6.34: 

Linux version 2.6.34 (root@zebigbos) (gcc version 3.4.2) #3 SMP Mon May 17 21:04:13 CEST 2010


Log file entries: 

ata5.00: exception Emask 0x0 SAct 0xfff SErr 0x0 action 0x6 frozen
ata5.00: failed command: READ FPDMA QUEUED
ata5.00: cmd 60/a8:00:f6:12:10/00:00:0d:00:00/40 tag 0 ncq 86016 in
         res 40/00:14:ee:98:bb/00:00:0a:00:00/40 Emask 0x4 (timeout)
ata5.00: status: { DRDY }
...
ata5.00: failed command: READ FPDMA QUEUED
ata5.00: cmd 60/a0:58:ee:19:10/00:00:0d:00:00/40 tag 11 ncq 81920 in
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata5.00: status: { DRDY }
ata5: hard resetting link
ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 370)
ata5.00: configured for UDMA/133
ata5.00: device reported invalid CHS sector 0
*last message repeated 10 times
ata5: EH complete

(all tags 1...10 are aalso listed.)

This seems "harmless", it happend a few times the last hour or so
(during the rebuild). 

When things went bad last time I got: 

one of these "harmless events" (but this time with 31 tags listed!): 

Jun 14 18:26:23 vercingetorix kernel: ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 370)

and then 5 seconds later: 

ata5.00: qc timeout (cmd 0xec)
ata5.00: failed to IDENTIFY (I/O error, err_mask=0x4)
ata5.00: revalidation failed (errno=-5)
ata5: hard resetting link
ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 370)
ata5.00: qc timeout (cmd 0xec)
ata5.00: failed to IDENTIFY (I/O error, err_mask=0x4)


	Roger. 

-- 
** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
**    Delftechpark 26 2628 XH  Delft, The Netherlands. KVK: 27239233    **
*-- BitWizard writes Linux device drivers for any device you may have! --*
Q: It doesn't work. A: Look buddy, doesn't work is an ambiguous statement. 
Does it sit on the couch all day? Is it unemployed? Please be specific! 
Define 'it' and what it isn't doing. --------- Adapted from lxrbot FAQ
