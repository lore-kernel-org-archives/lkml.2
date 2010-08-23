Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058Ab0HWPRk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 11:17:40 -0400
Received: from p-mail1.rd.francetelecom.com ([195.101.245.15]:32409 "EHLO
	p-mail1.rd.francetelecom.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753901Ab0HWPRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 11:17:38 -0400
X-Greylist: delayed 2114 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Aug 2010 11:17:38 EDT
Message-ID: <4C728145.4030808@Free.fr>
Date: Mon, 23 Aug 2010 16:10:13 +0200
From: Eric Valette <Eric.Valette@Free.fr>
Reply-To: Eric.Valette@Free.fr
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.8) Gecko/20100821 Lightning/1.0b2 Icedove/3.1.2
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Please add generic support for root=UUID= at kernel parameter command
 line (LABEL, BYID maybe also)
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Aug 2010 14:10:13.0774 (UTC) FILETIME=[E7ABAAE0:01CB42CC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I just bought an new external disk enclosure with e-sata/USB2 connector 
to replace an old USB2 only external disk enclosure.

My internal drive is a small SSD because I use the small factor PC as a 
home theater and do want silence and fast boot. I build my own kernel to 
put only what I need in and also boot somehow faster.

I use grub2 (up to date) as a loader. As soon as I power on the external 
sata disk, the system does not boot because hardware designer add the 
great idea to put the internal sata connector on ata3 whereas the 
external e-sata is wired on ata2.

consequence is that root file system is on sda1 when no external drive 
is connected and sdb1 when the external drive is connected.

As my grub setup was having a root=/dev/sda1 command line parameter and 
it was advertised everywhere that root=UUID=xxxxx was now supported, I 
changed the line to discover that this only work if an initramfs was 
loaded because support is done entirely in used space! Reading 
init/do_mounts.c made it very clear.

I find it extremely curious to have to add an initramfs to support 
dynamic drive identification, especially when the BYID value is 
displayed during boot message.

The boot loader cannot do a better job than the kernel and its life may 
be even worse as bios value for the same disk may change according to 
boot disk priorities.

Any hint comment? Any other way to avoid using a ramdisk? Please CC me 
as I'm not subscribed.

-- eric



