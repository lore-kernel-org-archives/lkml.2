Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844Ab0HWWO4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 18:14:56 -0400
Received: from atl.turmel.org ([74.117.157.138]:41686 "EHLO atl.turmel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754326Ab0HWWOz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 18:14:55 -0400
X-Greylist: delayed 1101 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Aug 2010 18:14:55 EDT
Message-ID: <4C72EE8F.3040708@turmel.org>
Date: Mon, 23 Aug 2010 17:56:31 -0400
From: Phil Turmel <philip@turmel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100815 Lightning/1.0b2 Thunderbird/3.1.2
MIME-Version: 1.0
To: Eric.Valette@Free.fr
CC: linux-kernel@vger.kernel.org
Subject: Re: Please add generic support for root=UUID= at kernel parameter
 command line (LABEL, BYID maybe also)
References: <4C728790.7050805@Free.fr>
In-Reply-To: <4C728790.7050805@Free.fr>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Adding cut CC...  sorry about the duplicate)

Hi Eric,

On 08/23/2010 10:37 AM, Eric Valette wrote:
> Hi,
> 
> I just bought an new external disk enclosure with e-sata/USB2 connector to replace an old USB2 only external disk enclosure.
> 
> My internal drive is a small SSD because I use the small factor PC as a home theater and do want silence and fast boot. I build my own kernel to put only what I need in and also boot somehow faster.
> 
> I use grub2 (up to date) as a loader. As soon as I power on the external sata disk, the system does not boot because hardware designer add the great idea to put the internal sata connector on ata3 whereas the external e-sata is wired on ata2.
> 
> consequence is that root file system is on sda1 when no external drive is connected and sdb1 when the external drive is connected.
> 
> As my grub setup was having a root=/dev/sda1 command line parameter and it was advertised everywhere that root=UUID=xxxxx was now supported, I changed the line to discover that this only work if an initramfs was loaded because support is done entirely in used space! Reading init/do_mounts.c made it very clear.
> 
> I find it extremely curious to have to add an initramfs to support dynamic drive identification, especially when the BYID value is displayed during boot message.
> 
> The boot loader cannot do a better job than the kernel and its life may be even worse as bios value for the same disk may change according to boot disk priorities.
> 
> Any hint comment? Any other way to avoid using a ramdisk? Please CC me as I'm not subscribed.

Your only alternative is to set up your root partition as an mdraid volume (single-disk raid0 perhaps), mark it type 'fd' so the kernel can auto-assemble it, and specify "root=/dev/md1" (or whatever minor number you set it up as).

Of course, adding an mdraid shim in between your bare device and the filesystem can reduce performance and/or data integrity for no other gain, and slow booting by the time taken examining all partitions.

I actually set up the above once when the ide => libata change-over was pending, since I was determined to NOT use an initramfs.  It worked, but I don't recommend it.

I recently converted all of my other auto-assembly mdraid systems to initramfs w/ the new dracut tool.  Simple, flawless (for me), and fast.

HTH,

Phil
