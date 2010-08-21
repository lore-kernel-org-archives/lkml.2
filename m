Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752083Ab0HUSyI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 14:54:08 -0400
Received: from many.many.be ([94.23.232.144]:58768 "EHLO many.many.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751373Ab0HUSyH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 14:54:07 -0400
X-Greylist: delayed 408 seconds by postgrey-1.27 at vger.kernel.org; Sat, 21 Aug 2010 14:54:07 EDT
Message-ID: <4C702070.5020809@jungers.net>
Date: Sat, 21 Aug 2010 20:52:32 +0200
From: Nicolas Jungers <nicolas@jungers.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Lightning/1.0pre Thunderbird/3.0.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: possible esata regression in 2.6.35
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My arm box doesn't succeed to use my esata port multiplier (addonics 
sil3726 based).  It was working well with 2.6.34.1 and 2.6.34.4 but not 
with both 2.6.35.2 and 2.6.35.3.  I haven't test other kernels.

The kernels are from http://sheeva.with-linux.com/sheeva/ with for 
example the following config 
http://sheeva.with-linux.com/sheeva/2.6.35.3/sheeva-2.6.35.3.config

The symptoms are in the console a loop on the esata links.  Here is the 
start of it:

ata2: exception Emask 0x10 SAct 0x0 SErr 0x4010000 action 0xe frozen
ata2: edma_err_cause=00000010 pp_flags=00000000, dev connect
ata2: SError: { PHYRdyChg DevExch }
ata2: hard resetting link
ata2: SATA link up 3.0 Gbps (SStatus 123 SControl F300)
ata2.15: Port Multiplier 1.1, 0x1095:0x3726 r23, 6 ports, feat 0x1/0x9
ata2.00: hard resetting link
ata2.01: hard resetting link
ata2.02: hard resetting link
ata2.03: hard resetting link
ata2.04: hard resetting link
ata2.05: hard resetting link
ata2.00: qc timeout (cmd 0xec)
ata2.00: failed to IDENTIFY (I/O error, err_mask=0x4)
ata2.15: hard resetting link
ata2.15: SATA link up 3.0 Gbps (SStatus 123 SControl F300)
ata2.00: hard resetting link
ata2.01: hard resetting link
ata2.02: hard resetting link
ata2.04: hard resetting link
ata2.05: hard resetting link
ata2.00: qc timeout (cmd 0xec)
ata2.00: failed to IDENTIFY (I/O error, err_mask=0x4)
ata2.15: hard resetting link
ata2.15: SATA link up 3.0 Gbps (SStatus 123 SControl F300)
ata2.00: hard resetting link
ata2.01: hard resetting link
ata2.02: hard resetting link
ata2.03: hard resetting link
ata2.04: hard resetting link
ata2.05: hard resetting link
ata2.00: qc timeout (cmd 0xec)
ata2.00: failed to IDENTIFY (I/O error, err_mask=0x4)
ata2.00: failed to recover link after 3 tries, disabling
ata2.15: hard resetting link
ata2.15: SATA link up 3.0 Gbps (SStatus 123 SControl F300)

N.
